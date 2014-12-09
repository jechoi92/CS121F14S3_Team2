//
//  ModeSelectViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ModeSelectViewController.h"

// Enum object for button tags
typedef enum {
    LevelSelectTag,
    OperatorSelectTag,
    BackTag
} ButtonTags;

@implementation ModeSelectViewController
{
    ModeSelectView *_modeSelectView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the view and delegate
    _modeSelectView = [[ModeSelectView alloc] initWithFrame:self.view.frame];
    [_modeSelectView setDelegate:self];
    [self.view addSubview:_modeSelectView];
}

// Function to perform action when button was selected
- (void)buttonSelected:(id)sender
{
    // Figure out which button was selected
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag) {
            
        // Show level selection screen
        case LevelSelectTag:
        {
            [self progressButtonSound];
            LevelSelectViewController *lsvc = [[LevelSelectViewController alloc] init];
            [self.navigationController pushViewController:lsvc animated:YES];
            break;
        }
            
        // Show operator selection screen
        case OperatorSelectTag:
        {
            [self progressButtonSound];
            OperatorsSelectViewController *osvc = [[OperatorsSelectViewController alloc] init];
            [self.navigationController pushViewController:osvc animated:YES];
            break;
        }
        // Back button selected, show previous screen
        case BackTag:
        {
            [self backButtonSound];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

//
- (void)progressButtonSound {
    NSError *error;
    NSURL *progressButton = [[NSBundle mainBundle] URLForResource:@"button-3" withExtension:@"wav"];
    self.modeProgressSound = [[AVAudioPlayer alloc] initWithContentsOfURL:progressButton error:&error];
    [self.modeProgressSound prepareToPlay];
    [self.modeProgressSound play];
}

//
- (void)backButtonSound {
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.modeBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.modeBackSound prepareToPlay];
    [self.modeBackSound play];
}

@end
