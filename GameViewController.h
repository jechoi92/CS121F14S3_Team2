//
//  GameViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "HealthBarView.h"
#import "EquationGenerator.h"
#import "SideBarView.h"
#import "GameOverScene.h"

@interface GameViewController : UIViewController <AsteroidReachedBottom,
                                                  LaserFrequencyChosen>

- (void)createHealthBar;
- (void)createScene;
- (void)createSideBar;

@end