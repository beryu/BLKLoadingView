//
//  ViewController.m
//  BLKLoadingView
//
//  Created by Ryuta Kibe on 2015/04/05.
//  Copyright (c) 2015 blk. All rights reserved.
//

#import "ViewController.h"
#import "BLKLoadingView.h"

@interface ViewController ()

@property(nonatomic, strong) BLKLoadingView *hudView;
@property(nonatomic) BOOL isAnimated;
@property(nonatomic, strong) NSString *message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isAnimated = YES;
    self.message = @"Loading...";
    self.hudView = [BLKLoadingView sharedView];
    self.hudView.isRotation = YES;
    [self.rotationSwitch setOn:YES animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (IBAction)rotationChanged:(id)sender {
    self.hudView.isRotation = self.rotationSwitch.isOn;
}

- (IBAction)animationChanged:(id)sender {
    self.isAnimated = self.animationSwitch.isOn;
}

- (IBAction)messageChanged:(id)sender {
    self.message = self.messageSwitch.isOn ? @"Loading..." : nil;
}

- (IBAction)buttonShowWasTouched:(id)sender {
    [self.hudView showWithMessage:self.message animated:self.isAnimated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hudView dismissWithAnimated:self.isAnimated];
    });
}

@end
