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
    
    CGRect startButtonFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    UIButton *startButton = [[UIButton alloc] initWithFrame:startButtonFrame];
    
    // Set up start button title
    UIImage *btnImage = [UIImage imageNamed:@"launch2.png"];
    [startButton setImage:btnImage forState:UIControlStateNormal];
    
    
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
