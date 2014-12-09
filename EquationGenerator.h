//
//  EquationGenerator.h
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Equation.h"

@interface EquationGenerator : NSObject

@property (nonatomic) int denominatorLimit;
@property (strong, nonatomic) NSMutableArray* initialFractions;

- (id)initWithOperators: (NSArray*)operators andDenominatorLimit: (int)denominatorLimit andDifficulty: (int)difficulty;
- (Equation*)generateRandomEquation;
- (Fraction*) generateRandomFractionWithLimit: (Fraction*)upper;

// For unit testing purposes
- (Equation*)generateAdditionEquation: (BOOL)easy;
- (Equation*)generateSubtractionEquation: (BOOL)easy;
- (Equation*)generateMultiplicationEquation;
- (Equation*)generateDivisionEquation;
- (Equation*)generateSimplificationEquation;
- (int)getDenominatorLimit;
- (BOOL)containsValue: (Fraction*)value;

@end

