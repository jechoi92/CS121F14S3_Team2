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
    LeaderboardView *_leaderboardView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the view and delegate
    _leaderboardView = [[LeaderboardView alloc] initWithFrame:self.view.frame];
    [_leaderboardView setDelegate:self];
    [self.view addSubview:_leaderboardView];
    
    // Set the labels in the view
    [self setLabels];
}

// Read in highscores and set labels accordingly
- (void)setLabels
{
    NSArray *scores = [self loadHighScores];
    for (int i = 0; i < 5; i++) {
        [_leaderboardView setLabelAtIndex:i withString:[scores objectAtIndex:i]];
    }
}

// Read highscores from text file, return array of 5 scores
- (NSArray*)loadHighScores
{
    // Read in the scores
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    // If there is no such text file, then set it as below by default
    if (content == NULL) {
        content = @"0000000   \n0000000   \n0000000   \n0000000   \n0000000   \n";
    }
    NSMutableArray *scores = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Parse the entire string and store the separate strings into an array to return
    for (int i = 0; i < 5; i++) {
        NSString *score = [content substringWithRange:NSMakeRange(11 * i, 10)];
        [scores addObject:score];
    }
    return [[NSArray alloc] initWithArray:scores];
}

- (void)backToMainMenu
{
    [self playButtonSound];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playButtonSound {
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.leaderBrdBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.leaderBrdBackSound prepareToPlay];
    [self.leaderBrdBackSound play];
}

@end
