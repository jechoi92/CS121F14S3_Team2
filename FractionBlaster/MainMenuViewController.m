//
//  MainMenuViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuViewController.h"
#import "LevelSelectViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Get frame stats
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);
    CGFloat frameWidth  = CGRectGetWidth(self.view.frame);
    CGFloat buttonsFramePctWidth = 0.25;
    CGFloat buttonsFramePctHeight = 0.40;
    
    // Set up frame for buttons
    CGFloat buttonsFrameHeight = frameHeight * buttonsFramePctHeight;
    CGFloat buttonsFrameWidth = frameWidth * buttonsFramePctWidth;
    // Center the buttons frame
    CGFloat buttonsFrameYOffset = (frameHeight/2)-(buttonsFrameHeight/2);
    CGFloat buttonsFrameXOffset = (frameWidth/2)-(buttonsFrameWidth/2);
    
    CGRect buttonsFrame = CGRectMake(buttonsFrameXOffset, buttonsFrameYOffset, buttonsFrameWidth, buttonsFrameHeight);
    
    // Add the subview
    MainMenuButtonsView *mmbv = [[MainMenuButtonsView alloc] initWithFrame:buttonsFrame];
    [mmbv setDelegate:self];
    [self.view addSubview: mmbv];
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    
    // Is there a way to generate a range of cases to check on
    // based on a variable? (generate based on numButtons?)
    switch (tag){
        case 0:
        {
            // Go to LevelSelectViewController
            NSLog(@"Start game pressed");
            LevelSelectViewController *lsvc = [[LevelSelectViewController alloc] init];
            [self.navigationController pushViewController:lsvc animated:YES];
            break;
        }
        case 1:
        {
            // Go to InstrViewController
            NSLog(@"Instr button pressed");
            break;
        }
        case 2:
        {
            // Go to Leaderboard??
            NSLog(@"Leaderboard pressed");
            break;
        }
        default:
        {
            NSLog(@"This button shouldn't exist");
            break;
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end