//
//  BossScene.h
//  FractionBlaster
//
//  Created by jarthurcs on 12/1/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Equation.h"
#import "GameScene.h"

@interface BossScene : GameScene <SKPhysicsContactDelegate>

@property (nonatomic) SKSpriteNode* player;
@property (nonatomic, weak) id <AsteroidAction> deli;

- (id)initWithSize:(CGSize)size andLevel:(int)level andDelegate:(id<AsteroidAction>)deli;
- (void)createAsteroid: (Equation*)equation;
//- (void)fireLaser: (Fraction*)value fromButton: (int)tag;

@end
