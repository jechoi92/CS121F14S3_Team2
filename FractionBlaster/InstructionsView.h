//
//  InstructionsView.h
//  FractionBlaster
//
//  Created by CS121 on 12/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface InstructionsView : UIView

@property (assign, nonatomic) id <GoBack> delegate;
@property (assign, nonatomic) id <ButtonSelected> buttonDelegate;

@end
