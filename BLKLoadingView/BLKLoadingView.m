//
//  BLKLoadingView.m
//  BLKLoadingView
//
//  Created by Ryuta Kibe on 2015/04/05.
//  Copyright (c) 2015 blk. All rights reserved.
//

#import "BLKLoadingView.h"

@implementation BLKLoadingView

+ (BLKLoadingView*)sharedView
{
    static dispatch_once_t once;
    static BLKLoadingView *sharedView;
    dispatch_once(&once, ^{
        NSString *nibName = NSStringFromClass([self class]);
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        sharedView = [nib instantiateWithOwner:nil options:nil][0];
        sharedView.frame = [UIScreen mainScreen].bounds;
        sharedView.backgroundView.layer.cornerRadius = 14;
        sharedView.backgroundView.alpha = 0;
        sharedView.hudContainerView.alpha = 0;
    });
    return sharedView;
}

- (void) showWithAnimated:(BOOL)animated
{
    [self showWithMessage:nil animated:animated];
}

- (void) showWithMessage:(NSString *)message animated:(BOOL)animated
{
    if (!self.superview) {
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;

            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    } else {
        [self.superview bringSubviewToFront:self];
    }

    self.messageLabel.text = message;
    self.hudContainerView.transform = CGAffineTransformIdentity;

    if (self.isRotation) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.fromValue = @0.0;
        anim.toValue = @(2 * M_PI);
        anim.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
        anim.duration = 1;
        anim.repeatCount = HUGE_VALF;

        [self.hudView.layer addAnimation:anim forKey:nil];
    }

    if (animated) {
        self.hudContainerView.transform = CGAffineTransformScale(self.hudContainerView.transform, 2, 2);

        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.hudContainerView.transform = CGAffineTransformScale(self.hudContainerView.transform, 0.5, 0.5);
                             self.hudContainerView.alpha = 1;
                             self.backgroundView.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             [self setNeedsLayout];
                         }];

        [self setNeedsDisplay];
    } else {
        self.hudContainerView.transform = CGAffineTransformIdentity;
        self.hudContainerView.alpha = 1;
        self.backgroundView.alpha = 1;
        [self setNeedsLayout];
    }
}

- (void) dismissWithAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.hudContainerView.transform = CGAffineTransformScale(self.hudContainerView.transform, 0.5, 0.5);
                             self.hudContainerView.alpha = 0;
                             self.backgroundView.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if (self.isRotation) {
                                [self.hudView.layer removeAllAnimations];
                             }
                             [self removeFromSuperview];
                             [self setNeedsLayout];
                         }];

        [self setNeedsDisplay];
    } else {
        self.hudContainerView.transform = CGAffineTransformIdentity;
        self.hudContainerView.alpha = 0;
        self.backgroundView.alpha = 0;
        [self.hudView.layer removeAllAnimations];
        [self removeFromSuperview];
        [self setNeedsLayout];
    }

}

#pragma mark Setter

- (void)replaceHudView:(UIView *)hudView
{
    for (UIView *subview in self.hudContainerView.subviews) {
        [subview removeFromSuperview];
    }

    _hudView = hudView;
    _hudView.frame = self.hudContainerView.bounds;
    [self.hudContainerView addSubview:_hudView];
}

@end
