//
//  GameEndView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameEndLabelAndButtonsView.h"

@implementation GameEndLabelAndButtonsView
{
    UIButton* _backButton;
    UIButton* _continueButton;
    UILabel* _endMessageLabel;
    UILabel* _endMessageVictoryLabel;
    UILabel* _levelLabel;
    UILabel* _scoreLabel;
    
}

- (id)initWithFrame:(CGRect)frame withLevel:(int)level andScore:(int)score andWin:(BOOL)win
{
    self = [super initWithFrame:frame];
    if (self) {
        // First creates the labels that are not dependent on victory.
        [self createTopLabelsWithFrame:frame andLevel: level andScore:score];
        
        // Create the two buttons and message labels, dependent on victory.
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGRect endMessageLabelFrame;
        CGRect backButtonFrame = CGRectMake(width * 0.25,height * 0.6,width * 0.2, height * 0.08);
        _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        [_backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
        [_backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_backButton layer] setBorderWidth:2.5f];
        [[_backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_backButton layer] setCornerRadius:18.0f];
        [_backButton addTarget:self action:@selector(backButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        CGRect continueButtonFrame = CGRectMake(width * 0.55 ,height * 0.6,width * 0.2, height * 0.08);
        _continueButton = [[UIButton alloc] initWithFrame:continueButtonFrame];
        [_continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
        [_continueButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_continueButton layer] setBorderWidth:2.5f];
        [[_continueButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_continueButton layer] setCornerRadius:18.0f];
        [self addSubview:_continueButton];
        
        // Depending on whether the user won or lost, have separate texts on buttons and labels.
        if (win) {
            endMessageLabelFrame = CGRectMake(width * 0.42, height * 0.3, width * 0.3, height * 0.1);
            _endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
            [_endMessageLabel setText: @"VICTORY!"];
            [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
            [_continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
            [_continueButton addTarget:self action:@selector(nextLevelSelected)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            endMessageLabelFrame = CGRectMake(width * 0.21, height * 0.3, width * 0.6, height * 0.1);
            _endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
            [_endMessageLabel setText: @"YOU HAVE FAILED HUMANITY..."];
            [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background_defeat"]]];
            [_continueButton setTitle:@"Try Again" forState:UIControlStateNormal];
            [_continueButton addTarget:self action:@selector(tryAgainSelected)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_endMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [_endMessageLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_endMessageLabel];
    }
    return self;
}

// Initialization function for the final victory view.
- (id)initWithFrameVictory:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGRect backButtonFrame = CGRectMake(width * 0.41,height * 0.6,width * 0.2, height * 0.08);
        _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        [_backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
        [_backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[_backButton layer] setBorderWidth:2.5f];
        [[_backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[_backButton layer] setCornerRadius:18.0f];
        [_backButton addTarget:self action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        CGRect endMessageLabelFrame = CGRectMake(width * 0.3, height * 0.1, width * 0.5, height * 0.5);
        _endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
        [_endMessageLabel setText: @"Congratulations Cadet!"];
        [_endMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [_endMessageLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_endMessageLabel];

        CGRect endMessageLabelVictoryFrame = CGRectMake(width * 0.31, height * 0.2, width * 0.5, height * 0.5);
        _endMessageVictoryLabel = [[UILabel alloc] initWithFrame:endMessageLabelVictoryFrame];
        [_endMessageVictoryLabel setText: @"You have saved Earth!"];
        [_endMessageVictoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [_endMessageVictoryLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_endMessageVictoryLabel];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
    }
    
    return self;
}

// Function to create the labels independent of victory.
-(void)createTopLabelsWithFrame:(CGRect)frame andLevel:(int)level andScore:(int)score
{
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect levelLabelFrame = CGRectMake(width * 0.44,height * 0.43,width * 0.5, height * 0.08);
    _levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
    NSString* levelLabel = [[NSString alloc] initWithFormat:@"Level: %d", level];
    [_levelLabel setText:levelLabel];
    [_levelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [_levelLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_levelLabel];
    
    CGRect scoreLabelFrame = CGRectMake(width * 0.40,height * 0.5,width * 0.5, height * 0.08);
    _scoreLabel = [[UILabel alloc] initWithFrame:scoreLabelFrame];
    NSString* scoreLabel = [[NSString alloc] initWithFormat:@"Score: %@", [NSString stringWithFormat:@"%007d", score]];
    [_scoreLabel setText:scoreLabel];
    [_scoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [_scoreLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_scoreLabel];
}

-(void)backButtonPressed
{
    [self.delegate backToMainMenu];
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
