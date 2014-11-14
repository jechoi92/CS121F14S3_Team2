//
//  MainMenuViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // TODO: Get rid of magic numbers
    CGFloat buttonsFrameHeight = self.view.frame.size.height * 2/5;
    CGFloat buttonsFrameWidth = self.view.frame.size.width * 1/4;
    // Make the offsets such that it will be centered
    CGFloat buttonsFrameYOffset = (self.view.frame.size.height/2)-(0.5*buttonsFrameHeight);
    CGFloat buttonsFrameXOffset = (self.view.frame.size.width/2)-(0.5*buttonsFrameWidth);
    CGRect buttonsFrame = CGRectMake(buttonsFrameXOffset, buttonsFrameYOffset, buttonsFrameWidth, buttonsFrameHeight);
    
    MainMenuButtonsView *mmbv = [[MainMenuButtonsView alloc] initWithFrame:buttonsFrame];
    [self.view addSubview: mmbv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end