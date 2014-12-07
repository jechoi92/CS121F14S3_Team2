//
//  SideBarView.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

int TOTAL_INITIAL_FRACTIONS;

#import "SideBarView.h"

@implementation SideBarView {
    NSMutableArray *_buttons;
}

// Initialize the side bar
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createContainer];
        [self createButtons];
    }
    return self;
}

// Function to handle button presses
- (void)buttonPressed:(id)sender {
    // Determine which button was selected
    UIButton *button = (UIButton*) sender;
    NSNumber *buttonTag = [NSNumber numberWithInteger:[button tag]];
    
    [self.delegate laserFrequencyChosen:buttonTag];
}

// Creates frame that holds buttons for aesthetics
- (void)createContainer
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    UIImageView *container = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"laser_panel@2x.png"]];
    [container setFrame:CGRectMake(width * 0.1, 0, width * 0.85, height * 0.93)];
    
    [self addSubview:container];
}

// Initializes all of the UIButtons and allocates them in a 1 by 4 frame
- (void)createButtons
{
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat paddingSize = width * 0.20;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat buttonWidth = width - (2.0 * paddingSize);
    CGFloat buttonHeight = buttonWidth;
    paddingSize *= 0.5;
    CGFloat initialYInset = height*0.07;
    CGFloat initialXInset = width*0.16;
    
    // Creates array that stores the buttons
    _buttons = [[NSMutableArray alloc] initWithCapacity:TOTAL_INITIAL_FRACTIONS];

    // Create all buttons
    for (int i = 0; i < TOTAL_INITIAL_FRACTIONS; i++) {
        // Instantiate the button with a certain frame and offset
        CGFloat inset = (i + 1) * (paddingSize) + i * buttonHeight;
        CGRect buttonFrame = CGRectMake(paddingSize + initialXInset, inset + initialYInset, buttonWidth, buttonHeight);
        UIButton* currentButton = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Add particular features to the button
        currentButton.backgroundColor = [UIColor clearColor];
        [[currentButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[currentButton layer] setBorderWidth:2.5f];
        [[currentButton layer] setCornerRadius:8.0f];
        [currentButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f]];
        
        // Add background buttons for printing of the fractions
        CGRect backgroundFrame = CGRectMake(paddingSize + initialXInset, inset + initialYInset - buttonHeight / 3 * 0.9 , buttonWidth, buttonHeight);
        UIButton *backgroundButton = [[UIButton alloc] initWithFrame:backgroundFrame];
        backgroundButton.backgroundColor = [UIColor clearColor];
        [backgroundButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0f]];
        backgroundButton.titleLabel.numberOfLines = 2;
        NSString *line = [NSString stringWithFormat:@"__\r"];
        
        [backgroundButton setTitle:line forState:UIControlStateNormal];
        
        // Add the button to the screen
        [self addSubview:backgroundButton];
        [self addSubview:currentButton];
        
        // Set tag appropriately
        currentButton.tag = i;
        
        // Create target for button
        [currentButton addTarget:self action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchDown];
        
        // Add button to array
        [_buttons insertObject:currentButton atIndex:i];
    }
}

// Return the button at the designated index
-(UIButton*)getButtonWithIndex:(int)index {
    return _buttons[index];
}

// Inserts the designated fraction into the correct button on the side bar
- (void)setValueAtIndex:(int)index withValue:(Fraction*)value {
    // First get the desired button
    UIButton *button = [self getButtonWithIndex:index];
    int numerator = [value numerator];
    int denominator = [value denominator];
    
    // Create the text string according to the lengths of the numerator and denominator
    NSString *fracToFill;
    if (denominator > 9) {
        fracToFill = [NSString stringWithFormat:@" %d\r%d", numerator, denominator];
    } else if (numerator > 9) {
        fracToFill = [NSString stringWithFormat:@"%d\r %d", numerator, denominator];
    } else {
        fracToFill = [NSString stringWithFormat:@"%d\r%d", numerator, denominator];
    }
    
    button.titleLabel.numberOfLines = 2;
    [button setTitle:fracToFill forState:UIControlStateNormal];
}

    

@end