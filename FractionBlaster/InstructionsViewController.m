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
    [_instructionsView setButtonDelegate:(id<ButtonSelected>)self];
    [self.view addSubview:_instructionsView];
    
    // Set up back button AudioPlayer
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.instrBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.instrBackSound prepareToPlay];
    
    // Set up normal button AudioPlayer
    NSURL *buttonSound = [[NSBundle mainBundle] URLForResource:@"button-3" withExtension:@"wav"];
    self.instrButtonSound = [[AVAudioPlayer alloc] initWithContentsOfURL:buttonSound error:&error];
    [self.instrButtonSound prepareToPlay];
}

// Back button pressed
- (void)backToMainMenu
{
    [self.instrBackSound play];
    [self.navigationController popViewControllerAnimated:YES];
}

// Play sound for previous/next buttons
- (void)buttonSelected:(id)sender
{
    [self.instrButtonSound play];
}

@end
