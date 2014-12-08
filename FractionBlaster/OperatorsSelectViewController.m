//
//  OperatorsSelectViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "OperatorsSelectViewController.h"

// Enum object for button tags
typedef enum {
    StartTag,
    BackTag
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
            ShipSelectViewController *svc = [[ShipSelectViewController alloc]
                                       initWithLevel:-1 andOperators:[_operatorsSelectView operatorsSelected]];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
            
        // Back button was pressed, show previous screen
        case BackTag:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}



@end
