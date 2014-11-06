//
//  SideBarView.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "SideBarView.h"

@implementation SideBarView {
    NSMutableArray* _buttons;
    id _target;
    SEL _action;
}


// Initialize the side bar
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeButtonsWithFrame:frame];
    }
    return self;
}


// Defines viewcontroller as the target class to return
// information about the side bar
-(void)setAction:(SEL)action
      withTarget:(id)target {
    _target = target;
    _action = action;
    
}


// This returns information to the viewcontroller
// about which button was pressed
- (void)buttonPressed:(id)sender {
    // take the tag of button selected and send it back to the
    // target (which is viewcontroller)
    UIButton* button = (UIButton*) sender;
    NSNumber* tag = [NSNumber numberWithInteger:[button tag] ];
    [_target performSelector:_action withObject:tag];
}


// Initializes all of the UIButtons and allocates them in a 1X4 frame
- (void)makeButtonsWithFrame:(CGRect)frame{
    _buttons = [ [NSMutableArray alloc] initWithCapacity:4];
    
    // create fraction frame
    CGFloat x = CGRectGetWidth(frame);
    CGFloat y = CGRectGetHeight(frame);
    CGRect buttonFrame = CGRectMake(0, 0, x, y);
    CGFloat offset = .16*y;
    
    // create fraction view
    UIView* backgroundView;
    backgroundView = [ [UIView alloc] initWithFrame:buttonFrame];
    [backgroundView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:backgroundView];
    
    // set initial values for buttons we will create
    int currentTag = 0;
    
    // Build the board and fill the NSMutable array with buttons
    for (int i = 0; i < 4; i++) {
        // create the button
        UIButton* button;
        CGFloat buttonSize = y/7;
        CGRect buttonFrame = CGRectMake(5, .1*buttonSize+i*offset, x, buttonSize*.9);
        
        button = [ [UIButton alloc] initWithFrame:buttonFrame];
        button.backgroundColor = [UIColor redColor];
        [self addSubview:button];
        
        // give button correct attributes
        [button addTarget:self action:@selector(buttonPressed:)
         forControlEvents:UIControlEventTouchUpInside]; //make own version of this
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.showsTouchWhenHighlighted = YES;
        button.tag = currentTag;
        
        currentTag++;
        
        // insert the button
        [_buttons insertObject:button atIndex:i];
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