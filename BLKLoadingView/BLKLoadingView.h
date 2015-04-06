//
//  BLKLoadingView.h
//  BLKLoadingView
//
//  Created by Ryuta Kibe on 2015/04/05.
//  Copyright (c) 2015 blk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLKLoadingView : UIView

@property (nonatomic, weak) IBOutlet UIView *hudView;
@property (nonatomic, weak) IBOutlet UIView *hudContainerView;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) UIColor *hudBackgroundColor;
@property (nonatomic) BOOL isRotation;
@property (nonatomic) BOOL isModal;

+ (BLKLoadingView*) sharedView;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)showInView:(UIView *)view message:(NSString *)message animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)replaceHudView:(UIView *)hudView;

@end
