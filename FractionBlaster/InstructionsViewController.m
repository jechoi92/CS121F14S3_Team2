//
//  InstructionsViewController.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "InstructionsViewController.h"

@implementation InstructionsViewController
{
    UITextView *_instrText;
    UIButton *_backButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
        
        
        CGFloat INSET_RATIO = 0.02;
        
        CGFloat frameHeight = CGRectGetHeight(self.view.frame);
        CGFloat frameWidth = CGRectGetWidth(self.view.frame);
        CGFloat textViewHeight = frameHeight/2;
        CGFloat textViewWidth = frameWidth/2;
        CGFloat textViewXOffset = (frameWidth-textViewWidth)/2;
        CGFloat textViewYOffset = (frameWidth-textViewHeight)/2;
        
        CGRect textViewFrame = CGRectMake(textViewXOffset, textViewYOffset, textViewWidth, textViewHeight);

        _instrText = [[UITextView alloc] initWithFrame:textViewFrame];
        _instrText.backgroundColor = [UIColor clearColor];
        _instrText.text = @"UITextView text";
        _instrText.textColor = [UIColor whiteColor];
        
        [self.view addSubview:_instrText];
        
        
        CGFloat itemWidth = MIN(frameWidth, frameHeight) / 15;
        
        CGFloat backButtonLength = itemWidth;
        CGFloat backButtonWidth = itemWidth;
        CGFloat backButtonX = frameWidth * INSET_RATIO;
        CGFloat backButtonY = frameHeight * INSET_RATIO;
        CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
        
        _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
        [[_backButton layer] setBorderWidth:2.5f];
        [[_backButton layer] setBorderColor:[UIColor blackColor].CGColor];
        [[_backButton layer] setCornerRadius:12.0f];
        
        [_backButton addTarget:self action:@selector(backButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_backButton];
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
