//
//  LevelSelectViewController.h
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelSelectView.h"
#import "AVFoundation/AVFoundation.h"

@interface LevelSelectViewController : UIViewController <ButtonSelected>

@property (nonatomic) AVAudioPlayer *levelButtonSound;
@property (nonatomic) AVAudioPlayer *levelBackSound;
@property (nonatomic) AVAudioPlayer *levelLaunch;

@end
