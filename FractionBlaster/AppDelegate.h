//
//  AppDelegate.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;

@end

