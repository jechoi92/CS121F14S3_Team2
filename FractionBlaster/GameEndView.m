//
//  GameEndView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameEndView.h"

@implementation GameEndView
{
    int _level;
    int _score;
    BOOL _win;
}

- (id)initWithFrame:(CGRect)frame withLevel:(int)level andScore:(int)score andWin:(BOOL)win
{
    self = [super initWithFrame:frame];
    if (self) {
        _level = level;
        _score = score;
        _win = win;
        [self createBackground];
        [self createLevelAndScoreLabels];
        [self createMessageLabels];
        [self createButtons];
    }
    return self;
}

// Create the background image
- (void)createBackground
{
    if (_win) {
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
        if (_level == 5) {
            [self setBackgroundColor:[UIColor blackColor]];
        }
        else if (_level > 5) {
            [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"foreign-back"]]];
        }
    }
    else {
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background_defeat"]]];
    }
}

// Create the buttons for returning to main menu or returning to the game
- (void)createButtons
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect backButtonFrame = CGRectMake(width * 0.25,height * 0.6,width * 0.2, height * 0.08);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    // Set text
    [backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // Set design
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[backButton layer] setCornerRadius:18.0f];
    
    [self addSubview:backButton];
    
    CGRect continueButtonFrame = CGRectMake(width * 0.55 ,height * 0.6,width * 0.2, height * 0.08);
    UIButton *continueButton = [[UIButton alloc] initWithFrame:continueButtonFrame];
    
    // Set text
    [continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
    [continueButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // Set design
    [[continueButton layer] setBorderWidth:2.5f];
    [[continueButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[continueButton layer] setCornerRadius:18.0f];
    
    [self addSubview:continueButton];
    
    // Depending on whether won or lost, create targets and titles accordingly
    if (_win) {
        [backButton addTarget:self action:@selector(backButtonPressedWithoutSave)
             forControlEvents:UIControlEventTouchUpInside];
        [continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(nextLevelSelected)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [backButton addTarget:self action:@selector(backButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
        [continueButton setTitle:@"Try Again" forState:UIControlStateNormal];
        [continueButton addTarget:self action:@selector(tryAgainSelected)
                 forControlEvents:UIControlEventTouchUpInside];
    }
}

// Create the labels end of game messages
- (void)createMessageLabels
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    UILabel *endMessageLabel;
    
    // Depending on whether won or lost, create separate frames and texts
    if (_win) {
        CGRect endMessageLabelFrame = CGRectMake(0, height * 0.3, width, height * 0.1);
        endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
        [endMessageLabel setText: @"VICTORY!"];
    }
    else {
        CGRect endMessageLabelFrame = CGRectMake(0, height * 0.3, width, height * 0.1);
        endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
        [endMessageLabel setText: @"YOU HAVE FAILED HUMANITY..."];
    }
    
    [endMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
    [endMessageLabel setTextColor:[UIColor whiteColor]];
    endMessageLabel.textAlignment = YES;
    
    [self addSubview:endMessageLabel];

}

// Initialization function for the final victory view.
- (id)initWithFrameVictory:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
        [self createVictoryButton];
        [self createVictoryLabels];
    }
    return self;
}

// Create button for final victory screen
- (void)createVictoryButton
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect backButtonFrame = CGRectMake(width * 0.41,height * 0.6,width * 0.2, height * 0.08);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    // Set text
    [backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // Set design
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[backButton layer] setCornerRadius:18.0f];
    
    // Create target for button
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backButton];
}

// Create labels for final victory screen
- (void)createVictoryLabels
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect endMessageLabelFrame = CGRectMake(0, height * 0.1, width, height * 0.5);
    UILabel *endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
    
    // Set text
    [endMessageLabel setText: @"Congratulations Cadet!"];
    [endMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
    [endMessageLabel setTextColor:[UIColor whiteColor]];
    endMessageLabel.textAlignment = YES;
    
    [self addSubview:endMessageLabel];
    
    CGRect endMessageLabelVictoryFrame = CGRectMake(0, height * 0.2, width, height * 0.5);
    UILabel *endMessageVictoryLabel = [[UILabel alloc] initWithFrame:endMessageLabelVictoryFrame];
    
    // Set text
    [endMessageVictoryLabel setText: @"You have saved Earth!"];
    [endMessageVictoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
    [endMessageVictoryLabel setTextColor:[UIColor whiteColor]];
    endMessageVictoryLabel.textAlignment = YES;
    
    [self addSubview:endMessageVictoryLabel];
}

// Function to create the labels independent of victory.
-(void)createLevelAndScoreLabels
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect levelLabelFrame;
    
    // Create the string depending on the level and modes
    NSString* levelString;
    if (_level > 0) {
        levelString = [[NSString alloc] initWithFormat:@"Level: %d", _level];
        levelLabelFrame = CGRectMake(0,height * 0.43,width, height * 0.08);
    }
    else {
        levelString = @"Survival Mode";
        levelLabelFrame = CGRectMake(0,height * 0.43,width, height * 0.08);
    }
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
    
    // Set text
    [levelLabel setText:levelString];
    [levelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [levelLabel setTextColor:[UIColor whiteColor]];
    levelLabel.textAlignment = YES;
    
    [self addSubview:levelLabel];
    
    CGRect scoreLabelFrame = CGRectMake(0,height * 0.5,width, height * 0.08);
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:scoreLabelFrame];
    
    // Create the string and set text
    NSString* scoreString = [[NSString alloc] initWithFormat:@"Score: %@", [NSString stringWithFormat:@"%007d", _score]];
    [scoreLabel setText:scoreString];
    [scoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [scoreLabel setTextColor:[UIColor whiteColor]];
    scoreLabel.textAlignment = YES;
    
    [self addSubview:scoreLabel];
}

-(void)backButtonPressed
{
    [self.delegate backToMainMenu];
}

// Function to handle the case when the main menu button was pressed when won
- (void)backButtonPressedWithoutSave
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                message:@"Go back to main menu? Your current score will be lost!"
                                delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert show];
}

// Alertview function to confirm navigation away from current screen
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Yes, go back to main menu
    if (buttonIndex == 0) {
        [self.delegate backToMainMenu];
    }
}

-(void)nextLevelSelected
{
    [self.delegate backToGameWithNextLevel:YES];
}

-(void)tryAgainSelected
{
    [self.delegate backToGameWithNextLevel:NO];
}

@end
