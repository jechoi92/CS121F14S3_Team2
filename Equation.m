//
//  Equation.m
//  SpriteKitSimpleGame
//
//  Created by Alejandro Mendoza on 10/17/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "Equation.h"

@implementation Equation


-(id)initWithFraction1: (Fraction*)args1 andFraction2: (Fraction*)args2 andOperator: (char)operator
{
    _args1 = args1;
    _args2 = args2;
    _operator = operator;
    if (operator == '+') {
        _value = [[Fraction alloc] initWithFraction: [args1 add:args2]];
    }
    else if (operator == '-') {
        _value = [[Fraction alloc] initWithFraction: [args1 sub:args2]];
    }
    else if (operator == '*') {
        _value = [[Fraction alloc] initWithFraction: [args1 multiply:args2]];
    }
    else {
        _value = [[Fraction alloc] initWithFraction: [args1 divide:args2]];
    }
    return self;
}

-(Fraction*)getValue
{
    return _value;
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"%@ %c %@ = ", [_args1 toString], _operator, [_args2 toString]];
}

@end
