//
//  ShipSelectViewController.h
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipSelectView.h"
#import "AVFoundation/AVFoundation.h" 

@interface ShipSelectViewController : UIViewController <ButtonSelected>

@property (nonatomic) AVAudioPlayer *shipSelectSound;
@property (nonatomic) AVAudioPlayer *shipBackSound;
@property (nonatomic) AVAudioPlayer *shipLaunch;

- (id)initWithLevel:(int)level andOperators:(NSArray*)operators;

@end
