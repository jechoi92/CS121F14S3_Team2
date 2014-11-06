//
//  Fraction.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>
#import "Fraction.h"

@implementation Fraction

// Initializers
-(instancetype)init
{
    NSLog(@"initialized to unity");
    return [self initWithInteger: 1];
}

-(instancetype)initWithNumerator: (int)num andDenominator: (int)den
{
    if ((self = [super init]) != nil) {
        if (den == 0) {
            NSLog(@"denominator is zero");
            return nil;
        }
        [self setNumerator: num];
        [self setDenominator: den];
        [self setWithSign: YES];
        [self setAutoSimplify: YES];
        [self simplify: YES];
    }
    return self;
}

-(instancetype)initWithNumerator: (int)num andDenominator: (int)den andSimplify:(BOOL)simplify
{
    if ((self = [super init]) != nil) {
        if (den == 0) {
            NSLog(@"denominator is zero");
            return nil;
        }
        [self setNumerator: num];
        [self setDenominator: den];
        [self setWithSign: YES];
        [self setAutoSimplify: simplify];
        [self simplify: simplify];
    }
    return self;
}

-(instancetype)initWithInteger:(int)inum
{
    return [self initWithNumerator: inum andDenominator: 1];
}

-(instancetype)initWithDouble: (double)fnum precision: (int)prec
{
    if ( prec > 9 ) prec = 9;
    double p = pow(10.0, (double)prec);
    int nd = (int)(fnum * p);
    return [self initWithNumerator: nd andDenominator: (int)p ];
}

-(instancetype)initWithFraction: (Fraction *)frac
{
    return [self initWithNumerator: [frac numerator] andDenominator: [frac denominator]];
}

// Compare
-(NSComparisonResult)compare: (Fraction *)frac
{
    if ( [self number] > [frac number] ) return NSOrderedDescending;
    if ( [self number] < [frac number] ) return NSOrderedAscending;
    return NSOrderedSame;
}

// String representation of the Fraction
-(NSString *)description
{
    [self simplify: [self autoSimplify]];
    return [NSString stringWithFormat: @"%d/%d",
            [self numerator], [self denominator]];
}

// "Simplify" the fraction ...
-(id)simplify: (BOOL)act
{
    if ( act ) {
        int common = gcd([self numerator], [self denominator]);
        [self setNumerator: [self numerator]/common];
        [self setDenominator: [self denominator]/common];
    }
    return self;
}

// Mathematical operators
-(id)multiply: (Fraction *)frac
{
    int newnum = [self numerator] * [frac numerator];
    int newden = [self denominator] * [frac denominator];
    return [[Fraction alloc] initWithNumerator: newnum
                                andDenominator: newden];
}

-(id)divide: (Fraction *)frac
{
    return [self multiply: [frac reciprocal]];
}

-(id)add: (Fraction *)frac
{
    int common = lcm([self denominator], [frac denominator]);
    int resnum = common / [self denominator] * [self numerator] +
    common / [frac denominator] * [frac numerator];
    return [[Fraction alloc] initWithNumerator: resnum andDenominator: common];
}

-(id)sub: (Fraction *)frac
{
    return [self add: [frac neg]];
}

-(id)mod: (Fraction *)frac
{
    return [[self divide: frac]
            sub: [[Fraction alloc] initWithInteger: [[self divide: frac] integer]]];
}

// Helper functions for mathematical operations
int gcd(int m, int n) {
    int t, r;
    m = abs(m);
    n = abs(n);
    
    if (m < n) {
        t = m;
        m = n;
        n = t;
    }
    
    r = m % n;
    
    if (r == 0) {
        return n;
    } else {
        return gcd(n, r);
    }
}

int lcm(int a, int b)
{
    return a / gcd(a,b) * b;
}


// Unary operators
-(id)neg
{
    return [[Fraction alloc] initWithNumerator: -1 * [self numerator]
                                andDenominator: [self denominator]];
}

-(id)abs
{
    return [[Fraction alloc] initWithNumerator: abs([self numerator])
                                andDenominator: [self denominator]];
}

-(id)reciprocal
{
    return [[Fraction alloc] initWithNumerator:[self denominator]
                                andDenominator: [self numerator]];
}

// Get the sign
-(int)sign
{
    return ([self numerator] < 0) ? -1 : 1;
}

// Test if negative
-(BOOL)isNegative
{
    return [self numerator] < 0;
}

// Fraction as real floating point
-(double)number
{
    return (double)[self numerator] / (double)[self denominator];
}

// Fraction as (truncated) integer
-(int)integer
{
    return [self numerator] / [self denominator];
}

// Setters
-(void)setNumerator: (int)num
{
    numerator = num;
}

-(void)setDenominator: (int)num
{
    if ( num < 0 ) numerator = -numerator;
    denominator = abs(num);
}

-(void)setAutoSimplify: (BOOL)v
{
    autoSimplify = v;
    [self simplify: v];
}
-(void)setWithSign: (BOOL)v
{
    withSign = v;
}

// Getters
-(BOOL)autoSimplify
{
    return autoSimplify;
}

-(BOOL)withSign
{
    return withSign;
}

-(int)numerator
{
    return numerator;
}

-(int)denominator
{
    return denominator;
}



@end
