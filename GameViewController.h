//
//  GameViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GameScene.h"
#import "HealthBarView.h"
#import "EquationGenerator.h"
#import "SideBarView.h"
#import "GameView.h"
#import "GameEndViewController.h"

@interface GameViewController : UIViewController <AsteroidAction,
                                                  LaserFrequencyChosen>

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;

- (id)initWithLevel:(int)level andScore: (int)score;
- (void)createHealthBar;
- (void)createScene;
- (void)createSideBar;

@end