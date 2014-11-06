//
//  FractionBlasterTests.m
//  FractionBlasterTests
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Equation.h"
#import "EquationGenerator.h"

@interface FractionBlasterTests : XCTestCase
{
    EquationGenerator* _equationGenerator;
}
@end

@implementation FractionBlasterTests

- (void)setUp
{
    [super setUp];
    
    NSMutableArray* operators = [[NSMutableArray alloc] initWithCapacity:1];
    [operators addObject:@"$"];
    [operators addObject:@"+"];
    [operators addObject:@"-"];
    [operators addObject:@"*"];
    [operators addObject:@"/"];
    
    _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:0];
}

- (void)tearDown
{
    [super tearDown];
}


// Equation Tests.

- (void)testEquations
{
    Fraction* fraction1 = [[Fraction alloc] initWithNumerator:3 andDenominator:4];
    Fraction* fraction2 = [[Fraction alloc] initWithNumerator:2 andDenominator:4 andSimplify:NO];
    
    Fraction* sum = [[Fraction alloc] initWithNumerator:5 andDenominator:4];
    Fraction* difference = [[Fraction alloc] initWithNumerator:1 andDenominator:4];
    Fraction* product = [[Fraction alloc] initWithNumerator:3 andDenominator:8];
    Fraction* quotient = [[Fraction alloc] initWithNumerator:3 andDenominator:2];
    Fraction* simplified2 = [[Fraction alloc] initWithNumerator:1 andDenominator:2];
    
    Equation* additionEquation = [[Equation alloc] initWithFraction1:fraction1 andFraction2:fraction2 andOperator:'+'];
    Equation* subtractionEquation = [[Equation alloc] initWithFraction1:fraction1 andFraction2:fraction2 andOperator:'-'];
    Equation* multiplicationEquation = [[Equation alloc] initWithFraction1:fraction1 andFraction2:fraction2 andOperator:'*'];
    Equation* divisionEquation = [[Equation alloc] initWithFraction1:fraction1 andFraction2:fraction2 andOperator:'/'];
    Equation* simplificationEquation = [[Equation alloc] initWithFraction1:fraction2 andFraction2:fraction2 andOperator:'$'];
    
    XCTAssert([[additionEquation getValue] number] == [sum number]);
    XCTAssert([[subtractionEquation getValue] number] == [difference number]);
    XCTAssert([[multiplicationEquation getValue] number] == [product number]);
    XCTAssert([[divisionEquation getValue] number] == [quotient number]);
    XCTAssert([[simplificationEquation getValue] number] == [simplified2 number]);
    XCTAssert([[additionEquation toString] isEqual:@"3/4 + 2/4 = "]);
    XCTAssert([[subtractionEquation toString] isEqual:@"3/4 - 2/4 = "]);
    XCTAssert([[multiplicationEquation toString] isEqual:@"3/4 X 2/4 = "]);
    XCTAssert([[divisionEquation toString] isEqual:@"3/4 ÷ 2/4 = "]);
    XCTAssert([[simplificationEquation toString] isEqual:@"2/4 = "]);
}

// Eqaution Generator Tests.

- (void)testGetInitialFractions
{
    
}

- (void)testGenerateRandomEquation
{
    
}

- (void)testGenerateAdditionEquation
{
    
}

- (void)testGenerateSubtractionEquation
{
    
}

- (void)testGenerateMultiplicationEquation
{
    
}

- (void)testGenerateDivisionEquation
{
    
}

- (void)testGenerateSimplificationEquation
{
    
}

- (void)testGenerateRandomFractionWithLimit
{
    
}

- (void)testContainsValue
{
    
}



@end

