//
//  LevelButtonView.h
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface LevelSelectView : UIView

@property (assign, nonatomic) int currentLevelSelected;
@property (assign, nonatomic) id <ButtonSelected> delegate;

- (id)initWithFrame:(CGRect)frame andUnlockedLevel:(int)level;


@end
