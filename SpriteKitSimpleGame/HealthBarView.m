//
//  HealthBarView.m
//  SpriteKitSimpleGame
//
//  Created by CS121 on 10/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "HealthBarView.h"

int NUM_OF_BARS = 10;
int MAX_HEALTH = 100;

@implementation HealthBarView
{
    int _healthLevel;
    NSMutableArray* _healthBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _healthLevel = MAX_HEALTH;
        _healthBar = [[NSMutableArray alloc] initWithCapacity:NUM_OF_BARS];
        CGFloat height = CGRectGetHeight(frame);
        CGFloat width = CGRectGetWidth(frame);
        CGFloat labelHeight = width / NUM_OF_BARS;
        
        for (int i = 0; i < NUM_OF_BARS; i++) {
            CGRect labelFrame = CGRectMake(0, i * labelHeight, width, height);
            UILabel* currentLabel = [[UILabel alloc] initWithFrame:labelFrame];
            [_healthBar addObject:currentLabel];
        }
    }
    return self;
}

- (int)getHealthLevel
{
    return _healthLevel;
}

- (void)setHealthLevel: (int)healthLevel
{
    _healthLevel = healthLevel;
    [self updateHealthBar];
}

- (void)updateHealthBar
{
    float level = MAX_HEALTH / _healthLevel;
    for (int i = 0; i < NUM_OF_BARS; i++) {
        UILabel* currentLabel = [_healthBar objectAtIndex:i];
        if (NUM_OF_BARS - i < level) {
            [currentLabel setBackgroundColor: [UIColor whiteColor]];
        }
        else {
            [currentLabel setBackgroundColor: [UIColor greenColor]];
        }
    }
}


@end
