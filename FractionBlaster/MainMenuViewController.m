//
//  MainMenuViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuViewController.h"

@implementation MainMenuViewController
{
    MainMenuView *_mainMenuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the subview
    _mainMenuView = [[MainMenuView alloc] initWithFrame:self.view.frame];
    [_mainMenuView setDelegate:self];
    [self.view addSubview: _mainMenuView];
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    
    switch (tag){
        case 0:
        {
            // Go to ModeSelectViewController
            ModeSelectViewController *msvc = [[ModeSelectViewController alloc] init];
            [self.navigationController pushViewController:msvc animated:YES];
            break;
        }
        case 1:
        {
            // Go to InstrViewController
            InstructionsViewController *ivc = [[InstructionsViewController alloc] init];
            [self.navigationController pushViewController:ivc animated:YES];
            break;
        }
        case 2:
        {
            // Go to Leaderboard
            LeaderboardViewController *lbvc = [[LeaderboardViewController alloc] init];
            [self.navigationController pushViewController:lbvc animated:YES];
            break;
        }
        case 3:
        {
            // Show credits
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fraction Blaster"
                                                            message:@"HMC CS121 Fall 2014 Team 2\n\nLouis Brann, Jeongwoo Choi, \nAlejandro Mendoza, Kevin McSwiggen\n\nCopyright (c) 2014 MatherTeresa. \nAll rights reserved."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            break;
        }
        default:
        {
            NSLog(@"This button shouldn't exist");
            break;
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end