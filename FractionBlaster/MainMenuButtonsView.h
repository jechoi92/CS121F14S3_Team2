//
//  MainMenuButtonsView.h
//  FractionBlaster
//
//  Created by Laptop16 on 11/14/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonSelected
- (void)buttonSelected:(id)sender;
@end

@interface MainMenuButtonsView : UIView

@property (assign, nonatomic) id <ButtonSelected> delegate;

-(id)initWithFrame:(CGRect)frame;

@end
