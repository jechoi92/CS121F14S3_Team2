//
//  GameEndView.h
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLabelsAndButtonsView.h"

@interface GameEndLabelAndButtonsView : UIView

@property (assign, nonatomic) id <GoBack> delegate;

-(id)initWithFrame:(CGRect)frame withLevel:(int)level andScore:(int)score andWin:(BOOL)win;
-(id)initWithFrameVictory:(CGRect)frame;

@end
