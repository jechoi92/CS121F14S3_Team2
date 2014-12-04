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
    
    // Set background to same as main menu
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    
    // Set up
    _instructionsView = [[InstructionsView alloc] initWithFrame:self.view.frame];
    [_instructionsView setDelegate:self];
    [self.view addSubview:_instructionsView];
}

- (void)backToMainMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
