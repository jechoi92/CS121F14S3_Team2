//
//  ModeSelectView.h
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"

@interface ModeSelectView : UIView

@property (assign, nonatomic) id <ButtonSelected> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
