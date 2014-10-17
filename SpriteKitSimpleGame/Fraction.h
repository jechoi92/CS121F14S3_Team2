
#import <Foundation/Foundation.h>

@interface Fraction : NSObject
{
@private
  int numerator;
  int denominator;
  BOOL autoSimplify;
  BOOL withSign;
}
-(instancetype)initWithNumerator: (int)num andDenominator: (int)den;
-(instancetype)initWithDouble: (double)fnum precision: (int)prec;
-(instancetype)initWithInteger: (int)inum;
-(instancetype)initWithFraction: (Fraction *)frac;
-(NSComparisonResult)compare: (Fraction *)frac;
-(id)simplify: (BOOL)act;
-(void)setAutoSimplify: (BOOL)v;
-(void)setWithSign: (BOOL)v;
-(BOOL)autoSimplify;
-(BOOL)withSign;
-(NSString *)description;
// ops
-(id)multiply: (Fraction *)frac;
-(id)divide: (Fraction *)frac;
-(id)add: (Fraction *)frac;
-(id)sub: (Fraction *)frac;
-(id)abs;
-(id)neg;
-(id)mod: (Fraction *)frac;
-(int)sign;
-(BOOL)isNegative;
-(id)reciprocal;
// getter
-(int)numerator;
-(int)denominator;
//setter
-(void)setNumerator: (int)num;
-(void)setDenominator: (int)num;
// defraction
-(double)number;
-(int)integer;
@end