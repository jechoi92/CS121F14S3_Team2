//
//  Sidebar.m
//  SpriteKitSimpleGame
//
//  Created by Alejandro Mendoza on 10/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "Sidebar.h"

@implementation Sidebar {
    NSMutableArray* _buttons;
    id _target;
    SEL _action;
    int numSelected;
}

// initialize the numpad
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeButtonsWithFrame:frame];
    }
    return self;
}

// Defines viewcontroller as the target class to return
// information about the number pad to.
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
    
    numSelected = [tag intValue];
    
    // unhighlight all currently highlighted buttons and then highlight pressed button
    [self unhighlightAll];
    [(id)sender setBackgroundColor:[UIColor redColor]];
}

// returns the currently selected number
-(int)numSelected {
    return numSelected;
}


// helper method to unhighlight all currently highlighted buttons
-(void)unhighlightAll {
    for (int i = 0; i < 10; i++) {
        UIButton *button = _buttons[i];
        [button setBackgroundColor:[[UIColor alloc] initWithRed:1 green:0.7 blue:0.8 alpha:1]];
    }
}

// initializes all of the UIButtons and allocates them in a 2X5 frame
- (void)makeButtonsWithFrame:(CGRect)frame {
    _buttons = [ [NSMutableArray alloc] initWithCapacity:9];
    
    // create numpad frame
    CGFloat x = CGRectGetWidth(frame);
    CGFloat y = CGRectGetHeight(frame);
    CGRect buttonFrame = CGRectMake(0, 5, x*0.86, y+42);
    CGFloat offset = .155*x;
    
    // create numpad view
    UIView* backgroundView;
    backgroundView = [ [UIView alloc] initWithFrame:buttonFrame];
    [backgroundView setBackgroundColor:[ [UIColor alloc] initWithRed:0/255 green:0/255 blue:0/255 alpha:1] ];
    [self addSubview:backgroundView];
    
    // set initial values for buttons we will create
    int currentTag = 0;
    
    // Build the board and fill the NSMutable array with buttons
    
    for (int i = 0; i < 10; i++) {
        // create the button
        UIButton* button;
        CGFloat buttonSize = x/7;
        CGRect buttonFrame = CGRectMake(.05*x+i*offset, 30, buttonSize,buttonSize);
        if (i > 4) {
            buttonFrame = CGRectMake(.05*x+(i-5)*offset, 35+buttonSize, buttonSize, buttonSize);
        }
        button = [ [UIButton alloc] initWithFrame:buttonFrame];
        button.backgroundColor = [[UIColor alloc] initWithRed:1 green:182/255.0 blue:193/255.0 alpha:1];
        [self addSubview:button];
        
        // give button correct attributes
        [button addTarget:self action:@selector(buttonPressed:)
         forControlEvents:UIControlEventTouchUpInside]; //make own version of this
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        button.showsTouchWhenHighlighted = YES;
        button.tag = currentTag;
        
        currentTag++;
        
        if (i == 0) {
            [button setBackgroundColor:[[UIColor alloc] initWithRed:1 green:105/255.0 blue:180/255.0 alpha:1]];
        }
        
        // insert the button
        [_buttons insertObject:button atIndex:i];
    }
}


// Return the button at an index
-(UIButton*)getCellWithIndex:(int)index {
    return _buttons[index];
}

// Inserts the designated value into the correct
// button on the numPad
- (void)setValueAtIndex:(int)index
              withValue:(int)value {
    UIButton* cell = [self getCellWithIndex:index];
    
    //retrieve the proper number
    NSString* numToFill;
    
    // values of 10 are also designated as blank cells (for deletion purposes)
    if (value == 0 || value==10) {
        numToFill = @"";
    } else {
        numToFill = [NSString stringWithFormat:@"%d", value];
    }
    [cell setTitle:numToFill forState:UIControlStateNormal];
}


@end
