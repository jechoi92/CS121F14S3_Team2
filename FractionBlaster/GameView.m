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
    UILabel* _asteroidTextLabel;
    UILabel* _scoreValueLabel;
    UILabel* _asteroidValueLabel;
    UIImageView* _container;
}

- (id)initWithFrame:(CGRect)frame andAsteroidCount:(int)numAsteroids andScore:(int)score
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBackButton];
        [self addScoreAndAsteroidContainer];
        [self createLabelsWithAsteroidCount:numAsteroids andScore:score];
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

- (void)addScoreAndAsteroidContainer
{
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat labelHeight = MIN(frameWidth, frameHeight) / 10;
    CGFloat posX = frameWidth * 0.8;
    
    // Create label with "Score" text
    CGRect scoreTextFrame = CGRectMake(posX, 0, labelHeight * 2, labelHeight);
    
    _container = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stats_holder.png"]];
    [_container setFrame:scoreTextFrame];
    
    [self addSubview:_container];
}

// Create all the labels for the view
- (void)createLabelsWithAsteroidCount:(int)numAsteroids andScore:(int)score
{
    [self createAsteroidLabels:numAsteroids];
    [self createScoreLabels:score];
}

// Create labels displaying the player's current score
- (void)createAsteroidLabels:(int)numAsteroids
{
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat labelHeight = MIN(frameWidth, frameHeight) / 15;
    CGFloat labelY = frameHeight * INSET_RATIO * 1.3;
    CGFloat textX = frameWidth * 0.83;
    CGFloat valueX = frameWidth * 0.95;
    
    // Create label with "Score" text
    CGRect asteroidTextFrame = CGRectMake(textX, labelY, labelHeight * 2, labelHeight);
    
    _asteroidTextLabel = [[UILabel alloc] initWithFrame:asteroidTextFrame];
    
    [_asteroidTextLabel setText:@"Asteroids"];
    [_asteroidTextLabel setTextColor:[UIColor whiteColor]];
    [_asteroidTextLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_asteroidTextLabel];
    
    // Create label with player's actual current score value
    CGRect asteroidValueFrame = CGRectMake(valueX, labelY, labelHeight * 2, labelHeight);
    _asteroidValueLabel = [[UILabel alloc] initWithFrame:asteroidValueFrame];
    
    [_asteroidValueLabel setText:[NSString stringWithFormat:@"%d", numAsteroids]];
    [_asteroidValueLabel setTextColor:[UIColor whiteColor]];
    [_asteroidValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_asteroidValueLabel];
}

// Create labels displaying the player's current score
- (void)createScoreLabels:(int)score
{
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat labelHeight = MIN(frameWidth, frameHeight) / 15;
    CGFloat textX = frameWidth * 0.82;
    CGFloat valueX = frameWidth * 0.89;
    
    // Create label with "Score" text
    CGRect scoreTextFrame = CGRectMake(textX, 0, labelHeight * 2, labelHeight);
    
    _asteroidTextLabel = [[UILabel alloc] initWithFrame:scoreTextFrame];
    
    [_asteroidTextLabel setText:@"Score"];
    [_asteroidTextLabel setTextColor:[UIColor whiteColor]];
    [_asteroidTextLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_asteroidTextLabel];
    
    // Create label with player's actual current score value
    CGRect scoreValueFrame = CGRectMake(valueX, 0, labelHeight * 2, labelHeight);
    _scoreValueLabel = [[UILabel alloc] initWithFrame:scoreValueFrame];
    
    [_scoreValueLabel setText:[NSString stringWithFormat:@"%007d", score]];
    [_scoreValueLabel setTextColor:[UIColor whiteColor]];
    [_scoreValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [self addSubview:_scoreValueLabel];
}

// Update the text of the score value label upon score changes
- (void)updateScore:(int)score
{
    [_scoreValueLabel setText:[NSString stringWithFormat:@"%007d", score]];
}

// Update the text of the score value label upon score changes
- (void)updateAsteroidCount:(int)numAsteroid
{
    [_asteroidValueLabel setText:[NSString stringWithFormat:@"%d", numAsteroid]];
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
