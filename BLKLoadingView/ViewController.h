//
//  ViewController.h
//  BLKLoadingView
//
//  Created by Ryuta Kibe on 2015/04/05.
//  Copyright (c) 2015 blk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLKLoadingView;

@interface ViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *rotationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundSwitch;
@property (weak, nonatomic) IBOutlet UIButton *buttonShow;

- (IBAction)rotationChanged:(id)sender;
- (IBAction)animationChanged:(id)sender;
- (IBAction)messageChanged:(id)sender;
- (IBAction)backgroundChanged:(id)sender;
- (IBAction)buttonShowWasTouched:(id)sender;

@end

