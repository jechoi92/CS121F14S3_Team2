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
    NSMutableArray* _buttons;
}



// Initialize the side bar
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeButtonsWithFrame];
    }
    return self;
}


// This returns information to the viewcontroller
// about which button was pressed
- (void)buttonPressed:(id)sender {
    // take the tag of button selected and send it back to the
    // target (which is viewcontroller)
    UIButton* button = (UIButton*) sender;
    NSNumber* buttonTag = [NSNumber numberWithInteger:[button tag] ];
    [self.delegate laserFrequencyChosen:buttonTag];
}


// Initializes all of the UIButtons and allocates them in a 1X4 frame
- (void)makeButtonsWithFrame
{
    CGRect frame = self.frame;
    _buttons = [[NSMutableArray alloc] initWithCapacity:TOTAL_INITIAL_FRACTIONS];
    
    
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat paddingSize = width * 0.1;
    
    CGFloat height = CGRectGetHeight(frame);
    
    CGFloat buttonWidth = width - (2.0 * paddingSize);
    CGFloat buttonHeight = (height - ((TOTAL_INITIAL_FRACTIONS + 1) * paddingSize)) / (TOTAL_INITIAL_FRACTIONS);
    
    for (int i = 0; i < TOTAL_INITIAL_FRACTIONS; i++) {
        CGFloat inset = (i + 1) * paddingSize + i * buttonHeight;
        
        CGRect buttonFrame = CGRectMake(paddingSize, inset, buttonWidth, buttonHeight);
        UIButton* currentButton = [[UIButton alloc] initWithFrame:buttonFrame];
        currentButton.backgroundColor = [UIColor clearColor];
        [[currentButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        [[currentButton layer] setBorderWidth:2.5f];
        [[currentButton layer] setCornerRadius:8.0f];
        [currentButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
        
        
        // insert the button
        [self addSubview:currentButton];
        currentButton.tag = i;
        [currentButton addTarget:self action:@selector(buttonPressed:)
                forControlEvents:UIControlEventTouchUpInside]; //make own version of this
        [_buttons insertObject:currentButton atIndex:i];
    }
}


// Return the button at an index
-(UIButton*)getCellWithIndex:(int)index {
    return _buttons[index];
}


// Inserts the designated fraction into the correct
// button on the side bar
- (void)setValueAtIndex:(int)index
              withValue:(Fraction*)value {
    UIButton* cell = [self getCellWithIndex:index];
    
    //retrieve the fraction
    NSString* fracToFill = [value description];
    
    [cell setTitle:fracToFill forState:UIControlStateNormal];
}



@end