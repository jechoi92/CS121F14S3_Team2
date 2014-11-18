//
//  MainMenuViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuViewController.h"
#import "LevelSelectViewController.h"
#import "InstructionsViewController.h"

@implementation MainMenuViewController
{
    MainMenuButtonsView *_buttonsView;
    UIImageView *_titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
  
    // Get frame stats
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);
    CGFloat frameWidth  = CGRectGetWidth(self.view.frame);
    
    // Title image
    UIImage *titleImage =[UIImage imageNamed:@"logo.png"];
    CGFloat titleXOffset = (frameWidth-titleImage.size.width)/2;
    CGFloat titleYOffset = 220;
    _titleView = [[UIImageView alloc] initWithFrame:CGRectMake(titleXOffset, titleYOffset, titleImage.size.width, titleImage.size.height)];
    [_titleView setImage:titleImage];
    [self.view addSubview:_titleView];
    
    CGFloat buttonsFramePctWidth = 0.25;
    CGFloat buttonsFramePctHeight = 0.40;
    
    // Set up frame for buttons
    CGFloat buttonsFrameHeight = frameHeight * buttonsFramePctHeight;
    CGFloat buttonsFrameWidth = frameWidth * buttonsFramePctWidth;
    // Center the buttons frame
    CGFloat buttonsFrameYOffset = titleYOffset+titleImage.size.height+30;
    CGFloat buttonsFrameXOffset = (frameWidth/2)-(buttonsFrameWidth/2);
    
    CGRect buttonsFrame = CGRectMake(buttonsFrameXOffset, buttonsFrameYOffset, buttonsFrameWidth, buttonsFrameHeight);
    
    // Add the subview
    _buttonsView = [[MainMenuButtonsView alloc] initWithFrame:buttonsFrame];
    [_buttonsView setDelegate:self];
    [self.view addSubview: _buttonsView];
    
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
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
            InstructionsViewController *ivc = [[InstructionsViewController alloc] init];
            [self.navigationController pushViewController:ivc animated:YES];
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