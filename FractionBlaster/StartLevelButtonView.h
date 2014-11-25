//
//  StartLevelButtonView.h
//  FractionBlaster
//
//  Created by Laptop16 on 11/9/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartLevel
- (void)startLevel;
@end

@interface StartLevelButtonView : UIView

@property (assign, nonatomic) id <StartLevel> delegate;

@end
