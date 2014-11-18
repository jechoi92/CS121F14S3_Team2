//
//  GameScene.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Equation.h"

@protocol AsteroidAction <SKSceneDelegate>
- (void)asteroidReachedBottom;
- (void)incrementScore: (int)value;
- (void)lastAsteroidDestroyed;
@end

@interface GameScene : SKScene

@property (assign, nonatomic) id <AsteroidAction> delegate;


-(id)initWithSize:(CGSize)size andLevel:(int)level;
- (void)createAsteroid: (Equation*)equation;
- (void)fireLaser: (Fraction*)value fromButton: (int)tag;

@end