//
//  InstructionsView.m
//  FractionBlaster
//
//  Created by CS121 on 12/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

// TODO: Answer the following questions
//     - Separate gif and textview?
//     - Separate tutorial into parts (Solving equation vs Destroying Asteroid)?

#import "InstructionsView.h"
#import "UIImage+animatedGIF.h"

CGFloat INSET_RATIO;
int INSTR_FONT_SIZE = 20;

@implementation InstructionsView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"called");
    self = [super initWithFrame:frame];
    if (self) {
        [self createInstructions];
        //[self createInstructionsGif];
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
    
    CGFloat instrHeightRatio = (float)14/20;
    CGFloat instrWidthRatio = (float)3/7;
    
    CGFloat baseXOffset = (float)1/21 * frameWidth;
    CGFloat baseYOffset = (float)1/21 * frameHeight;
    
    // Instr dimensions setup
    CGFloat instrHeight = frameHeight * instrHeightRatio;
    CGFloat instrWidth = frameWidth * instrWidthRatio;
    
    // Y Offset has enough room for the height and the buffer
    CGFloat instrYOffset = frameHeight - (instrHeight + baseYOffset);
    
    // X Offsets - Gif offset is baseOffset away from end of text view
    CGFloat gifXOffset = (baseXOffset + instrWidth) + baseXOffset;
    
    // Create frames
    CGRect textViewFrame = CGRectMake(baseXOffset, instrYOffset, instrWidth, instrHeight);
    CGRect gifFrame = CGRectMake(gifXOffset, instrYOffset, instrWidth, instrHeight);
    
    // Text view - text container creation
    UITextView *instrText = [[UITextView alloc] initWithFrame:textViewFrame];
    instrText.backgroundColor = [UIColor clearColor];
    
    // Text view - Read instructions from file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"instructions"
                                                     ofType:@"txt"];
    NSString *myText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Text view - Style the text with a black-outlined border
    NSAttributedString *yourString = [[NSAttributedString alloc] initWithString:myText
      attributes:@{ NSStrokeColorAttributeName:[UIColor blackColor],
                    NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-2.0],
                    NSFontAttributeName:[UIFont systemFontOfSize:24.0f]
                    ,NSForegroundColorAttributeName:[UIColor whiteColor]
                  }];
    instrText.attributedText = yourString;
    instrText.editable = NO;
    
    // Gif
    UIImageView *instrGifView = [[UIImageView alloc] initWithFrame:gifFrame];
    NSURL *gifURL2 = [[NSBundle mainBundle]
                      URLForResource: @"DestroyingAsteroid" withExtension:@"gif"];
    UIImage *instrImg = [UIImage animatedImageWithAnimatedGIFURL:(NSURL *)gifURL2];
    [instrGifView setImage:instrImg];
    
    // Add subviews
    [self addSubview:instrText];
    [self addSubview:instrGifView];
}

//- (void)createInstructionsGif
//{
//    // Get frame size
//    CGFloat frameWidth = CGRectGetWidth(self.frame);
//    CGFloat frameHeight = CGRectGetHeight(self.frame);
//    CGFloat instrHeightRatio = 12/20;
//    CGFloat instrWidthRatio = 7/20;
//    CGFloat baseOffset = 1/10;
//    
//    // Width
//    CGFloat instrWidth = instrWidthRatio * width;
//    CGFloat instrGifXOffset = 2*baseOffset + instrGifWidth;
//    
//    // For height buffering
//    CGFloat minHeightBuffer = 0.05 * height;
//
//    // Height
//    // Add buffer between text and gif
//    CGFloat bottomTextOffset = 420;
//    CGFloat instrGifYOffset = bottomTextOffset + minHeightBuffer;
//    // Add buffer between gif and bottom of screen
//    CGFloat instrGifHeight = height - instrGifYOffset - minHeightBuffer;
//    
//    
//    CGRect instrGifFrame = CGRectMake(instrGifXOffset, instrGifYOffset, instrGifWidth, instrGifHeight);
//    UIImageView *instrGifView = [[UIImageView alloc] initWithFrame:instrGifFrame];
//    
//    // Set instructions view
//    NSURL *gifURL2 = [[NSBundle mainBundle]
//                      URLForResource: @"DestroyingAsteroid" withExtension:@"gif"];
//    UIImage *instrImg = [UIImage animatedImageWithAnimatedGIFURL:(NSURL *)gifURL2];
//    [instrGifView setImage:instrImg];
//    
//    [self addSubview:instrGifView];
//}

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
