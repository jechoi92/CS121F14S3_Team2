//
//  HealthBarView.h
//  SpriteKitSimpleGame
//
//  Created by CS121 on 10/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthBarView : UIView

-(int)getHealthLevel;
-(void)setHealthLevel: (int)healthLevel;

@end
