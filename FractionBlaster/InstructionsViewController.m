//
//  InstructionsViewController.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "InstructionsViewController.h"

int INSTR_FONT_SIZE = 20;

@implementation InstructionsViewController
{
    UITextView *_instrText;
    UIButton *_backButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set background to same as main menu
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    
    // Set up
    [self createBackButton];
    [self createInstrText];
}

-(void)createBackButton
{
    CGFloat INSET_RATIO = 0.02;
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
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

-(void)createInstrText
{
    // Get frame size
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);
    CGFloat textViewHeightRatio = 0.75;
    CGFloat textViewWidthRatio = 0.75;
    
    // Text view frame setup
    CGFloat textViewHeight = frameHeight*textViewHeightRatio;
    CGFloat textViewWidth = frameWidth*textViewWidthRatio;
    CGFloat textViewXOffset = (frameWidth-textViewWidth)/2;
    CGFloat textViewYOffset = (frameHeight-textViewHeight)/2;
    
    CGRect textViewFrame = CGRectMake(textViewXOffset, textViewYOffset, textViewWidth, textViewHeight);
    
    // Text container creation
    _instrText = [[UITextView alloc] initWithFrame:textViewFrame];
    _instrText.backgroundColor = [UIColor clearColor];
    
    // Read instructions from file
    NSString* path = [[NSBundle mainBundle] pathForResource:@"instructions"
                                                     ofType:@"txt"];
    NSString *myText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _instrText.text  = myText;
    
    // Style the text
    _instrText.textColor = [UIColor whiteColor];
    [_instrText setFont:[UIFont fontWithName:@"Futura-Medium" size:INSTR_FONT_SIZE]];
    _instrText.editable = NO;
    
    // Add as subview
    [self.view addSubview:_instrText];
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
