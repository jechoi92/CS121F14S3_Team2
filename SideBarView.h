//
//  SideBarView.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fraction.h"
#import "MainMenuView.h"

@protocol LaserFrequencyChosen
- (void)laserFrequencyChosen:(NSNumber *)buttonTag;
@end

@interface SideBarView : UIView

@property (assign, nonatomic) id <LaserFrequencyChosen> delegate;

- (id)initWithFrame:(CGRect)frame;
- (UIButton*)getCellWithIndex:(int)index;
- (void)setValueAtIndex:(int)index withValue:(Fraction*)value;

@end
