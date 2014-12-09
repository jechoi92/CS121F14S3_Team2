//
//  TipView.m
//  FractionBlaster
//
//  Created by Laptop16 on 12/6/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "TipView.h"
#import "UIImage+animatedGIF.h"

CGFloat INSET_RATIO;

@implementation TipView
{
    char _operator;
}

-(id)initWithFrame:(CGRect)frame andLevel:(int)level
{
    self = [super initWithFrame:frame];
    
    if (self){
        // Style background
        [self setBackgroundColor:[UIColor grayColor]];
        
        // Specify the tip for certain levels
        switch (level) {
            case 1:
                _operator = '$';
                break;
            case 2:
                _operator = '*';
                break;
            case 3:
                _operator = '/';
                break;
            case 4:
                _operator = '+';
                break;
            default:
                [self acceptPressed:self];
                break;
        }
        
        [self createTitle];
        [self createTipImg];
        [self createTipText];
        [self createAcceptButton];
    }
    
    return self;
}

-(void)createTitle
{
    // Constants
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    
    // Set up frame dimensions
    CGFloat titleHeight = 0.15 * frameHeight;
    CGFloat titleWidth = 0.9 * frameWidth;
    CGFloat titleYOff = INSET_RATIO * frameHeight;
    CGFloat titleXOff = (frameWidth - titleWidth) / 2;
    
    // Make frame and label
    CGRect titleFrame = CGRectMake(titleXOff, titleYOff, titleWidth, titleHeight);
    UILabel *tipTitle = [[UILabel alloc] initWithFrame:titleFrame];
    
    // Get appropriate title from operator
    NSString *title;
    switch (_operator) {
        case '$':
            title = @"Simplification";
            break;
        case '*':
            title = @"Multiplication";
            break;
        case '/':
            title = @"Division";
            break;
        case '+':
            title = @"Addition/Subtraction";
            break;
        default:
            break;
    }
    
    // Set and style title
    [tipTitle setText:title];
    [tipTitle setTextColor:[UIColor yellowColor]];
    [tipTitle setBackgroundColor:[UIColor clearColor]];
    [tipTitle setTextAlignment:NSTextAlignmentCenter];
    // TODO: Magic number
    [tipTitle setFont:[UIFont fontWithName:@"SpaceAge" size:28]];
    
    [self addSubview:tipTitle];
}

-(void)createTipImg
{
    // Get image
    // TODO: Get images
//    NSString *imgName;
//    switch (_operator) {
//        case '$':
//            imgName = @"simp-img";
//            break;
//        case '*':
//            imgName = @"mult-img";
//            break;
//        case '/':
//            imgName = @"div-img";
//            break;
//        case '+':
//            imgName = @"add-sub-img";
//            break;
//        default:
//            break;
//    }
    NSString *imgName = @"instructions-1";
    
    // TODO?: Placeholder for image to see if it loads correctly
    NSURL *gifURL2 = [[NSBundle mainBundle]
                      URLForResource:imgName withExtension:@"gif"];
    UIImage *tipImg = [UIImage animatedImageWithAnimatedGIFURL:(NSURL *)gifURL2];
    
    // Get image dimensions for height and width
    CGSize imgDimensions = [tipImg size];
    CGFloat imgWidth = imgDimensions.width;
    CGFloat imgHeight = imgDimensions.height;
    
    // Hardcoded y-offset
    CGFloat imgYOff = 0.2 * CGRectGetHeight(self.frame);
    
    // Center image horizontally
    CGFloat imgXOff = (CGRectGetWidth(self.frame) - imgWidth) / 2;
    
    // Make frame and imageView
    CGRect imgFrame = CGRectMake(imgXOff, imgYOff, imgWidth, imgHeight);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:imgFrame];
    
    // Set the image
    [imgView setImage:tipImg];
    
    // Add subview
    [self addSubview:imgView];
}

-(void)createTipText
{
    // Constants
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    
    // Set up frame dimensions
    CGFloat textHeight = 0.4 * frameHeight;
    CGFloat textWidth = 0.9 * frameWidth;
    CGFloat textYOff = 0.5 * frameHeight;
    CGFloat textXOff = (frameWidth - textWidth) / 2;
    
    // Make frame and textview
    CGRect tipTextFrame = CGRectMake(textXOff, textYOff, textWidth, textHeight);
    UITextView *tipTextView = [[UITextView alloc] initWithFrame:tipTextFrame];
    
    // Choose right file based on operator
    NSString *filename = @"tip";
    switch (_operator) {
        // TODO: Upload simplification file?
        case '$':
            filename = [NSString stringWithFormat:@"simp-%@", filename];
            return;
        case '*':
            filename = [NSString stringWithFormat:@"mult-%@", filename];
            break;
        case '/':
            filename = [NSString stringWithFormat:@"div-%@", filename];
            break;
        case '+':
            filename = [NSString stringWithFormat:@"add-sub-%@", filename];
            break;
        default:
            break;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename
                                                     ofType:@"txt"];
    NSString *tipText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Style the text with a black-outlined border
    NSAttributedString *styledInstrText = [[NSAttributedString alloc] initWithString:tipText
                attributes:@{NSStrokeColorAttributeName:[UIColor yellowColor],
                             NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-2.0],
                             NSFontAttributeName:[UIFont systemFontOfSize:24.0f],
                             NSForegroundColorAttributeName:[UIColor blackColor]
                            }];
    tipTextView.attributedText = styledInstrText;
    tipTextView.editable = NO;
    
    [tipTextView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:tipTextView];
}

-(void)createAcceptButton
{
    // Frame constants
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat frameWidth = CGRectGetWidth(self.frame);
    CGFloat buttonHeight = 60;
    CGFloat buttonWidth = 140;
    
    // Leave room for button + margin
    CGFloat yOffFromBottom = (INSET_RATIO * frameHeight) + buttonHeight;
    CGFloat buttonYOff = frameHeight - yOffFromBottom;
    
    // Center the button
    CGFloat buttonXOff = (frameWidth - buttonWidth) / 2;
    
    // Create frame and button
    CGRect buttonFrame = CGRectMake(buttonXOff, buttonYOff, buttonWidth, buttonHeight);
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Set title
    [acceptButton setTitle:@"Got it!" forState:UIControlStateNormal];
    [acceptButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [acceptButton.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:28]];
    [acceptButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    // Background
    [acceptButton setBackgroundColor:[UIColor yellowColor]];
    
    // Selector
    [acceptButton addTarget:self action:@selector(acceptPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add as subview
    [self addSubview:acceptButton];
}

-(void)acceptPressed:(id)sender
{
    [self.delegate dismissTip];
}


@end
