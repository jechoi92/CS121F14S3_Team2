//
//  ModeSelectView.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ModeSelectView.h"

CGFloat INSET_RATIO;

@implementation ModeSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTitle];
        [self createSelectionButtons];
        [self createLabels];
        [self createBackButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

- (void)createTitle
{
    // TODODOTODOTOOTODODO
}

- (void)createSelectionButtons
{
    CGFloat buttonWidth = CGRectGetWidth(self.frame) * 0.6;
    CGFloat buttonHeight = CGRectGetHeight(self.frame) * 0.1;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.2;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.3;
    
    for (int i = 0; i < 2; ++i){
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Create target for cell
        [button addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:42.0f]];
        [[button layer] setBorderWidth:6.0f];
        [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[button layer] setCornerRadius:18.0f];
        
        // Set up title
        switch (i){
            case 0:
                [button setTitle:@"Campaign Mode" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"Survival Mode" forState:UIControlStateNormal];
                break;
        }
        button.tag = i;
        
        yOffset += buttonHeight * 3;
        [self addSubview:button];
    }
}

- (void)createLabels
{
    CGFloat labelWidth = CGRectGetWidth(self.frame) * 0.5;
    CGFloat labelHeight = CGRectGetHeight(self.frame) * 0.3;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.25;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.3;
    
    for (int i = 0; i < 2; ++i){
        CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        
        // Create target for cell
        [label setFont:[UIFont fontWithName:@"SpaceAge" size:24.0f]];
        [label setTextColor:[UIColor whiteColor]];
        
        // Set up title
        switch (i){
            case 0:
                [label setText:@"Play the story and beat the game!"];
                break;
            case 1:
                [label setText:@"Play for fun and beat your friends!"];
                break;
        }
        yOffset += labelHeight;
        [self addSubview:label];
    }
}

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
    [backButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 2;
    [self addSubview:backButton];
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}


@end

