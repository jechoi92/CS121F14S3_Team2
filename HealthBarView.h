//
//  HealthBarView.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HealthBarView : UIView

- (int)getHealthLevel;
- (void)setHealthLevel: (int)healthLevel;

@end