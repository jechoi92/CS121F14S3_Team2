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
    [_instructionsView setButtonDelegate:self];
    [self.view addSubview:_instructionsView];
}

- (void)backToMainMenu
{
    [self playButtonSound];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonSelected:(id)sender
{
    // Figure out the button that was selected
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    
    // Play sound
    [self playButtonSound];
}

- (void)playButtonSound {
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.instrBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.instrBackSound prepareToPlay];
    [self.instrBackSound play];
}

- (void)normalButtonSound
{
    NSError *error;
    NSURL *buttonSound = [[NSBundle mainBundle] URLForResource:@"button-3" withExtension:@"wav"];
    self.instrButtonSound = [[AVAudioPlayer alloc] initWithContentsOfURL:buttonSound error:&error];
    [self.instrButtonSound prepareToPlay];
    [self.instrButtonSound play];
}

@end
