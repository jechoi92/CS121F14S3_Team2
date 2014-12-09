//
//  OperatorsSelectViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperatorsSelectView.h"
#import "ShipSelectViewController.h"

@interface OperatorsSelectViewController : UIViewController <ButtonSelected>

@property (nonatomic) AVAudioPlayer *buttonPressed;
@property (nonatomic) AVAudioPlayer *backButton;

@end
