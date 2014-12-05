//
//  ShipSelectViewController.m
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ShipSelectViewController.h"


@implementation ShipSelectViewController
{
    ShipSelectView *_shipSelectView;
}

// Initialize the level ship select view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the subview
    _shipSelectView = [[ShipSelectView alloc] initWithFrame:self.view.frame];
    [_shipSelectView setDelegate:self];
    [self.view addSubview: _shipSelectView];
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag){
        case 0:
        {
//            int currentLevel = [_levelSelectView currentLevelSelected] + 1;
//            GameViewController *gvc = [[GameViewController alloc]
//                                       initWithLevel:currentLevel andOperators:NULL];
//            [self.navigationController pushViewController:gvc animated:YES];
            break;
        }
        case -1:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
