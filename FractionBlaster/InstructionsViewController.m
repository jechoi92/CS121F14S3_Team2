//
//  InstructionsViewController.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/17/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "InstructionsViewController.h"

@implementation InstructionsViewController
{
    InstructionsView *_instructionsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set up the view and delegate
    _instructionsView = [[InstructionsView alloc] initWithFrame:self.view.frame];
    [_instructionsView setDelegate:self];
    [self.view addSubview:_instructionsView];
}

- (void)backToMainMenu
{
    [self playButtonSound];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playButtonSound {
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.instrBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.instrBackSound prepareToPlay];
    [self.instrBackSound play];
}



@end
