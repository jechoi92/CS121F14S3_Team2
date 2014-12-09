//
//  LeaderboardViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaderboardView.h"
#import <AVFoundation/AVFoundation.h>

@interface LeaderboardViewController : UIViewController <GoBack>

@property (nonatomic) AVAudioPlayer *leaderBrdBackSound;

@end
