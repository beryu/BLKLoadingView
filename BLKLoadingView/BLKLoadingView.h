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
@property (nonatomic) BOOL isRotation;

+ (BLKLoadingView*) sharedView;
- (void) showWithAnimated:(BOOL)animated;
- (void) showWithMessage:(NSString *)message animated:(BOOL)animated;
- (void) dismissWithAnimated:(BOOL)animated;

@end
