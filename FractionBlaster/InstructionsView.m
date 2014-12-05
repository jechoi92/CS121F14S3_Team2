//
//  InstructionsView.m
//  FractionBlaster
//
//  Created by CS121 on 12/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

// TODO: Fix commenting - section separators are interpreted as
//       docstrings for methods

#import "InstructionsView.h"
#import "UIImage+animatedGIF.h"

CGFloat INSET_RATIO;
int INSTR_FONT_SIZE = 20;
int NUM_INSTR_STEPS = 3;
CGFloat BASE_OFFSET_PCT = (float)1/21;

@implementation InstructionsView
{
    UIImageView *_instrGifView;
    UITextView *_instrTextView;
    
    int _instrStep; // Ranges from 1 to NUM_INSTR_STEPS
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Default step is 1
        _instrStep = 1;
        
        // Set background
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
        
        // Create instruction display
        [self createInstrText];
        [self createInstrGif];
        
        // Create instruction navigation buttons
        [self createPrevInstrButton];
        [self createNextInstrButton];
        
        // Back button
        [self createBackButton];
    }
    
    return self;
}

/***********************************
 *   INSTRUCTIONS INITIALIZATION   *
 ***********************************/

- (CGRect)createInstrFrame
{
    // Get frame size
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat instrHeightRatio = (float)14/20;
    CGFloat instrWidthRatio = (float)3/7;
    
    // Instr dimensions setup
    CGFloat instrHeight = frameHeight * instrHeightRatio;
    CGFloat instrWidth = frameWidth * instrWidthRatio;
    
    // Y Offset has enough room for the height and the buffer
    CGFloat baseYOffset = BASE_OFFSET_PCT * frameHeight;
    CGFloat instrYOffset = frameHeight - (instrHeight + baseYOffset);
    
    CGFloat baseXOffset = BASE_OFFSET_PCT * frameWidth;
    
    return CGRectMake(baseXOffset, instrYOffset, instrWidth, instrHeight);
}

- (void)createInstrText
{
    // Create standard subview frame
    CGRect textViewFrame = [self createInstrFrame];

    // Text container creation
    _instrTextView = [[UITextView alloc] initWithFrame:textViewFrame];
    _instrTextView.backgroundColor = [UIColor clearColor];
    
    // Read instructions from file
    [self setTextInstruction:_instrStep];
    
    // Add subviews
    [self addSubview:_instrTextView];

}

- (void)createInstrGif
{
    // Create standard subview frame
    CGRect textViewFrame = [self createInstrFrame];
    
    // xOffset leaves room for size of text view, then get the difference in
    // x offsets so we can use CGRectOffset()
    CGFloat xOffset = CGRectGetWidth(self.frame) - CGRectGetMaxX(textViewFrame);
    CGFloat extraXOffset = xOffset - CGRectGetMinX(textViewFrame);
    CGRect gifFrame = CGRectOffset(textViewFrame, extraXOffset, 0);
    
    // Create view
    _instrGifView = [[UIImageView alloc] initWithFrame:gifFrame];
    
    // Set gif image
    [self setGifInstruction:_instrStep];
    
    [self addSubview:_instrGifView];
}

/***************************
 *  BUTTON INITIALIZATION  *
 ***************************/

- (CGRect)createInstrButtonFrame
{
    CGFloat frameWidth  = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    
    // TODO: Make this not-magic
    CGFloat buttonWidth = frameWidth * 0.24;
    CGFloat buttonHeight = frameHeight * 0.1;
    CGFloat xOffset = frameWidth * BASE_OFFSET_PCT;
    CGFloat yOffset = frameHeight * BASE_OFFSET_PCT * 2;
    
    return CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
}

- (void)createNextInstrButton
{
    // Get generic button frame
    CGRect instrButtonFrame = [self createInstrButtonFrame];
    
    // Needs to be room for the button and the offset
    CGFloat xOffset = CGRectGetWidth(self.frame) - CGRectGetMaxX(instrButtonFrame);
    CGFloat extraXOffset = xOffset - CGRectGetMinX(instrButtonFrame);
    CGRect nextInstrButtonFrame = CGRectOffset(instrButtonFrame, extraXOffset, 0);
    
    UIButton *button = [[UIButton alloc] initWithFrame:nextInstrButtonFrame];
    
    // Style button
    [button.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:24.0f]];
    [[button layer] setBorderWidth:6.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[button layer] setCornerRadius:18.0f];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    
    // Selector
    [button addTarget:self action:@selector(nextInstruction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // This creates the border around the button
    UIImageView *background = [[UIImageView alloc] initWithFrame:nextInstrButtonFrame];
    background.image = [UIImage imageNamed:@"menuBorder"];
    
    // Add background behind button
    [self addSubview:background];
    [self addSubview:button];
}

- (void)createPrevInstrButton
{
    // Setup button
    CGRect buttonFrame = [self createInstrButtonFrame];
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Style button
    [button.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:24.0f]];
    [[button layer] setBorderWidth:6.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[button layer] setCornerRadius:18.0f];
    [button setTitle:@"Previous" forState:UIControlStateNormal];
    
    // This creates the border around the button
    UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
    background.image = [UIImage imageNamed:@"menuBorder"];
    
    // Add background behind button
    [self addSubview:background];
    [self addSubview:button];
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

/***************
 *   SETTERS   *
 ***************/

-(void)setGifInstruction:(int)step
{
    //NSString *filename = [NSString stringWithFormat:@"instruction-%d", step];
    NSString *filename = @"DestroyingAsteroid";
    
    NSURL *gifURL2 = [[NSBundle mainBundle]
                      URLForResource:filename withExtension:@"gif"];
    UIImage *instrImg = [UIImage animatedImageWithAnimatedGIFURL:(NSURL *)gifURL2];
    [_instrGifView setImage:instrImg];
}

- (void)setTextInstruction:(int)step
{
    //NSString *filename = [NSString stringWithFormat:@"instructions-%d", step];
    NSString *filename = @"instructions";
    NSString *path = [[NSBundle mainBundle] pathForResource:filename
                                                     ofType:@"txt"];
    NSString *instrText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Style the text with a black-outlined border
    NSAttributedString *styledInstrText = [[NSAttributedString alloc] initWithString:instrText
        attributes:@{NSStrokeColorAttributeName:[UIColor blackColor],
                     NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-2.0],
                     NSFontAttributeName:[UIFont systemFontOfSize:24.0f],
                     NSForegroundColorAttributeName:[UIColor whiteColor]
                    }];
    _instrTextView.attributedText = styledInstrText;
    _instrTextView.editable = NO;
}

/************************
 *      SELECTORS       *
 ************************/

-(void)nextInstruction:(id)sender
{
    // Can't go to next if at the last step
    // TODO: This wouldn't be necessary if can logically disable/enable button
    if (_instrStep >= NUM_INSTR_STEPS){
        return;
    }
    
    ++_instrStep;
    [self setTextInstruction:_instrStep];
    [self setGifInstruction:_instrStep];
    
    if (_instrStep == NUM_INSTR_STEPS){
        // TODO: Visually (and logically?) disable button
    }
}

-(void)prevInstruction:(id)sender
{
    // Can't go to previous if at the first step
    // TODO: This wouldn't be necessary if can logically disable/enable button
    if (_instrStep <= 1){
        return;
    }
    
    --_instrStep;
    [self setTextInstruction:_instrStep];
    [self setGifInstruction:_instrStep];
    
    if (_instrStep == 1){
        // TODO: Visually (and logically?) disable button
    }
}

- (void)backButtonPressed
{
    [self.delegate backToMainMenu];
}

@end
