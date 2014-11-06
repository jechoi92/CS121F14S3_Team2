//
//  GameScene.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Equation.h"

@interface GameScene : SKScene

- (void)createAsteroid: (Equation*)equation;
- (void)fireLaser: (Fraction*)value;
-(void)setAction:(SEL)action
      withTarget:(id)target;
-(void)gameOver;

@end