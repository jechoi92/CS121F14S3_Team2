//
//  SideBarView.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fraction.h"

@protocol LaserFrequencyChosen
- (void)laserFrequencyChosen:(NSNumber *)buttonTag;
@end

@interface SideBarView : UIView

@property (assign, nonatomic) id <LaserFrequencyChosen> delegate;


// overwrites the method to initialize the creation of the side bar
- (id)initWithFrame:(CGRect)frame;

// initializes all of the UIButtons and allocates them in a 1x4 frame
- (void)makeButtons;

// Returns the button in the NSMutable array of all the
// buttons placed on the side bar
- (UIButton*)getCellWithIndex:(int)index;

// Inserts the designated value into the correct
// button given the index of the array of intital fractions
- (void)setValueAtIndex:(int)index
              withValue:(Fraction*)value;

@end
