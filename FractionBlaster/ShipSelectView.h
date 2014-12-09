//
//  ShipSelectView.h
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"

@protocol LaunchSelected
- (void)launchSelected:(id)sender;
@end

@interface ShipSelectView : UIView



@property (assign, nonatomic) int currentShipSelected;
@property (assign, nonatomic) id <LaunchSelected> delegate;

@end
