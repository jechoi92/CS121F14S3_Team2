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

// Constant to dtermine the placement of top view icons
static CGFloat INSET_RATIO = 0.02;

// Initialize the level seclect view controller
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background to the default space theme
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    
    // Create level buttons
    [self createLevelButtonView];
    
    // Create title
    [self createLevelTitle];
    
    // Create back button
    [self createTopButtonsAndLabelsWithFrame:self.view.frame];
}

-(void)createLevelButtonView
{
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
    CGRect levelViewFrame = CGRectMake(levelViewXOffset, levelViewYOffset, levelViewWidth, levelViewHeight);
    
    // Create start button with the appropriate delegate
    _levelButtonView = [[LevelButtonView alloc] initWithFrame:levelViewFrame];
    [self.view addSubview:_levelButtonView];
    CGRect startButtonFrame = CGRectMake(frameWidth*.1, frameHeight*.8, frameWidth*.8, frameHeight*.15);
    _startLevelButtonView = [[StartLevelButtonView alloc] initWithFrame:startButtonFrame];
    [_startLevelButtonView setDelegate:self];
    [self.view addSubview:_startLevelButtonView];
}

// Creates the level select title image at the top of the screen
-(void)createLevelTitle
{
    // Get frame and frame dimensions
    CGRect frame = self.view.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(0, -50, frameWidth, frameHeight*.5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"Levels.png"];
    [self.view addSubview:imageView];
}

// Creates the back button on the top of the level view screen
- (void)createTopButtonsAndLabelsWithFrame:(CGRect)frame
{
    // Get all of the parameters of the frame to build the button
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    CGFloat iconParam = size / 15;
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, iconParam, iconParam);
    
    // Initailze the back button with these certain images and and icons
    _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    
    // Set the delegate of when the button is clicked
    [_backButton addTarget:self action:@selector(backButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_backButton];
}

// Tells the navigator controller to pop back to the main menu screen
-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Tells the navigator controller to progress to the game screen
-(void)startLevel
{
    int currentLevel = [_levelButtonView currentLevelSelected] + 1;
    GameViewController *gvc = [[GameViewController alloc]
                             initWithLevel:currentLevel andScore:0];
    [self.navigationController pushViewController:gvc animated:YES];
}

@end
