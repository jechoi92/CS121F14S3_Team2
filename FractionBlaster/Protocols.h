//
//  Protocols.h
//  FractionBlaster
//
//  Created by Laptop16 on 12/9/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#ifndef FractionBlaster_protocols_h
#define FractionBlaster_protocols_h

#import <Foundation/Foundation.h>
#import "Equation.h"

@protocol ButtonSelected
- (void)buttonSelected:(id)sender;
@end

@protocol GoBack
- (void)backToMainMenu;
@end

@protocol DismissTip
-(void)dismissTip;
@end

@protocol GoBackGame
- (void)backToMainMenu;
- (void)backToGameWithNextLevel:(BOOL)won;
@end

@protocol LaserFrequencyChosen
- (void)laserFrequencyChosen:(NSNumber *)buttonTag;
@end

@protocol AsteroidAction
- (void)asteroidReachedBottom;
- (void)incrementScore: (int)value;
- (void)incrementAsteroid: (int)numAsteroid;
- (void)lastAsteroidDestroyed;
- (Equation*)wrongAnswerAttempt: (Fraction*)value;
- (Equation*)initializeTarget;
@end

#endif