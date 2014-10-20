//
//  Sidebar.h
//  SpriteKitSimpleGame
//
//  Created by Alejandro Mendoza on 10/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sidebar : UIView

// initializes all of the UIButtons and allocates them in a 2X5 frame
- (void)makeButtonsWithFrame:(CGRect)frame;

// Returns the button in the NSMutable array of all the
// buttons placed on the numPad
- (UIButton*)getCellWithIndex:(int)index;

// Inserts the designated value into the correct
// button given a row and column
- (void)setValueAtIndex:(int)index
              withValue:(int)value;

// Defines viewcontroller as the target class to return
// information about the Sudoku board to.
-(void)setAction:(SEL)action
      withTarget:(id)target;

// returns the currently selected number
-(int)numSelected;

@end
