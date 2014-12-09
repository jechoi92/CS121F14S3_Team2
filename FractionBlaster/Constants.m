//
//  Constants.m
//  FractionBlaster
//
//  Created by jarthurcs on 12/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

const uint32_t LASER_CATEGORY        =  0x1 << 0;
const uint32_t ASTEROID_CATEGORY     =  0x1 << 1;
const uint32_t SHIELD_CATEGORY       =  0x1 << 2;
const uint32_t BOSS_CATEGORY    =  0x1 << 3;
const uint32_t DEAD_BOSS_CATEGORY  =  0x1 << 4;

int SLOW_SPEED = 35;
int MEDIUM_SPEED = 30;
int MAX_SPEED = 25;
int HELL_MODE = 15;

int MINIMUM_ASTEROID_DURATION = 15;
int ALLOWED_WRONG_ANSWERS = 2;
int SHIELDGEN_HP = 3;
int WARPGEN_HP = 5;
int ASTEROIDGEN_HP = 3;
CGFloat LASER_VELOCITY = 800.0;