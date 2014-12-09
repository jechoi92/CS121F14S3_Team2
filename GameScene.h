//
//  GameScene.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Equation.h"

@protocol AsteroidAction
- (void)asteroidReachedBottom;
- (void)incrementScore: (int)value;
- (void)incrementAsteroid: (int)numAsteroid;
- (void)lastAsteroidDestroyed;
- (Equation*)wrongAnswerAttempt: (Fraction*)value;
- (Equation*)initializeTarget;
@end

@interface GameScene : SKScene

@property (nonatomic, weak) id <AsteroidAction> deli;

- (id)initWithSize:(CGSize)size andLevel:(int)level andShipNum:(int)shipNum;
- (void)createAsteroid:(Equation*)equation;
- (void)fireLaser:(Fraction*)value fromButton: (int)tag;
- (void)laser:(SKSpriteNode*)laser didCollideWithAsteroid:(SKSpriteNode*)asteroid;
- (void)createExplosion:(CGPoint)position;
- (void)notifyWithPosition:(CGPoint)position andScore:(int)score andPositive:(BOOL)plus;
- (void)createExplosionFrames;
- (void)startLevelAnimation;
- (void)createPlayerWithShipNum:(int)shipNum;
- (void)createBackground;

@end