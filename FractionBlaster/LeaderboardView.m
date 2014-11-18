//
//  LeaderboardView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LeaderboardView.h"

CGFloat INSET_RATIO;

@implementation LeaderboardView {
    NSMutableArray* _highScoreLabels;
    UIButton* _backButton;
    UILabel* _highScoreLabel;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createLabelandButton];
        [self createScoreLabels];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

-(void)setLabelAtIndex:(int)i withString:(NSString*)score
{
    UILabel* currentLabel = [_highScoreLabels objectAtIndex:i];
    NSString* scoreString = [score substringToIndex:7];
    NSString* nameString = [score substringFromIndex:7];
    NSString* text = [[NSString alloc] initWithFormat:@"%d.    %@      %@", i + 1, scoreString, nameString];
    [currentLabel setText:text];
}


-(void) createLabelandButton
{
    CGRect frame = self.frame;
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
    
    
    [_backButton addTarget:self action:@selector(backButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backButton];
    
    CGFloat labelLength = itemWidth * 5;
    CGFloat labelWidth = itemWidth * 2;
    CGFloat labelX = CGRectGetWidth(frame) * 0.37;
    CGFloat labelY = CGRectGetHeight(frame) * 0.2;
    CGRect labelFrame = CGRectMake(labelX, labelY, labelLength, labelWidth);
    
    _highScoreLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [_highScoreLabel setText:@"High Scores"];
    [_highScoreLabel setTextColor:[UIColor whiteColor]];
    [_highScoreLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0f]];
    [self addSubview:_highScoreLabel];
}

-(void) createScoreLabels
{
    CGRect frame = self.frame;
    
    _highScoreLabels = [[NSMutableArray alloc] initWithCapacity:5];
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat labelWidth = width;
    CGFloat labelHeight = height / 20;
    
    for (int i = 0; i < 5; i++) {
        
        CGRect labelFrame = CGRectMake(width * 0.35, height * 0.35 + i * labelHeight, labelWidth, labelHeight);
        UILabel* currentLabel = [[UILabel alloc] initWithFrame:labelFrame];
        currentLabel.backgroundColor = [UIColor clearColor];
        [currentLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
        [currentLabel setTextColor:[UIColor whiteColor]];
        
        [self addSubview:currentLabel];
        [_highScoreLabels insertObject:currentLabel atIndex:i];
    }
}

-(void)backButtonPressed
{
    [self.delegate backToMainMenu];
}


@end
