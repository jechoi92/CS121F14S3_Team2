//
//  LabelsAndButtonsView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameView.h"

CGFloat INSET_RATIO;

@implementation GameView
{
    UIButton* _backButton;
    UILabel* _levelTextLabel;
    UILabel* _levelValueLabel;
    UILabel* _scoreTextLabel;
    UILabel* _scoreValueLabel;
    UILabel* _fireLabel;
}

- (id)initWithFrame:(CGRect)frame andLevel:(int)level andScore:(int)score
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBackButton];
        [self createLabelsWithLevel:level andScore:score];
    }
    return self;
}

// Create button to return to the menu
- (void)createBackButton
{
    CGRect frame = self.frame;
    CGFloat itemWidth = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) / 15;
    
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, itemWidth, itemWidth);
    
    _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[_backButton layer] setBorderWidth:2.5f];
    [[_backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_backButton layer] setCornerRadius:12.0f];
    
    [_backButton addTarget:self action:@selector(backButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backButton];
}

// Create all the labels for the view
- (void)createLabelsWithLevel:(int)level andScore:(int)score
{
    [self createLevelLabels:level];
    [self createScoreLabels:score];
    [self createFireLabel];
}

// Create labels displaying the current game level
- (void)createLevelLabels:(int)level
{
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat labelHeight = MIN(frameWidth, frameHeight) / 15;
    CGFloat labelY = frameHeight * INSET_RATIO * 0.3;
    CGFloat textX = frameWidth * 0.45;
    CGFloat valueX = frameWidth * 0.52;
    
    CGRect levelTextFrame = CGRectMake(textX, labelY, labelHeight * 2, labelHeight);
    _levelTextLabel = [[UILabel alloc] initWithFrame:levelTextFrame];
    
    [_levelTextLabel setText:@"Level"];
    [_levelTextLabel setTextColor:[UIColor whiteColor]];
    [_levelTextLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_levelTextLabel];
    
    CGRect levelValueFrame = CGRectMake(valueX, labelY, labelHeight * 2, labelHeight);
    _levelValueLabel = [[UILabel alloc] initWithFrame:levelValueFrame];
    
    [_levelValueLabel setText:[NSString stringWithFormat:@"%i", level]];
    [_levelValueLabel setTextColor:[UIColor whiteColor]];
    [_levelValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_levelValueLabel];
}

// Create labels displaying the player's current score
- (void)createScoreLabels:(int)score
{
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat labelHeight = MIN(frameWidth, frameHeight) / 15;
    CGFloat labelY = frameHeight * INSET_RATIO * 0.3;
    CGFloat textX = frameWidth * 0.82;
    CGFloat valueX = frameWidth * 0.89;
    
    CGRect scoreTextFrame = CGRectMake(textX, labelY, labelHeight * 2, labelHeight);
    _scoreTextLabel = [[UILabel alloc] initWithFrame:scoreTextFrame];
    
    [_scoreTextLabel setText:@"Score"];
    [_scoreTextLabel setTextColor:[UIColor whiteColor]];
    [_scoreTextLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_scoreTextLabel];
    
    CGRect scoreValueFrame = CGRectMake(valueX, labelY, labelHeight * 2, labelHeight);
    _scoreValueLabel = [[UILabel alloc] initWithFrame:scoreValueFrame];
    
    [_scoreValueLabel setText:[NSString stringWithFormat:@"%007d", score]];
    [_scoreValueLabel setTextColor:[UIColor whiteColor]];
    [_scoreValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_scoreValueLabel];
}

// Create label over the fire buttons
- (void)createFireLabel
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect fireLabelFrame = CGRectMake(width * 0.91, height * 0.55, width  * 0.09, height * 0.03);
    _fireLabel = [[UILabel alloc] initWithFrame:fireLabelFrame];
    
    [_fireLabel setText:@"Fire!"];
    [_fireLabel setTextColor:[UIColor whiteColor]];
    [_fireLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [self addSubview:_fireLabel];
}

// Update the text of the score value label upon score changes
- (void)updateScore:(int)score
{
    [_scoreValueLabel setText:[NSString stringWithFormat:@"%007d", score]];
}

// Selector for the back button
- (void)backButtonPressed
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Go back to main menu? Your progress will be lost!"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Yes, go back to main menu
    if (buttonIndex == 0) {
        [self.delegate backToMainMenu];
    }
}


@end
