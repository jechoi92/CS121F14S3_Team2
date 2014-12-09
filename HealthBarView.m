//
//  HealthBarView.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "HealthBarView.h"

int NUM_OF_BARS = 10;
int MAX_HEALTH = 100;

@implementation HealthBarView
{
    NSMutableArray *_healthBar;
}

// Initializes the health bar (array of blank labels) and health level.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _healthLevel = MAX_HEALTH;
        _healthBar = [[NSMutableArray alloc] initWithCapacity:NUM_OF_BARS];
        [self createHealthLabels];
        [self createContainer];
    }
    
    // Color in the labels
    [self updateHealthBar];
    return self;
}

// Create the labels that represent the health bar
- (void)createHealthLabels
{
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame) * 0.9;
    CGFloat labelHeight = 5.1 * height / (7 * NUM_OF_BARS);
    CGFloat yOffset = height / 7;
    
    // Creates the array of blank labels to represent the health levels.
    for (int i = 0; i < NUM_OF_BARS; i++) {
        CGRect labelFrame = CGRectMake(0, yOffset, width, labelHeight);
        UILabel* currentLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        [self addSubview:currentLabel];
        
        // Add the label to the array
        [_healthBar addObject:currentLabel];
        
        // Increment the offset for the next label frame
        yOffset += labelHeight;
    }
}

// Create the frame to contain the labels for aesthetics
- (void)createContainer
{
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    UIImageView *container = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shields.png"]];
    [container setFrame:CGRectMake(0,0,width, height)];
    
    [self addSubview:container];
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
    UIColor *currentColor;
    float healthPercentage = (float)_healthLevel / (float)MAX_HEALTH;
    
    // Determine the color depending on the current health level
    if (healthPercentage > 0.67) {
        currentColor = [UIColor greenColor];
    }
    else if (healthPercentage > 0.33) {
        currentColor = [UIColor yellowColor];
    }
    else {
        currentColor = [UIColor redColor];
    }
    
    float level = healthPercentage * NUM_OF_BARS;
    
    // Color the labels according to their position in the array
    for (int i = 0; i < NUM_OF_BARS; i++) {
        UILabel* currentLabel = [_healthBar objectAtIndex:i];
        if (NUM_OF_BARS - i <= level) {
            [currentLabel setBackgroundColor: currentColor];
        }
        else {
            [currentLabel setBackgroundColor: [UIColor whiteColor]];
        }
    }
    
    // Transition to make the healthbar decreasing smoother.
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:transition forKey:nil];
}


@end
