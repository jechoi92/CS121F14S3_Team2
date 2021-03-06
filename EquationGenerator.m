//
//  EquationGenerator.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "EquationGenerator.h"
#import "Constants.h"

@implementation EquationGenerator
{
    NSArray* _operators;               // An array of all the current operators being used.
    int _difficulty;                   // An int storing the level difficulty.
                                       // (0 == easy, 1 == medium, 2 == hard)
}

// Initializes the generator with valid operators and the upper bound on the denominator
- (id)initWithOperators:(NSArray*) operators andDenominatorLimit:(int)denominatorLimit andDifficulty:(int)difficulty
{
    self = [super init];
    _denominatorLimit = denominatorLimit;
    _difficulty = difficulty;
    _initialFractions = [[NSMutableArray alloc] initWithCapacity:TOTAL_INITIAL_FRACTIONS];
    for (int i = 0; i < TOTAL_INITIAL_FRACTIONS; i++) {

        // Generates random fractions for the initial solutions
        Fraction* currentFraction = [self generateRandomFractionWithLimit:[[Fraction alloc] initWithInteger:1]];
        
        // Makes sure no duplicates are created
        while ([self containsValue: currentFraction]) {
            currentFraction = [self generateRandomFractionWithLimit:[[Fraction alloc] initWithInteger:1]];
        }
        
        [_initialFractions addObject:currentFraction];
    }
    _operators = operators;
    
    // Sorts the fractions in ascending order, for convenience
    _initialFractions = [NSMutableArray arrayWithArray:[_initialFractions sortedArrayUsingSelector:@selector(compare:)]];
    
    return self;
}

// Generates a random equation given the current array of solutions and operators
- (Equation*) generateRandomEquation
{
    // Randomly determines the difficulty of the Equation
    int randDifficulty = arc4random_uniform(4);
    BOOL easyEquation = YES;
    if (randDifficulty < _difficulty) {
        easyEquation = NO;
    }
    
    // An operator is randomly chosen from the array of operators
    int randOperator = arc4random_uniform((int) [_operators count] );
    char currentOperator = [[_operators objectAtIndex:randOperator] characterAtIndex:0];
    
    // Depending on the operator, equations are generated accordingly
    switch (currentOperator) {
        case '+':
            return [self generateAdditionEquation:easyEquation];
        case '-':
            return [self generateSubtractionEquation:easyEquation];
        case '*':
            return [self generateMultiplicationEquation];
        case '/':
            return [self generateDivisionEquation];
        default:
            return [self generateSimplificationEquation];
    }
}

// Generates an addition equation
- (Equation*) generateAdditionEquation: (BOOL)easy
{
    Fraction* solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
    Fraction* arg1 = [self generateRandomFractionWithLimit:solution];
    Fraction* arg2 = [[Fraction alloc] initWithFraction:[solution sub:arg1]];
    
    // If the equation is easy, we limit the denominators of our fractions to be below the denominator limit
    if (easy) {
        while ([arg1 denominator] > _denominatorLimit || [arg2 denominator] > _denominatorLimit) {
            solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
            arg1 = [self generateRandomFractionWithLimit:solution];
            arg2 = [[Fraction alloc] initWithFraction:[solution sub:arg1]];
        }
    }
    
    Equation* equation = [[Equation alloc] initWithFraction1:arg1 andFraction2:arg2 andOperator:'+'];
    return equation;
}

// Generates a subtraction equation
- (Equation*) generateSubtractionEquation: (BOOL)easy
{
    Fraction* solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
    Fraction* arg2 = [self generateRandomFractionWithLimit:solution];
    Fraction* arg1 = [[Fraction alloc] initWithFraction:[solution add:arg2]];
    
    // If the equation is easy, we limit the denominators of our fractions to be below the denominator limit
    if (easy) {
        while ([arg1 denominator] > _denominatorLimit || [arg2 denominator] > _denominatorLimit) {
            solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
            arg2 = [self generateRandomFractionWithLimit:solution];
            arg1 = [[Fraction alloc] initWithFraction:[solution add:arg2]];
        }
    }
    
    Equation* equation = [[Equation alloc] initWithFraction1:arg1 andFraction2:arg2 andOperator:'-'];
    return equation;
}

// Generates a multiplication equation
- (Equation*) generateMultiplicationEquation
{
    Fraction* solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
    Fraction* arg1 = [self generateRandomFractionWithLimit:solution];
    Fraction* arg2 = [[Fraction alloc] initWithFraction:[solution divide:arg1]];
    Equation* equation = [[Equation alloc] initWithFraction1:arg1 andFraction2:arg2 andOperator:'*'];
    return equation;
}

// Generates a division equation
- (Equation*) generateDivisionEquation
{
    Fraction* solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
    Fraction* arg2 = [self generateRandomFractionWithLimit:solution];
    Fraction* arg1 = [[Fraction alloc] initWithFraction:[solution multiply:arg2]];
    Equation* equation = [[Equation alloc] initWithFraction1:arg1 andFraction2:arg2 andOperator:'/'];
    return equation;
}

// Generates a simplification equation
- (Equation*) generateSimplificationEquation
{
    // Select a random solution, then multiply it with a scalar greater than 1.
    Fraction* solution = [_initialFractions objectAtIndex:arc4random_uniform((int) [_initialFractions count])];
    int randScalar = arc4random_uniform(SCALAR_LIMIT - 1) + 2;
    Fraction* value = [[Fraction alloc] initWithNumerator:[solution numerator] * randScalar
                                           andDenominator:[solution denominator] * randScalar andSimplify:NO];
    Equation* equation = [[Equation alloc] initWithFraction1:value andFraction2:NULL andOperator:'$'];
    return equation;
}

// Generates a random fraction within a certain limit
- (Fraction*) generateRandomFractionWithLimit: (Fraction*)upper
{
    Fraction* value = [[Fraction alloc] initWithFraction:upper];
    int denominator = 0;
    // Makes sure the generated fraction stays strictly below the limit.
    // Exclude denominator 11 (it is too unique).
    while (([value number] >= [upper number]) || (denominator == 11)) {
        denominator = arc4random_uniform(_denominatorLimit) + 1;
        int numerator = arc4random_uniform([upper number] * denominator - 1) + 1;
        value = [[Fraction alloc] initWithNumerator:numerator andDenominator:denominator];
    }
    return value;
}

// Checks if the fraction exists within the solution set
- (BOOL)containsValue: (Fraction*)value
{
    for (int i = 0; i < [_initialFractions count]; i++) {
        if ([[_initialFractions objectAtIndex:i] number] == [value number]) {
            return YES;
        }
    }
    return NO;
}

// For unit testing purposes

- (int)getDenominatorLimit
{
    return _denominatorLimit;
}

@end
