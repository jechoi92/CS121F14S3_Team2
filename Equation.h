//
//  Equation.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@interface Equation : NSObject

-(id)initWithFraction1: (Fraction*)args1 andFraction2: (Fraction*)args2 andOperator: (char)operator;
-(Fraction*)getValue;
-(NSString*)toString;

@end
