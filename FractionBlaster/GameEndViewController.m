//
//  GameEndViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameEndViewController.h"

@implementation GameEndViewController
{
    int _level;
    int _score;
    BOOL _win;
    GameEndView* _gameEndView;
}

-(id)initWithLevel:(int)level andScore:(int)score andWin:(BOOL)win
{
    self = [super init];
    _level = level;
    _score = score;
    _win = win;
    return self;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self createGameEndView];
}

-(void)createGameEndView
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrame:gameEndViewFrame andWin:_win];
    [self.view addSubview:_gameEndView];
}




@end
