//
//  ModeSelectViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ModeSelectViewController.h"

@implementation ModeSelectViewController
{
    ModeSelectView *_modeSelectView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the subview
    _modeSelectView = [[ModeSelectView alloc] initWithFrame:self.view.frame];
    [_modeSelectView setDelegate:self];
    [self.view addSubview:_modeSelectView];
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag) {
        case 0:
        {
            // Go to LevelSelectViewController
            LevelSelectViewController *lsvc = [[LevelSelectViewController alloc] init];
            [self.navigationController pushViewController:lsvc animated:YES];
            break;
        }
        case 1:
        {
            // Go to OperatorSelectViewController
            OperatorsSelectViewController *osvc = [[OperatorsSelectViewController alloc] init];
            [self.navigationController pushViewController:osvc animated:YES];
            break;
        }
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
