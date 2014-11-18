//
//  LevelSelectViewController.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LevelSelectViewController.h"

@implementation LevelSelectViewController
{
    LevelButtonView *_levelButtonView;
    StartLevelButtonView *_startLevelButtonView;
    UIButton *_backButton;
}

-(void)viewDidLoad
{
  [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
  
    // Get frame and frame dimensions
    CGRect frame = self.view.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Set up the grid frame, based on a specified percentage of the frame that
    // the grid is supposed to take up
    CGFloat levelViewPctOfFrame = 0.7;
    CGFloat levelViewXOffset = 0.15 * frameWidth;
    CGFloat levelViewYOffset = 0.5 * frameHeight;
    CGFloat levelViewWidth = frameWidth * levelViewPctOfFrame;
    CGFloat levelViewHeight = levelViewWidth * 2 / 5;
    
    // Create LevelDescription View
    CGRect title = CGRectMake(0, -50, frameWidth, frameHeight*.5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"Levels.png"];
    [self.view addSubview:imageView];
    
    CGRect levelViewFrame = CGRectMake(levelViewXOffset, levelViewYOffset, levelViewWidth, levelViewHeight);
    
    // Create gameButton view
    _levelButtonView = [[LevelButtonView alloc] initWithFrame:levelViewFrame];
    [self.view addSubview:_levelButtonView];
    
    // Create GameButtons View
    CGRect startButtonFrame = CGRectMake(frameWidth*.1, frameHeight*.8, frameWidth*.8, frameHeight*.15);
    
    _startLevelButtonView = [[StartLevelButtonView alloc] initWithFrame:startButtonFrame];
    [_startLevelButtonView setDelegate:self];
    [self.view addSubview:_startLevelButtonView];
    
    // Create back button
    [self createTopButtonsAndLabels];
}

- (void)createTopButtonsAndLabels
{
    // TODO: Figure out what to do with this constant
    CGFloat INSET_RATIO = 0.02;
    
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    CGFloat itemWidth = size / 15;
    
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    
    _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[_backButton layer] setBorderWidth:2.5f];
    [[_backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_backButton layer] setCornerRadius:12.0f];
    
    [_backButton addTarget:self action:@selector(backButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backButton];

}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startLevel
{
    int currentLevel = [_levelButtonView currentLevelSelected] + 1;
    GameViewController *gvc = [[GameViewController alloc]
                             initWithLevel:currentLevel andScore:0];
    [self.navigationController pushViewController:gvc animated:YES];
}

@end
