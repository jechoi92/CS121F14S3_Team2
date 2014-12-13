//
//  FractionBlasterTests.m
//  FractionBlasterTests
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EquationGenerator.h"
#import "GameViewController.h"
#import "Constants.h"

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

// Fraction Tests.

- (void)testFractionInitialization
{
  // Standard initialization
  Fraction* fraction = [[Fraction alloc] initWithNumerator:3 andDenominator:4];
  XCTAssert([fraction numerator] == 3);
  XCTAssert([fraction denominator] == 4);
  
  // Initialization without simplification
  Fraction* unsimplifiedFrac = [[Fraction alloc] initWithNumerator:2
                                                    andDenominator:4
                                                       andSimplify:NO];
  XCTAssert([unsimplifiedFrac numerator] == 2);
  XCTAssert([unsimplifiedFrac denominator] == 4);
  
  // Initialization with simplification
  Fraction* simplifiedFrac = [[Fraction alloc] initWithNumerator:2
                                                  andDenominator:4
                                                     andSimplify:YES];
  XCTAssert([simplifiedFrac numerator] == 1);
  XCTAssert([simplifiedFrac denominator] == 2);
}

- (void)testFractionOperations
{
  Fraction* fraction1 = [[Fraction alloc] initWithNumerator:3 andDenominator:4];
  Fraction* fraction2 = [[Fraction alloc] initWithNumerator:2 andDenominator:4 andSimplify:NO];
  
  // Set up all the operations
  Fraction* sum = [fraction1 add:fraction2];
  Fraction* diff = [fraction1 sub:fraction2];
  Fraction* product = [fraction1 multiply:fraction2];
  Fraction* quotient = [fraction1 divide:fraction2];
  Fraction* simplified = [fraction2 simplify:YES];
  
  // Hard-coded expected answers
  Fraction* checkSum = [[Fraction alloc] initWithNumerator:5 andDenominator:4];
  Fraction* checkDiff = [[Fraction alloc] initWithNumerator:1 andDenominator:4];
  Fraction* checkProd = [[Fraction alloc] initWithNumerator:3 andDenominator:8];
  Fraction* checkQuot = [[Fraction alloc] initWithNumerator:3 andDenominator:2];
  Fraction* checkSimp = [[Fraction alloc] initWithNumerator:1 andDenominator:2];

  XCTAssert([sum compare:checkSum] == NSOrderedSame);
  XCTAssert([diff compare:checkDiff] == NSOrderedSame);
  XCTAssert([product compare:checkProd] == NSOrderedSame);
  XCTAssert([quotient compare:checkQuot] == NSOrderedSame);
  XCTAssert([simplified compare:checkSimp] == NSOrderedSame);
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
    
    // Testing the Fraction arithmetic within the Equation class.
    
    XCTAssert([[additionEquation getSolution] number] == [sum number]);
    XCTAssert([[subtractionEquation getSolution] number] == [difference number]);
    XCTAssert([[multiplicationEquation getSolution] number] == [product number]);
    XCTAssert([[divisionEquation getSolution] number] == [quotient number]);
    XCTAssert([[simplificationEquation getSolution] number] == [simplified2 number]);
    
    // Testing the toString method.
    
    XCTAssert([[additionEquation toString] isEqual:@"3/4 + 2/4 = "]);
    XCTAssert([[subtractionEquation toString] isEqual:@"3/4 - 2/4 = "]);
    XCTAssert([[multiplicationEquation toString] isEqual:@"3/4 X 2/4 = "]);
    XCTAssert([[divisionEquation toString] isEqual:@"3/4 ÷ 2/4 = "]);
    XCTAssert([[simplificationEquation toString] isEqual:@"2/4 = "]);
}

// Eqaution Generator Tests.

- (void)testGetInitialFractions
{
    // Testing whether the objects are of Fraction class.
    // Testing if the values are less than 1.0.
    
    NSMutableArray* initialFractions = [_equationGenerator initialFractions];
    XCTAssert([[initialFractions objectAtIndex:0] isKindOfClass:[Fraction class]]);
    XCTAssert([[initialFractions objectAtIndex:0] number] < 1.0);
    XCTAssert([[initialFractions objectAtIndex:1] isKindOfClass:[Fraction class]]);
    XCTAssert([[initialFractions objectAtIndex:1] number] < 1.0);
    XCTAssert([[initialFractions objectAtIndex:2] isKindOfClass:[Fraction class]]);
    XCTAssert([[initialFractions objectAtIndex:2] number] < 1.0);
    XCTAssert([[initialFractions objectAtIndex:3] isKindOfClass:[Fraction class]]);
    XCTAssert([[initialFractions objectAtIndex:3] number] < 1.0);
}

