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
    bool plusSelected;
    bool minusSelected;
    bool timesSelected;
    bool divideSelected;
    bool simplifySelected;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _operatorsSelected = [[NSMutableArray alloc] init];
      //  [self createTitle];
        [self createLabel];
        [self addBackgroundImages];
        [self createOperatorButtons];
        [self createBackButton];
        [self createStartButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

- (void)addBackgroundImages
{
    // Create the blue ship for artistic pleasure
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect buttonFrame = CGRectMake(width*0.6, height*0.07, width*0.4, width*0.4);
    UIImageView *backgroundShip = [[UIImageView alloc] initWithFrame:buttonFrame];
    backgroundShip.image = [UIImage imageNamed:@"bluespaceshipback"];
    [self addSubview:backgroundShip];
    [self sendSubviewToBack:backgroundShip];
    
    CGFloat pipeWidth = CGRectGetWidth(self.frame) * 0.07;
    CGFloat pipeHeight = CGRectGetHeight(self.frame) * 0.2;
    CGFloat pipexOffset1 = CGRectGetWidth(self.frame) * 0.15;
    CGFloat pipexOffset2 = CGRectGetWidth(self.frame) * 0.45;
    
    CGRect pipeFrame1 = CGRectMake(pipexOffset1, -pipexOffset1*0.02, pipeWidth, pipeHeight);
    CGRect pipeFrame2 = CGRectMake(pipexOffset2, -pipexOffset1*0.02, pipeWidth, pipeHeight);
    
    UIImageView *pipe1 = [[UIImageView alloc] initWithFrame:pipeFrame1];
    pipe1.image = [UIImage imageNamed:@"pipe"];
    
    UIImageView *pipe2 = [[UIImageView alloc] initWithFrame:pipeFrame2];
    pipe2.image = [UIImage imageNamed:@"pipe"];
    
    [self addSubview:pipe1];
    [self addSubview:pipe2];
    [self sendSubviewToBack:pipe1];
    [self sendSubviewToBack:pipe2];
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

- (void)createLabel
{
    CGFloat labelWidth = CGRectGetWidth(self.frame) * 0.48;
    CGFloat labelHeight = CGRectGetHeight(self.frame) * 0.14;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.1;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.1;
    
    CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.numberOfLines = 4;
    label.textAlignment = NSTextAlignmentCenter;
    
    [label setFont:[UIFont fontWithName:@"SpaceAge" size:32.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Choose the types of Asteroids to destroy!"];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:labelFrame];
    background.image = [UIImage imageNamed:@"menuBorder"];
    
    [self addSubview:background];
    [self addSubview:label];
}

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
    CGFloat buttonSize = width / 4;
    
    [self createPlusButton:buttonSize];
    [self createMinusButton:buttonSize];
    [self createTimesButton:buttonSize];
    [self createDivideButton:buttonSize];
    [self createSimplifyButton:buttonSize];
}

- (void)createPlusButton:(CGFloat)buttonSize
{
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.3;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.35;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton* plusButton = [[UIButton alloc] initWithFrame:buttonFrame];
    plusButton.tag = 0;
    [plusButton setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(operatorSelected:)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusButton];
    plusSelected = false;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
    background.image = [UIImage imageNamed:@"plus"];
    [self addSubview:background];
}

-(void)createMinusButton:(CGFloat)buttonSize
{
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.45;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.05;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton* minusButton = [[UIButton alloc] initWithFrame:buttonFrame];
    minusButton.tag = 1;
    [minusButton setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusButton];
    minusSelected = false;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
    background.image = [UIImage imageNamed:@"minus"];
    [self addSubview:background];
}

- (void)createTimesButton:(CGFloat)buttonSize
{
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.65;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.5;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton* timesButton = [[UIButton alloc] initWithFrame:buttonFrame];
    timesButton.tag = 2;
    [timesButton setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    [timesButton addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timesButton];
    timesSelected = false;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
    background.image = [UIImage imageNamed:@"times"];
    [self addSubview:background];
}

- (void)createDivideButton:(CGFloat)buttonSize
{
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.52;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.7;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton* divideButton = [[UIButton alloc] initWithFrame:buttonFrame];
    divideButton.tag = 3;
    [divideButton setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    [divideButton addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:divideButton];
    plusSelected = false;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
    background.image = [UIImage imageNamed:@"divide"];
    [self addSubview:background];
}

- (void)createSimplifyButton:(CGFloat)buttonSize
{
    
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.5;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.37;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton* simplifyButton = [[UIButton alloc] initWithFrame:buttonFrame];
    simplifyButton.tag = 4;
    [simplifyButton setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    [simplifyButton addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:simplifyButton];
    simplifySelected = false;
    
    CGRect label = CGRectMake(xOffset*1.07, yOffset*1.13, buttonSize*0.78, buttonSize*0.3);
    UIImageView *background = [[UIImageView alloc] initWithFrame:label];
    background.image = [UIImage imageNamed:@"simplify"];
    [self addSubview:background];
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
    switch (button.tag) {
        case 0:
        {
            operator = @"+";
            
            if (plusSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                plusSelected = false;
                
            } else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                plusSelected = true;
            }
            break;
        }
        case SubtractionTag:
        {
            operator = @"-";
            
            if (minusSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                minusSelected = false;
            } else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                minusSelected = true;
            }
            break;
        }
        case MultiplicationTag:
        {
            operator = @"*";
            
            if (timesSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                timesSelected = false;
            } else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                timesSelected = true;
            }
            break;
        }
        case DivisionTag:
        {
            operator = @"/";
            
            if (divideSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                divideSelected = false;
            } else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                divideSelected = true;
            }
            break;
        }
        case SimplificationTag:
        {
            operator = @"$";
            
            if (simplifySelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                simplifySelected = false;
            } else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                simplifySelected = true;
            }
            break;
        }
    }
    
    if ([_operatorsSelected count] == 0) {
        [_startButton setEnabled:NO];
    }
    
    // Else, enable
    else {
        [_startButton setEnabled:YES];
    }
}

@end
