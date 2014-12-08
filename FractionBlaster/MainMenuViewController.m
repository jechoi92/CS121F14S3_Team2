//
//  MainMenuViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuViewController.h"

// Enum object for button tags
typedef enum {
    StartMissionTag,
    InstructionsTag,
    LeaderboardTag,
    CreditsTag
}ButtonTags;

@implementation MainMenuViewController
{
    MainMenuView *_mainMenuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the view and delegate
    _mainMenuView = [[MainMenuView alloc] initWithFrame:self.view.frame];
    [_mainMenuView setDelegate:self];
    [self.view addSubview: _mainMenuView];
}

// Function to perform actions when buttons were selected
- (void)buttonSelected:(id)sender
{
    // Figure out the button that was selected
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    
    switch (tag){
            
        // Show mode selection screen
        case StartMissionTag:
        {
            ModeSelectViewController *msvc = [[ModeSelectViewController alloc] init];
            [self.navigationController pushViewController:msvc animated:YES];
            break;
        }
            
        // Show instructions screen
        case InstructionsTag:
        {
            InstructionsViewController *ivc = [[InstructionsViewController alloc] init];
            [self.navigationController pushViewController:ivc animated:YES];
            break;
        }
            
        // Show leaderboard screen
        case LeaderboardTag:
        {
            LeaderboardViewController *lbvc = [[LeaderboardViewController alloc] init];
            [self.navigationController pushViewController:lbvc animated:YES];
            break;
        }
        
        // Show credits pop-up screen
        case CreditsTag:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fraction Blaster"
                                    message:@"HMC CS121 Fall 2014 Team 2\n\nLouis Brann, Jeongwoo Choi, \nKevin McSwiggen, Alejandro Mendoza\n\nCopyright (c) 2014 MatherTeresa. \nAll rights reserved."
                                    delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end