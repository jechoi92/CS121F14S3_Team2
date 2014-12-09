//
//  ShipSelectView.h
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"


@interface ShipSelectView : UIView



@property (assign, nonatomic) int currentShipSelected;
@property (assign, nonatomic) id <ButtonSelected> delegate;

@end
