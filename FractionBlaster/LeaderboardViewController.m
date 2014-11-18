//
//  LeaderboardViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LeaderboardViewController.h"

CGFloat INSET_RATIO;


@implementation LeaderboardViewController {
    LeaderboardView* _leaderboardView;

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _leaderboardView = [[LeaderboardView alloc] initWithFrame:self.view.frame];
    [_leaderboardView setDelegate:self];
    [self.view addSubview:_leaderboardView];
    [self setLabels];
}

-(void)setLabels
{
    NSArray* scores = [self loadHighScores];
    for (int i = 0; i < 5; i++) {
        [_leaderboardView setLabelAtIndex:i withString:[scores objectAtIndex:i]];
    }
}

-(NSArray*) loadHighScores
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    if (content == NULL) {
        content = @"0000000   \n0000000   \n0000000   \n0000000   \n0000000   \n";
    }
    
    NSMutableArray* scores = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0; i < 5; i++) {
        
        NSString* score = [content substringWithRange:NSMakeRange(11 * i, 10)];
        [scores addObject:score];
    }
    return [[NSArray alloc] initWithArray:scores];
}

-(void)backToMainMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToGameWithNextLevel:(BOOL)won
{
    //dummy implementation
}

@end
