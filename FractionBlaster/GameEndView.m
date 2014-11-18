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
    UIButton* _backButton;
    UIButton* _continueButton;
    UILabel* _endMessageLabel;
}

- (id)initWithFrame:(CGRect)frame andWin:(BOOL)win
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        CGRect endMessageLabelFrame;
        
        
        
        
        CGRect backButtonFrame = CGRectMake(width * 0.25,height * 0.5,width * 0.2, height * 0.08);
        _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        [_backButton setTitle:@"Main Menu" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
            
            
        CGRect continueButtonFrame = CGRectMake(width * 0.55 ,height * 0.5,width * 0.2, height * 0.08);
        _continueButton = [[UIButton alloc] initWithFrame:continueButtonFrame];
        [_continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_continueButton];
        
        if (win) {
            endMessageLabelFrame = CGRectMake(width * 0.38, height * 0.3, width * 0.3, height * 0.1);
            _endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
            [_endMessageLabel setText: @"VICTORY! >;D"];
            [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]]];
            [_continueButton setTitle:@"Next Level" forState:UIControlStateNormal];
            [_continueButton addTarget:self action:@selector(nextLevelSelected)
                      forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            endMessageLabelFrame = CGRectMake(width * 0.30, height * 0.3, width * 0.5, height * 0.1);
            _endMessageLabel = [[UILabel alloc] initWithFrame:endMessageLabelFrame];
            [_endMessageLabel setText: @"YOU HAVE FAILED... :'("];
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

// Selector for the back button
-(void)backButtonPressed
{
    // [self.delegate removeGameViewController];
    NSLog(@"Back button was pressed");
}

-(void)nextLevelSelected
{
    // [self.delegate removeGameViewController];
    NSLog(@"Lets go to the next level");
}

-(void)tryAgainSelected
{
    // [self.delegate removeGameViewController];
    NSLog(@"Lets try again");
}

@end
