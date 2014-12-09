//
//  TipView.h
//  FractionBlaster
//
//  Created by Laptop16 on 12/6/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissTip
-(void)dismissTip;
@end

@interface TipView : UIView

@property (assign, nonatomic) id <DismissTip> delegate;

-(id)initWithFrame:(CGRect)frame andLevel:(int)level;

@end
