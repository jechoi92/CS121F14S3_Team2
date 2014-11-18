//
//  GameEndViewController.h
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameEndView.h"

@interface GameEndViewController : UIViewController

-(id)initWithLevel:(int)level andScore:(int)score andWin:(BOOL)win;

@end
