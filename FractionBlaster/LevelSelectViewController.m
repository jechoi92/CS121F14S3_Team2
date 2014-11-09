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
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  
  // Get frame and frame dimensions
  CGRect frame = self.view.frame;
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Set up the grid frame, based on a specified percentage of the frame that
  // the grid is supposed to take up
  CGFloat levelViewPctOfFrame = 0.80;
  CGFloat levelViewXOffset = 0.1 * frameWidth;
  CGFloat levelViewYOffset = 0.1 * frameHeight;
  CGFloat levelViewWidth = frameWidth * levelViewPctOfFrame;
  CGFloat levelViewHeight = levelViewWidth * 2 / 5;
  
  CGRect levelViewFrame = CGRectMake(levelViewXOffset, levelViewYOffset, levelViewWidth, levelViewHeight);
  
  // Create gameButton view
  _levelButtonView = [[LevelButtonView alloc] initWithFrame:levelViewFrame];
  _levelButtonView.backgroundColor = [UIColor blackColor];
  [self.view addSubview:_levelButtonView];
  
  // Create LevelDescription View
  
  // Create GameButtons View
  CGFloat startButtonWidth  = frameWidth/5;
  CGFloat startButtonHeight = 60;
  CGFloat startButtonXOffset = (frameWidth-startButtonWidth)/2;
  CGFloat startButtonYOffset = frameHeight-300;
  CGRect startButtonFrame = CGRectMake(startButtonXOffset, startButtonYOffset, startButtonWidth, startButtonHeight);
  
  _startLevelButtonView = [[StartLevelButtonView alloc] initWithFrame:startButtonFrame];
  [_startLevelButtonView setDelegate:self];
  [self.view addSubview:_startLevelButtonView];
}

-(void)startLevel
{
  int currentLevel = [_levelButtonView currentLevelSelected] + 1;
  NSLog(@"Starting level: %d", currentLevel);
  //GameViewController *gvc = [[AddTaskViewController alloc]
  //          initWithNibName:@"AddTaskView" bundle:nil];
  //[self presentViewController:gvc animated:YES completion:nil];
  // [initWithLevel:[_levelButtonView currentLevelSelected]]
}

@end
