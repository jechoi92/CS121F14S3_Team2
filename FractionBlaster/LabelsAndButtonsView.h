//
//  LabelsAndButtonsView.h
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelsAndButtonsView : UIView

-(id)initWithFrame:(CGRect)frame andLevel:(int)level;
-(void)updateScore:(int)score;

@end
