//
//  OperatorsSelectView.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "OperatorsSelectView.h"
#import "Constants.h"

// Enum object for button tags
typedef enum {
    AdditionTag,
    SubtractionTag,
    MultiplicationTag,
    DivisionTag,
    SimplificationTag,
    StartTag,
    BackTag
} ButtonTags;


@implementation OperatorsSelectView
{
    UIButton *_startButton;
    bool _additionSelected;
    bool _subtractionSelected;
    bool _multiplicationSelected;
    bool _divisionSelected;
    bool _simplificationSelected;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _operatorsSelected = [[NSMutableArray alloc] init];
        [self createTitle];
        [self createBackgroundImages];
        [self createOperatorButtons];
        [self createBackButton];
        [self createStartButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

// Create images in the background for aesthetics i.e. pipes and 3D ship
- (void)createBackgroundImages
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect buttonFrame = CGRectMake(width * 0.6, height * 0.07, width * 0.4, width * 0.4);
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
    [self createAdditionButton];
    [self createSubtractionButton];
    [self createMultiplicationButton];
    [self createDivisionButton];
    [self createSimplificationButton];
}

// Create the addition button
- (void)createAdditionButton
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat buttonSize = width / 4;
    
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.35;
    CGFloat xOffset = width * 0.2;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Set the tag appropriately
    button.tag = AdditionTag;
    
    [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    
    // Create target for button
    [button addTarget:self action:@selector(operatorSelected:)
            forControlEvents:UIControlEventTouchUpInside];
    
    // Allows for operator selected sound to be played by the view controller
    [button addTarget:self action:@selector(buttonSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    // Create the image for the button
    UIImageView *foreground = [[UIImageView alloc] initWithFrame:buttonFrame];
    foreground.image = [UIImage imageNamed:@"plus"];
    
    [self addSubview:foreground];
}

// Create the subtraction button
-(void)createSubtractionButton
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat buttonSize = width / 4;
    
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.65;
    CGFloat xOffset = width * 0.2;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Set the tag appropriately
    button.tag = SubtractionTag;
    
    [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    
    // Create target for button
    [button addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // Allows for operator selected sound to be played by the view controller
    [button addTarget:self action:@selector(buttonSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    // Create the image for the button
    UIImageView *foreground = [[UIImageView alloc] initWithFrame:buttonFrame];
    foreground.image = [UIImage imageNamed:@"minus"];
    
    [self addSubview:foreground];
}

// Create the multiplication button
- (void)createMultiplicationButton
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat buttonSize = width / 4;
    
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.65;
    CGFloat xOffset = width * 0.55;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Set the tag appropriately
    button.tag = MultiplicationTag;
    
    [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    
    // Create the target for the button
    [button addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // Allows for operator selected sound to be played by the view controller
    [button addTarget:self action:@selector(buttonSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    // Create the image for the button
    UIImageView *foreground = [[UIImageView alloc] initWithFrame:buttonFrame];
    foreground.image = [UIImage imageNamed:@"times"];
    
    [self addSubview:foreground];
}

// Create the division button
- (void)createDivisionButton
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat buttonSize = width / 4;
    
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.35;
    CGFloat xOffset = width * 0.55;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Set the tag appropriately
    button.tag = DivisionTag;
    
    [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    
    // Create the target for the button
    [button addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // Allows for operator selected sound to be played by the view controller
    [button addTarget:self action:@selector(buttonSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    // Create the image for the button
    UIImageView *foreground = [[UIImageView alloc] initWithFrame:buttonFrame];
    foreground.image = [UIImage imageNamed:@"divide"];
    
    [self addSubview:foreground];
}

// Create the simplification button
- (void)createSimplificationButton
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat buttonSize = width / 4;
    
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.5;
    CGFloat xOffset = width * 0.37;
    
    CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    // Set the tag appropriately
    button.tag = SimplificationTag;
    
    [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
    
    // Create the target for the button
    [button addTarget:self action:@selector(operatorSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // Allows for operator selected sound to be played by the view controller
    [button addTarget:self action:@selector(buttonSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    // Create the image for the button
    CGRect foregroundFrame = CGRectMake(xOffset*1.07, yOffset*1.13, buttonSize*0.78, buttonSize*0.3);
    UIImageView *foreground = [[UIImageView alloc] initWithFrame:foregroundFrame];
    foreground.image = [UIImage imageNamed:@"simplify"];
    
    [self addSubview:foreground];
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

// Function to update the selected operators and the background images
- (void)operatorSelected:(id)sender
{
    // Determine which button was selected
    UIButton* button = (UIButton*)sender;
    
    // Determine the operator selected according to the tag, add/remove from selected operators,
    // and update button image depending on whether currently selected or deselected
    NSString* operator;
    switch (button.tag) {
        case AdditionTag:
        {
            operator = @"+";
            
            if (_additionSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                _additionSelected = false;
            }
            else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                _additionSelected = true;
            }
            break;
        }
        case SubtractionTag:
        {
            operator = @"-";
            
            if (_subtractionSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                _subtractionSelected = false;
            }
            else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                _subtractionSelected = true;
            }
            break;
        }
        case MultiplicationTag:
        {
            operator = @"*";
            
            if (_multiplicationSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                _multiplicationSelected = false;
            }
            else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                _multiplicationSelected = true;
            }
            break;
        }
        case DivisionTag:
        {
            operator = @"/";
            
            if (_divisionSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                _divisionSelected = false;
            }
            else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                _divisionSelected = true;
            }
            break;
        }
        case SimplificationTag:
        {
            operator = @"$";
            
            if (_simplificationSelected) {
                [_operatorsSelected removeObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use"] forState:UIControlStateNormal];
                _simplificationSelected = false;
            }
            else {
                [_operatorsSelected addObject:operator];
                [button setBackgroundImage:[UIImage imageNamed:@"asteroid_button_use_highlight"] forState:UIControlStateNormal];
                _simplificationSelected = true;
            }
            break;
        }
    }
    
    // Enable/disable start button
    [self updateStartButton];
}

// Function that sets the enabled property of the start button
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
