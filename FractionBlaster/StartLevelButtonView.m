//
//  StartLevelButtonView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/9/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "StartLevelButtonView.h"

@implementation StartLevelButtonView

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  int IPAD_FONT_SIZE = 40;
  
  self.backgroundColor = [UIColor blackColor];
  
  CGRect startButtonFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
  UIButton *startButton = [[UIButton alloc] initWithFrame:startButtonFrames];
  startButton.backgroundColor = [UIColor redColor];
  
  // Set up start button title
  [startButton setTitle:@"Start Game" forState:UIControlStateNormal];
  [startButton setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
  startButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                size:IPAD_FONT_SIZE];
  startButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  
  // Set up selector
  [startButton addTarget:self action:@selector(startLevelPressed)
        forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:startButton];
  
  return self;
}

-(void)startLevelPressed
{
  [self.delegate startLevel];
}

@end
