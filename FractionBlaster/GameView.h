//
//  LabelsAndButtonsView.h
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface GameView : UIView

@property (assign, nonatomic) id <GoBackGame> delegate;

- (id)initWithFrame:(CGRect)frame andAsteroidCount:(int)numAsteroids andScore:(int)score;
- (void)updateScore:(int)score;
- (void)updateAsteroidCount:(int)numAsteroid;


@end
