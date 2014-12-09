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
#import <QuartzCore/QuartzCore.h>
#import "GameScene.h"
#import "BossScene.h"
#import "HealthBarView.h"
#import "EquationGenerator.h"
#import "SideBarView.h"
#import "GameLabelsAndButtonsView.h"
#import "GameEndLabelAndButtonsView.h"

@interface GameViewController : UIViewController <AsteroidAction,
                                                  LaserFrequencyChosen,
                                                  GoBack>

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;

- (id)initWithLevel:(int)level andScore: (int)score;

@end