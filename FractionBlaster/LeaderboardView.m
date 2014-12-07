//
//  LeaderboardView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LeaderboardView.h"

CGFloat INSET_RATIO;

@implementation LeaderboardView {
    NSMutableArray *_highScoreLabels;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTitle];
        [self createScoreLabels];
        [self createBackButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

// Sets the label at the provided index with the provided score
- (void)setLabelAtIndex:(int)i withString:(NSString*)score
{
    UILabel *currentLabel = [_highScoreLabels objectAtIndex:i];
    NSString *scoreString = [score substringToIndex:7];
    NSString *nameString = [score substringFromIndex:7];
    NSString *text = [[NSString alloc] initWithFormat:@"%d.    %@      %@", i + 1, scoreString, nameString];
    [currentLabel setText:text];
}

// Create the title label
- (void)createTitle
{
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect labelFrame = CGRectMake(width * 0.37, height * 0.1, width * 0.33, height * 0.1);
    
    UILabel *highScoreLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    [highScoreLabel setText:@"High Scores"];
    [highScoreLabel setTextColor:[UIColor whiteColor]];
    [highScoreLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0f]];
    
    [self addSubview:highScoreLabel];
}

// Create labels that display the scores
- (void)createScoreLabels
{
    CGRect frame = self.frame;
    _highScoreLabels = [[NSMutableArray alloc] initWithCapacity:5];
    CGFloat xOffset = CGRectGetWidth(frame) * 0.35;
    CGFloat yOffset = CGRectGetHeight(frame) * 0.25;
    CGFloat labelWidth = CGRectGetWidth(frame);
    CGFloat labelHeight = CGRectGetHeight(frame) * 0.05;

    // Creates all score labels, and add it into the array
    for (int i = 0; i < 5; i++) {
        CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        
        UILabel *currentLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        currentLabel.backgroundColor = [UIColor clearColor];
        [currentLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [currentLabel setTextColor:[UIColor whiteColor]];
        
        // For the highest score, make the text color yellow.
        if (i == 0) {
            [currentLabel setTextColor:[UIColor yellowColor]];
        }

        [self addSubview:currentLabel];
        [_highScoreLabels insertObject:currentLabel atIndex:i];
        
        // Increment offset for next label frame
        yOffset += labelHeight;
    }
}

// Create the back button
- (void)createBackButton
{
    CGFloat size = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat itemWidth = size / 15;
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(self.frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(self.frame) * INSET_RATIO;
    
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[backButton layer] setCornerRadius:12.0f];
    
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backButton];
}

- (void)backButtonPressed
{
    [self.delegate backToMainMenu];
}


@end
