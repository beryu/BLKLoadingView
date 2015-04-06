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
    });

    return sharedView;
}

- (id)init
{
    if (self = [super init]) {
        [self p_intializeWithFrame:[UIScreen mainScreen].bounds];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self p_intializeWithFrame:[UIScreen mainScreen].bounds];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_intializeWithFrame:frame];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self p_intializeWithFrame:[UIScreen mainScreen].bounds];
}

- (void)p_intializeWithFrame:(CGRect)frame
{
    self.frame = frame;
    self.backgroundView.layer.cornerRadius = 14;
    self.backgroundView.alpha = 0;
    self.hudContainerView.alpha = 0;
    self.isRotation = YES;
    self.isModal = YES;
    self.hudBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.backgroundView.backgroundColor = self.hudBackgroundColor;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [self showInView:view message:nil animated:animated];
}

- (void)showInView:(UIView *)view message:(NSString *)message animated:(BOOL)animated
{
    [view addSubview:self];

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

- (void)dismissAnimated:(BOOL)animated
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

- (void)setIsModal:(BOOL)isModal
{
    _isModal = isModal;
    self.userInteractionEnabled = isModal;
}

- (void)setHudBackgroundColor:(UIColor *)hudBackgroundColor
{
    _hudBackgroundColor = hudBackgroundColor;
    self.backgroundView.backgroundColor = hudBackgroundColor;
}

@end
