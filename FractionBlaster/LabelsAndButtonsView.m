//
//  LabelsAndButtonsView.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LabelsAndButtonsView.h"

CGFloat INSET_RATIO;

@implementation LabelsAndButtonsView
{
    UIButton* _backButton;
    UILabel* _levelLabel;
    UILabel* _levelValueLabel;
    UILabel* _scoreLabel;
    UILabel* _scoreValueLabel;
    UILabel* _fireLabel;
}

- (id)initWithFrame:(CGRect)frame andLevel:(int)level
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = self.frame;
        CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        CGFloat itemWidth = size / 15;
        CGFloat itemY = CGRectGetHeight(frame) * INSET_RATIO * 0.3;
        
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
        
        CGFloat levelLabelLength = itemWidth * 2;
        CGFloat levelLabelWidth = itemWidth;
        CGFloat levelLabelX = CGRectGetWidth(frame) * 0.45;
        CGFloat levelLabelY = itemY;
        CGRect levelLabelFrame = CGRectMake(levelLabelX, levelLabelY, levelLabelLength, levelLabelWidth);
        
        _levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
        
        [_levelLabel setText:@"Level"];
        [_levelLabel setTextColor:[UIColor whiteColor]];
        [_levelLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
        
        [self addSubview:_levelLabel];
        
        CGFloat levelValueLabelLength = itemWidth * 2;
        CGFloat levelValueLabelWidth = itemWidth;
        CGFloat levelValueLabelX = CGRectGetWidth(frame) * 0.52;
        CGFloat levelValueLabelY = itemY;
        CGRect levelValueLabelFrame = CGRectMake(levelValueLabelX, levelValueLabelY, levelValueLabelLength, levelValueLabelWidth);
        
        _levelValueLabel = [[UILabel alloc] initWithFrame:levelValueLabelFrame];
        
        [_levelValueLabel setText:[NSString stringWithFormat:@"%i", level]];
        [_levelValueLabel setTextColor:[UIColor whiteColor]];
        [_levelValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
        
        [self addSubview:_levelValueLabel];
        
        
        CGFloat scoreLabelLength = itemWidth * 2;
        CGFloat scoreLabelWidth = itemWidth;
        CGFloat scoreLabelX = CGRectGetWidth(frame) * 0.82;
        CGFloat scoreLabelY = itemY;
        CGRect scoreLabelFrame = CGRectMake(scoreLabelX, scoreLabelY, scoreLabelLength, scoreLabelWidth);
        
        _scoreLabel = [[UILabel alloc] initWithFrame:scoreLabelFrame];
        
        [_scoreLabel setText:@"Score"];
        [_scoreLabel setTextColor:[UIColor whiteColor]];
        [_scoreLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
        
        [self addSubview:_scoreLabel];
        
        CGFloat scoreValueLabelLength = itemWidth * 2;
        CGFloat scoreValueLabelWidth = itemWidth;
        CGFloat scoreValueLabelX = CGRectGetWidth(frame) * 0.89;
        CGFloat scoreValueLabelY = itemY;
        CGRect scoreValueLabelFrame = CGRectMake(scoreValueLabelX, scoreValueLabelY, scoreValueLabelLength, scoreValueLabelWidth);
        
        _scoreValueLabel = [[UILabel alloc] initWithFrame:scoreValueLabelFrame];
        
        [_scoreValueLabel setText:[NSString stringWithFormat:@"%007d", 0]];
        [_scoreValueLabel setTextColor:[UIColor whiteColor]];
        [_scoreValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
        
        [self addSubview:_scoreValueLabel];
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGRect fireLabelFrame = CGRectMake(width * 0.91, height * 0.55, width  * 0.09, height * 0.03);
    
        _fireLabel = [[UILabel alloc] initWithFrame:fireLabelFrame];
    
        [_fireLabel setText:@"Fire!"];
        [_fireLabel setTextColor:[UIColor whiteColor]];
        [_fireLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    
        [self addSubview:_fireLabel];
    }
    return self;
}

-(void)updateScore:(int)score
{
    [_scoreValueLabel setText:[NSString stringWithFormat:@"%007d", score]];
}

// Selector for the back button
-(void)backButtonPressed
{
    // [self.delegate removeGameViewController];
    NSLog(@"Back button was pressed");
}

@end
