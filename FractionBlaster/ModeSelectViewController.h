//
//  ModeSelectViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelSelectViewController.h"
#import "OperatorsSelectViewController.h"
#import "ModeSelectView.h"

@interface ModeSelectViewController : UIViewController <ButtonSelected>

@property (nonatomic) AVAudioPlayer *modeProgressSound;
@property (nonatomic) AVAudioPlayer *modeBackSound;

@end
