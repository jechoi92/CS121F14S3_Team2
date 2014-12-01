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
{
    UIButton* _backButton;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    CGFloat buttonWidth = CGRectGetWidth(self.frame) * 0.6;
    CGFloat buttonHeight = CGRectGetHeight(self.frame) * 0.02;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.2;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.4;
    
    for (int i = 0; i < 2; ++i){
        yOffset += buttonHeight * 2;
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Create target for cell
        [button addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
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
        
        [self addSubview:button];
    }
    

    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    CGFloat itemWidth = size / 15;
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[_backButton layer] setBorderWidth:2.5f];
    [[_backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_backButton layer] setCornerRadius:12.0f];
    [_backButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    _backButton.tag = 2;
    [self addSubview:_backButton];
    
    return self;
}

-(void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}


@end

