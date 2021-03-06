//
//  LeaderboardView.h
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface LeaderboardView : UIView

@property (assign, nonatomic) id <GoBack> delegate;

- (void)setLabelAtIndex:(int)i withString:(NSString*)score;

@end