- (void)testGenerateRandomEquation
{
    // Testing whether the object is of Equation class, solution is less than 1.0,
    // and is one of the initial solutions.
    
    XCTAssert([[_equationGenerator generateRandomEquation] isKindOfClass:[Equation class]]);
    XCTAssert([[[_equationGenerator generateRandomEquation] getSolution] number] < 1.0);
    XCTAssert([_equationGenerator containsValue: [[_equationGenerator generateRandomEquation] getSolution]]);
}

- (void)testGenerateAdditionEquation
{
    // Testing if generating an addition equation is working as expected.
    // Testing if the generated fractions of an addition equation
    // have denominators within the limit (for easy mode).
    
    Equation* additionEquation = [_equationGenerator generateAdditionEquation: YES];
    int denominatorLimit = [_equationGenerator getDenominatorLimit];
    XCTAssert([[additionEquation getFraction1] denominator] <= denominatorLimit);
    XCTAssert([[additionEquation getFraction2] denominator] <= denominatorLimit);
    XCTAssert([[additionEquation getSolution] number] == [[[additionEquation getFraction1] add:[additionEquation getFraction2]] number]);
}

- (void)testGenerateSubtractionEquation
{
    // Testing if generating a subtraction equation is working as expected.
    // Testing if the generated fractions of a subtraction equation
    // have denominators within the limit (for easy mode).
    
    Equation* subtractionEquation = [_equationGenerator generateSubtractionEquation: YES];
    int denominatorLimit = [_equationGenerator getDenominatorLimit];
    XCTAssert([[subtractionEquation getFraction1] denominator] <= denominatorLimit);
    XCTAssert([[subtractionEquation getFraction2] denominator] <= denominatorLimit);
    XCTAssert([[subtractionEquation getSolution] number] == [[[subtractionEquation getFraction1] sub:[subtractionEquation getFraction2]] number]);
}

- (void)testGenerateMultiplicationEquation
{
    // Testing if generating a multiplication equation is working as expected.
    
    Equation* multiplicationEquation = [_equationGenerator generateMultiplicationEquation];
    XCTAssert([[multiplicationEquation getSolution] number] == [[[multiplicationEquation getFraction1] multiply:[multiplicationEquation getFraction2]] number]);
}

- (void)testGenerateDivisionEquation
{
    // Testing if generating a division equation is working as expected.
    
    Equation* divisionEquation = [_equationGenerator generateDivisionEquation];
    XCTAssert([[divisionEquation getSolution] number] == [[[divisionEquation getFraction1] divide:[divisionEquation getFraction2]] number]);
}

- (void)testGenerateSimplificationEquation
{
    // Testing if generating a simplification equation is working as expected.
    
    Equation* simplificationEquation = [_equationGenerator generateSimplificationEquation];
    XCTAssert([[simplificationEquation getSolution] number]== [[simplificationEquation getFraction1] number]);
}

- (void)testGenerateRandomFractionWithLimit
{
    // Repeatedly testing if generating a random fraction is within the limit, and tests if
    // the denominator is within the limit.
    // In addition, makes sure the denominator does not take on the value of 11.
    
    Fraction* randomFraction = [[Fraction alloc] initWithInteger:1];
    for (int i = 0; i < 100; i++) {
        randomFraction = [_equationGenerator generateRandomFractionWithLimit:[[Fraction alloc] initWithInteger:1]];
        XCTAssert([randomFraction number] < [[[Fraction alloc] initWithInteger:1] number]);
        XCTAssertFalse([randomFraction denominator] == 11);
        XCTAssert([randomFraction denominator] <= [_equationGenerator getDenominatorLimit]);
    }
}

- (void)testContainsValue
{
    // Testing if a value is contained in the array of initial values.
    
    NSMutableArray* initialFractions = [_equationGenerator initialFractions];
    XCTAssert([_equationGenerator containsValue:[initialFractions objectAtIndex:0]]);
    XCTAssert([_equationGenerator containsValue:[initialFractions objectAtIndex:1]]);
    XCTAssert([_equationGenerator containsValue:[initialFractions objectAtIndex:2]]);
    XCTAssert([_equationGenerator containsValue:[initialFractions objectAtIndex:3]]);
    XCTAssertFalse([_equationGenerator containsValue:[[Fraction alloc] initWithInteger:-1]]);
    XCTAssertFalse([_equationGenerator containsValue:[[Fraction alloc] initWithInteger:1]]);
}

@end

