//
//  GameEndView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameEndView.h"

@implementation GameEndView

- (id)initWithFrame:(CGRect)frame withLevel:(int)level andScore:(int)score andWin:(BOOL)win
{
    self = [super initWithFrame:frame];
    if (self) {
        // First creates the labels that are not dependent on victory.
        [self createTopLabelsWithFrame:frame andLevel: level andScore:score];
        
        // Create the two buttons and message labels, dependent on victory.
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGRect backButtonFrame = CGRectMake(width * 0.25,height * 0.6,width * 0.2, height * 0.08);
        UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        [backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[backButton layer] setBorderWidth:2.5f];
        [[backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[backButton layer] setCornerRadius:18.0f];
        [backButton addTarget:self action:@selector(backButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        CGRect continueButtonFrame = CGRectMake(width * 0.55 ,height * 0.6,width * 0.2, height * 0.08);
        UIButton *continueButton = [[UIButton alloc] initWithFrame:continueButtonFrame];
        [continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
        [continueButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[continueButton layer] setBorderWidth:2.5f];
        [[continueButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[continueButton layer] setCornerRadius:18.0f];
        [self addSubview:continueButton];
        
        UILabel *endMessageLabel;
        // Depending on whether the user won or lost, have separate texts on buttons and labels.
        if (win) {
            CGRect endMessageLabelFrame = CGRectMake(width * 0.42, height * 0.3, width * 0.3, height * 0.1);
            endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
            [endMessageLabel setText: @"VICTORY!"];
            [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
            [continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
            [continueButton addTarget:self action:@selector(nextLevelSelected)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            CGRect endMessageLabelFrame = CGRectMake(width * 0.21, height * 0.3, width * 0.6, height * 0.1);
            endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
            [endMessageLabel setText: @"YOU HAVE FAILED HUMANITY..."];
            [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background_defeat"]]];
            [continueButton setTitle:@"Try Again" forState:UIControlStateNormal];
            [continueButton addTarget:self action:@selector(tryAgainSelected)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        
        [endMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [endMessageLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:endMessageLabel];
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
        UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        [backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
        [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[backButton layer] setBorderWidth:2.5f];
        [[backButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[backButton layer] setCornerRadius:18.0f];
        [backButton addTarget:self action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        CGRect endMessageLabelFrame = CGRectMake(width * 0.3, height * 0.1, width * 0.5, height * 0.5);
        UILabel *endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
        [endMessageLabel setText: @"Congratulations Cadet!"];
        [endMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [endMessageLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:endMessageLabel];

        CGRect endMessageLabelVictoryFrame = CGRectMake(width * 0.31, height * 0.2, width * 0.5, height * 0.5);
        UILabel *endMessageVictoryLabel = [[UILabel alloc] initWithFrame:endMessageLabelVictoryFrame];
        [endMessageVictoryLabel setText: @"You have saved Earth!"];
        [endMessageVictoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0f]];
        [endMessageVictoryLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:endMessageVictoryLabel];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
    }
    
    return self;
}

// Function to create the labels independent of victory.
-(void)createTopLabelsWithFrame:(CGRect)frame andLevel:(int)level andScore:(int)score
{
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect levelLabelFrame;
    
    NSString* levelString;
    if (level > 0) {
        levelString = [[NSString alloc] initWithFormat:@"Level: %d", level];
        levelLabelFrame = CGRectMake(width * 0.44,height * 0.43,width * 0.5, height * 0.08);
    }
    else {
        levelString = @"Survival Mode";
        levelLabelFrame = CGRectMake(width * 0.40,height * 0.43,width * 0.5, height * 0.08);
    }
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
    [levelLabel setText:levelString];
    [levelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [levelLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:levelLabel];
    
    CGRect scoreLabelFrame = CGRectMake(width * 0.40,height * 0.5,width * 0.5, height * 0.08);
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:scoreLabelFrame];
    NSString* scoreString = [[NSString alloc] initWithFormat:@"Score: %@", [NSString stringWithFormat:@"%007d", score]];
    [scoreLabel setText:scoreString];
    [scoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [scoreLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:scoreLabel];
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
