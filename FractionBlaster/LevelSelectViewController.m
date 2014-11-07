//
//  LevelSelectViewController.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "LevelButtonView.h"

@implementation LevelSelectViewController
{
  LevelButtonView *_levelButtonView;
}

-(id)init
{
  self = [super init];
  
  // Get frame and frame dimensions
  CGRect frame = self.view.frame;
  CGFloat frameWidth = CGRectGetWidth(frame);
  CGFloat frameHeight = CGRectGetHeight(frame);
  
  // Set up the grid frame, based on a specified percentage of the frame that
  // the grid is supposed to take up
  CGFloat levelViewPctOfFrame = 0.80;
  CGFloat levelViewXOffset = 0.1 * frameWidth;
  CGFloat levelViewYOffset = 0.1 * frameHeight;
  CGFloat levelViewSize = MIN(frameWidth, frameHeight) * levelViewPctOfFrame;
  CGRect levelViewFrame = CGRectMake(levelViewXOffset, levelViewYOffset, levelViewSize, levelViewSize);
  
  // Create gameButton view
  _levelButtonView = [[LevelButtonView alloc] initWithFrame:levelViewFrame];
  [self.view addSubview:_levelButtonView];
  
  return self;
}

@end
