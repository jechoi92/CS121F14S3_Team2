//
//  LeaderboardView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LeaderboardView.h"
#import "Constants.h"

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
    NSString *text = [[NSString alloc] initWithFormat:@" %d.    %@      %@", i + 1, scoreString, nameString];
    [currentLabel setText:text];
}

// Create the title label
- (void)createTitle
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(frameWidth * 0.1, frameHeight * 0.05, frameWidth * 0.8, frameHeight * 0.18);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"high_scores"];
    
    [self addSubview:imageView];
}

// Create labels that display the scores
- (void)createScoreLabels
{
    CGRect frame = self.frame;
    _highScoreLabels = [[NSMutableArray alloc] initWithCapacity:5];
    CGFloat xOffset = CGRectGetWidth(frame) * 0.3;
    CGFloat yOffset = CGRectGetHeight(frame) * 0.4;
    CGFloat labelWidth = CGRectGetWidth(frame) * .4;
    CGFloat labelHeight = CGRectGetHeight(frame) * 0.05;

    // Creates all score labels, and add it into the array
    for (int i = 0; i < 5; i++) {
        CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        
        UILabel *currentLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        currentLabel.backgroundColor = [UIColor clearColor];
        [currentLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [currentLabel setTextColor:[UIColor whiteColor]];
        
        // For the highest score, make the text color yellow.
        if (i == 0) {
            [currentLabel setTextColor:[UIColor yellowColor]];
        }

        [self addSubview:currentLabel];
        [_highScoreLabels insertObject:currentLabel atIndex:i];
        
        // Set border images for each button
        UIImageView *background = [[UIImageView alloc] initWithFrame:labelFrame];
        background.image = [UIImage imageNamed:@"menuBorder"];
        [self addSubview:background];
        [self sendSubviewToBack:background];
        
        // Increment offset for next label frame
        yOffset += labelHeight*2;
    }
}

// Create the back button
- (void)createBackButton
{
    // Set up button size
    CGFloat size = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat itemWidth = size / 15;
    
    // Button frame dimensions
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(self.frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(self.frame) * INSET_RATIO;
    
    // Create button
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    // Style button
    [backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[backButton layer] setCornerRadius:12.0f];
    
    // Add target
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backButton];
}

- (void)backButtonPressed
{
    [self.delegate backToMainMenu];
}


@end
