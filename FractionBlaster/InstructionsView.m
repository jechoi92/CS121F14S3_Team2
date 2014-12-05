//
//  InstructionsView.m
//  FractionBlaster
//
//  Created by CS121 on 12/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "InstructionsView.h"

CGFloat INSET_RATIO;
int INSTR_FONT_SIZE = 20;

@implementation InstructionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createInstructions];
        [self createBackButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

- (void)createInstructions
{
    // Get frame size
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat textViewHeightRatio = 0.75;
    CGFloat textViewWidthRatio = 0.75;
    
    // Text view frame setup
    CGFloat textViewHeight = frameHeight*textViewHeightRatio;
    CGFloat textViewWidth = frameWidth*textViewWidthRatio;
    CGFloat textViewXOffset = (frameWidth-textViewWidth)/2;
    CGFloat textViewYOffset = (frameHeight-textViewHeight)/2;
    
    CGRect textViewFrame = CGRectMake(textViewXOffset, textViewYOffset, textViewWidth, textViewHeight);
    
    // Text container creation
    UITextView *instrText = [[UITextView alloc] initWithFrame:textViewFrame];
    instrText.backgroundColor = [UIColor clearColor];
    
    // Read instructions from file
    NSString* path = [[NSBundle mainBundle] pathForResource:@"instructions"
                                                     ofType:@"txt"];
    NSString *myText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    instrText.text  = myText;
    
    // Style the text
    instrText.textColor = [UIColor whiteColor];
    [instrText setFont:[UIFont fontWithName:@"Futura-Medium" size:INSTR_FONT_SIZE]];
    instrText.editable = NO;
    
    // Add as subview
    [self addSubview:instrText];
}

- (void)createBackButton
{
    // Set up size of a button relative to the size of the frame
    CGFloat size = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat itemWidth = size / 15;
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    
    // Set up button offsets
    CGFloat backButtonX = CGRectGetWidth(self.frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(self.frame) * INSET_RATIO;
    
    // Create back button
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    // Style back button
    [backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[backButton layer] setCornerRadius:12.0f];
    
    // Add target action for button
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
}

- (void)backButtonPressed
{
    [self.delegate backToMainMenu];
}

@end
