//
//  Equation.h
//  SpriteKitSimpleGame
//
//  Created by Alejandro Mendoza on 10/17/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"

@interface Equation : NSObject
{
@private
    Fraction *_args1;
    Fraction *_args2;
    char _operator;
    Fraction *_value;
    
}

-(Fraction*)getValue;
-(NSString*)toString;

@end