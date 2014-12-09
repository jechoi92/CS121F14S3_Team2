//
//  OperatorsSelectViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "OperatorsSelectViewController.h"
#import "ShipSelectViewController.h"

// Enum object for button tags
typedef enum {
    StartTag = 5,
    BackTag = 6
}ButtonTags;

@implementation OperatorsSelectViewController
{
    OperatorsSelectView* _operatorsSelectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create view and set delegate
    _operatorsSelectView = [[OperatorsSelectView alloc] initWithFrame:self.view.frame];
    [_operatorsSelectView setDelegate:self];
    [self.view addSubview: _operatorsSelectView];
}

// Function to perform action according to button selected
- (void)buttonSelected:(id)sender
{
    // Figure out which button was selected
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag) {
            
        // Show ship selection screen
        case StartTag:
        {
            [self launchSound];
            ShipSelectViewController *svc = [[ShipSelectViewController alloc]
                                       initWithLevel:-1 andOperators:[_operatorsSelectView operatorsSelected]];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
            
        // Back button was pressed, show previous screen
        case BackTag:
        {
            [self backPlaySound];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        default:
        {
            
            [self operSelectSound];
        }
    }
}

// Play the sound to go to the previous screen
- (void)backPlaySound {
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.operBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.operBackSound prepareToPlay];
    [self.operBackSound play];
}

// Play the sound to the operator a ship
- (void)operSelectSound {
    NSError *error;
    
    NSURL *progressButton = [[NSBundle mainBundle] URLForResource:@"ship-select" withExtension:@"mp3"];
    self.operSelectedSound = [[AVAudioPlayer alloc] initWithContentsOfURL:progressButton error:&error];
    [self.operSelectedSound prepareToPlay];
    [self.operSelectedSound play];
}

- (void)launchSound {
    NSError *error;
    NSURL *buttonSound = [[NSBundle mainBundle] URLForResource:@"button-3" withExtension:@"wav"];
    self.operLaunch = [[AVAudioPlayer alloc] initWithContentsOfURL:buttonSound error:&error];
    [self.operLaunch prepareToPlay];
    [self.operLaunch play];
}


@end
