//
//  OperatorsSelectViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperatorsSelectView.h"
#import "AVFoundation/AVFoundation.h"

@interface OperatorsSelectViewController : UIViewController <ButtonSelected>

@property (nonatomic) AVAudioPlayer *operSelectedSound;
@property (nonatomic) AVAudioPlayer *operBackSound;
@property (nonatomic) AVAudioPlayer *operLaunch;

@end
