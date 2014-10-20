//
//  InstrViewController.m
//  SpriteKitSimpleGame
//
//  Created by Louie Brann on 10/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "InstrViewController.h"

@implementation InstrViewController

- (IBAction)close {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
