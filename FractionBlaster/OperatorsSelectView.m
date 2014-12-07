//
//  OperatorsSelectView.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "OperatorsSelectView.h"

CGFloat INSET_RATIO;

// Enum object for button tags
typedef enum {
    StartTag,
    BackTag
}ButtonTags;

// Enum object for operator button tags
typedef enum {
    AdditionTag,
    SubtractionTag,
    MultiplicationTag,
    DivisionTag,
    SimplificationTag
}OperatorTags;

@implementation OperatorsSelectView
{
    UIButton* _startButton;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _operatorsSelected = [[NSMutableArray alloc] init];
        [self createTitle];
        [self createOperatorButtons];
        [self createBackButton];
        [self createStartButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

// Creates the level select title image at the top of the screen
-(void)createTitle
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(0, -50, frameWidth, frameHeight*.5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"Levels.png"];
    [self addSubview:imageView];
}

// Create the start button
-(void)createStartButton
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    // Create start button with the appropriate delegate
    CGRect startButtonFrame = CGRectMake(width * 0.2, height * 0.8, width * 0.6, height * 0.15);
    _startButton = [[UIButton alloc] initWithFrame:startButtonFrame];
    
    UIImage *image = [UIImage imageNamed:@"launch2.png"];
    [_startButton setImage:image forState:UIControlStateNormal];
    
    // Create target for button
    [_startButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    
    // Set tag appropriately
    _startButton.tag = StartTag;
    
    // Disable initially, until at least one operator has been selected
    [_startButton setEnabled:NO];
    
    [self addSubview:_startButton];
}

// Create the back button
- (void)createBackButton
{
    CGRect frame = self.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    CGFloat itemWidth = size / 15;
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    UIButton* backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[backButton layer] setCornerRadius:12.0f];
    
    // Create target for button
    [backButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    
    // Set tag appropriately
    backButton.tag = BackTag;
    
    [self addSubview:backButton];
}

// Create buttons to select the operators
- (void)createOperatorButtons
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat buttonSize = width / 8;
    CGFloat baseOffset = buttonSize / 4;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.5;
    CGFloat xOffset = buttonSize;
    
    for (int i = 0; i < 5; i++) {
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
        UIButton* currentButton = [[UIButton alloc] initWithFrame:buttonFrame];
        
        [currentButton setBackgroundColor:[UIColor whiteColor]];
        [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // Create target for button
        [currentButton addTarget:self action:@selector(operatorSelected:)
                forControlEvents:UIControlEventTouchUpInside];
        
        // Set tag appropriately
        currentButton.tag = i;
        
        // Set title according to the button tag
        switch (currentButton.tag){
            case AdditionTag:
            {
                [currentButton setTitle:@"+" forState:UIControlStateNormal];
                break;
            }
            case SubtractionTag:
                {
                [currentButton setTitle:@"-" forState:UIControlStateNormal];
                break;
            }
            case MultiplicationTag:
            {
                [currentButton setTitle:@"X" forState:UIControlStateNormal];
                break;
            }
            case DivisionTag:
            {
                [currentButton setTitle:@"÷" forState:UIControlStateNormal];
                break;
            }
            case SimplificationTag:
            {
                [currentButton setTitle:@"Simplify" forState:UIControlStateNormal];
                break;
            }
        }
        
        [self addSubview:currentButton];
        
        // Increment offset for next button frame
        xOffset += baseOffset + buttonSize;
    }
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

// Function to update the selected operators
- (void)operatorSelected:(id)sender
{
    // Determine which button was selected
    UIButton* button = (UIButton*)sender;
    
    // Determine the operator selected according to the tag
    NSString* operator;
    switch (button.tag){
        case AdditionTag:
        {
            operator = @"+";
            break;
        }
        case SubtractionTag:
        {
            operator = @"-";
            break;
        }
        case MultiplicationTag:
        {
            operator = @"*";
            break;
        }
        case DivisionTag:
        {
            operator = @"/";
            break;
        }
        case SimplificationTag:
        {
            operator = @"$";
            break;
        }
    }
    
    // If a button was deselected, remove the operator
    if (button.backgroundColor == [UIColor grayColor]) {
        [_operatorsSelected removeObject:operator];
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    
    // Else, add the operator
    else {
        [_operatorsSelected addObject:operator];
        [button setBackgroundColor:[UIColor grayColor]];
    }
    
    // Enable/disable start button
    [self updateStartButton];
}

// Functiont that sets the enabled property of the start button
- (void)updateStartButton
{
    // If there are no operators selected, disable
    if ([_operatorsSelected count] == 0) {
        [_startButton setEnabled:NO];
    }
    
    // Else, enable
    else {
        [_startButton setEnabled:YES];
    }
}

@end
