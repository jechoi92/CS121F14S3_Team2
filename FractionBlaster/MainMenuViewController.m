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
    MainMenuView *_buttonsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    
    // Add the subview
    _buttonsView = [[MainMenuView alloc] initWithFrame:self.view.frame];
    [_buttonsView setDelegate:self];
    [self.view addSubview: _buttonsView];
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag){
        case 0:
        {
            // Go to LevelSelectViewController
            //LevelSelectViewController *lsvc = [[LevelSelectViewController alloc] init];
            ModeSelectViewController* msvc = [[ModeSelectViewController alloc] init];
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
        default:
        {
            NSLog(@"This button shouldn't exist");
            break;
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end