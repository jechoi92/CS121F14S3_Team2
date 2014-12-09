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
int NUM_INSTR_STEPS = 2;
CGFloat BASE_OFFSET_PCT = (float)1/21;

@implementation InstructionsView
{
    UIImageView *_instrGifView;
    UITextView *_instrTextView;
    UIButton *_prevInstrButton;
    UIButton *_nextInstrButton;
    
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

- (void)createInstrText
{
    // Get frame size
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat instrHeightRatio = (float)5/20;
    CGFloat instrWidthRatio = (float)0.8;
    
    // Instr dimensions setup
    CGFloat instrHeight = frameHeight * instrHeightRatio;
    CGFloat instrWidth = frameWidth * instrWidthRatio;
    
    // Y Offset has enough room for the height and the buffer
    CGFloat yOffset = 0.25 * frameHeight;
    CGFloat xOffset = (frameWidth - instrWidth)/2;

    CGRect textViewFrame = CGRectMake(xOffset, yOffset, instrWidth, instrHeight);

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
    // Get the gif corresponding to the current step
    NSString *filename = [NSString stringWithFormat:@"instructions-%d", _instrStep];
    
    NSURL *gifURL2 = [[NSBundle mainBundle]
                      URLForResource:filename withExtension:@"gif"];
    
    // Convert the gif to an img
    UIImage *instrImg = [UIImage animatedImageWithAnimatedGIFURL:(NSURL *)gifURL2];
    
    // Get image dimensions for height and width
    CGSize imgDimensions = [instrImg size];
    CGFloat imgWidth = imgDimensions.width;
    CGFloat imgHeight = imgDimensions.height;
    
    // Center image horizotally
    CGFloat imgXOff = (CGRectGetWidth(self.frame) - imgWidth) / 2;
    
    // Hard-coded y off? TODO: Magic number
    CGFloat imgYOff = 0.5 * CGRectGetHeight(self.frame);
    
    // Create view with image
    CGRect gifFrame = CGRectMake(imgXOff, imgYOff, imgWidth, imgHeight);
    _instrGifView = [[UIImageView alloc] initWithFrame:gifFrame];
    [_instrGifView setImage:instrImg];
    
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
    
    _nextInstrButton = [[UIButton alloc] initWithFrame:nextInstrButtonFrame];
    
    // Style button
    [_nextInstrButton.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:24.0f]];
    [[_nextInstrButton layer] setBorderWidth:6.0f];
    [[_nextInstrButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_nextInstrButton layer] setCornerRadius:18.0f];
    [_nextInstrButton setTitle:@"Next" forState:UIControlStateNormal];
    
    // Selector
    [_nextInstrButton addTarget:self action:@selector(nextInstruction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // This creates the border around the button
    UIImageView *background = [[UIImageView alloc] initWithFrame:nextInstrButtonFrame];
    background.image = [UIImage imageNamed:@"menuBorder"];
    
    // Add background behind button
    [self addSubview:background];
    [self addSubview:_nextInstrButton];
}

- (void)createPrevInstrButton
{
    // Setup button
    CGRect buttonFrame = [self createInstrButtonFrame];
    _prevInstrButton = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Style button
    [_prevInstrButton.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:24.0f]];
    [[_prevInstrButton layer] setBorderWidth:6.0f];
    [[_prevInstrButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_prevInstrButton layer] setCornerRadius:18.0f];
    [_prevInstrButton setTitle:@"Previous" forState:UIControlStateNormal];
    
    // Selector
    [_prevInstrButton addTarget:self action:@selector(prevInstruction:)
               forControlEvents:UIControlEventTouchUpInside];
    
    // This creates the border around the button
    UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
    background.image = [UIImage imageNamed:@"menuBorder"];
    
    // Add background behind button
    [self addSubview:background];
    [self addSubview:_prevInstrButton];
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
    // Get the gif corresponding to the current step
    NSString *filename = [NSString stringWithFormat:@"instructions-%d", step];
    
    NSURL *gifURL2 = [[NSBundle mainBundle]
                      URLForResource:filename withExtension:@"gif"];
    
    // Convert the gif to an img
    UIImage *instrImg = [UIImage animatedImageWithAnimatedGIFURL:(NSURL *)gifURL2];
    
    // Get height and width for new img
    CGSize imgDimensions = [instrImg size];
    CGFloat imgWidth = imgDimensions.width;
    CGFloat imgHeight = imgDimensions.height;
    
    // Center image horizotally
    CGFloat imgXOff = (CGRectGetWidth(self.frame) - imgWidth) / 2;
    
    // TODO: is _instrGifView... good style?
    CGRect newFrame = CGRectMake(imgXOff, _instrGifView.frame.origin.y, imgWidth, imgHeight);
    [_instrGifView setFrame:newFrame];
    
    // Set the image
    [_instrGifView setImage:instrImg];
}

- (void)setTextInstruction:(int)step
{
    // Get the instructions for the current step
    NSString *filename = [NSString stringWithFormat:@"instructions-%d", step];
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
        // [_prevInstrButton setBackgroundImage:[UIImage ] forState:UIControlStateNormal];
    }
}

- (void)backButtonPressed
{
    [self.delegate backToMainMenu];
}

@end
