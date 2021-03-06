//
//  Equation.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "Equation.h"

@implementation Equation
{
    Fraction *_args1;
    Fraction *_args2;
    Fraction *_value;
    char _operator;
}

// Initializes an equation with two fractions and one operator in between.
// The value of the equation is computed and stored as well.
- (id)initWithFraction1: (Fraction*)args1 andFraction2: (Fraction*)args2 andOperator: (char)operator
{
    self = [super init];
    _args1 = args1;
    _args2 = args2;
    _value = args1;
    _operator = operator;
    
    // Determine the solution of the equation depending on the arguments and the operator
    switch (operator) {
        case '+':
            _value = [[Fraction alloc] initWithFraction: [args1 add:args2]];
            break;
        case '-':
            _value = [[Fraction alloc] initWithFraction: [args1 sub:args2]];
            break;
        case '*':
            _value = [[Fraction alloc] initWithFraction: [args1 multiply:args2]];
            break;
        case '/':
            _value = [[Fraction alloc] initWithFraction: [args1 divide:args2]];
            break;
        default:
            _value = [[Fraction alloc] initWithFraction: args1];
            break;
    }
    
    return self;
}

- (Fraction*)getSolution
{
    return _value;
}

// Returns a string representation of the equation.
- (NSString*)toString
{
    // $ means simplify. If in case simplify, then it is just the first fraction and an equality sign.
    if (_operator == '$') {
        return [NSString stringWithFormat:@"%@ = ", [_args1 description]];
    }
    else if (_operator == '/') {
        return [NSString stringWithFormat:@"%@ ÷ %@ = ", [_args1 description], [_args2 description]];
    }
    
    else if (_operator == '*') {
        return [NSString stringWithFormat:@"%@ X %@ = ", [_args1 description], [_args2 description]];
    }
    
    // Otherwise, it is the two fractions and the operator in between, and an equality sign at the end.
    return [NSString stringWithFormat:@"%@ %c %@ = ", [_args1 description], _operator, [_args2 description]];
}


// For unit testing purposes

- (Fraction*)getFraction1
{
    return _args1;
}

- (Fraction*)getFraction2
{
    return _args2;
}

- (char)getOperator
{
    return _operator;
}

@end

