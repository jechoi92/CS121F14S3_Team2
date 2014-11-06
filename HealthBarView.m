//
//  HealthBarView.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "HealthBarView.h"
#import <QuartzCore/QuartzCore.h>

int NUM_OF_BARS = 5;
int MAX_HEALTH = 100;

@implementation HealthBarView
{
    int _healthLevel;
    NSMutableArray* _healthBar;
}

// Initializes the health bar (array of blank labels) and health level.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _healthLevel = MAX_HEALTH;
        _healthBar = [[NSMutableArray alloc] initWithCapacity:NUM_OF_BARS];
        CGFloat height = CGRectGetHeight(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat labelHeight = height / NUM_OF_BARS;
        
        for (int i = 0; i < NUM_OF_BARS; i++) {
            CGRect labelFrame = CGRectMake(0, i * labelHeight, width, labelHeight);
            UILabel* currentLabel = [[UILabel alloc] initWithFrame:labelFrame];
            
            [self addSubview:currentLabel];
            [_healthBar addObject:currentLabel];
        }
    }
    [self updateHealthBar];
    return self;
}

- (int)getHealthLevel
{
    return _healthLevel;
}

// Sets health level and then updates the health bar.
- (void)setHealthLevel: (int)healthLevel
{
    _healthLevel = healthLevel;
    [self updateHealthBar];
}

// Updates the health bar by setting appropriate background colors.
- (void)updateHealthBar
{
    float level = (float) _healthLevel / (float) MAX_HEALTH * NUM_OF_BARS;
    for (int i = 0; i < NUM_OF_BARS; i++) {
        UILabel* currentLabel = [_healthBar objectAtIndex:i];
        if (NUM_OF_BARS - i <= level) {
            [currentLabel setBackgroundColor: [UIColor greenColor]];
        }
        else {
            [currentLabel setBackgroundColor: [UIColor whiteColor]];
        }
    }
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [self.layer addAnimation:transition forKey:nil];
}


@end
