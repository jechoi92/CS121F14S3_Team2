//
//  GameScene.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Equation.h"

@protocol AsteroidReachedBottom <SKSceneDelegate>
- (void)asteroidReachedBottom;
@end

@interface GameScene : SKScene

@property (assign, nonatomic) id <AsteroidReachedBottom> delegate;

- (void)createAsteroid: (Equation*)equation;
- (void)fireLaser: (Fraction*)value;
- (void)gameOver;

@end