//
//  OperatorsSelectViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "OperatorsSelectViewController.h"

@implementation OperatorsSelectViewController
{
    OperatorsSelectView* _operatorsSelectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    
    // Add the subview
    _operatorsSelectView = [[OperatorsSelectView alloc] initWithFrame:self.view.frame];
    [_operatorsSelectView setDelegate:self];
    [self.view addSubview: _operatorsSelectView];
}

- (void)buttonSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag){
        case 5:
        {
            GameViewController *gvc = [[GameViewController alloc]
                                       initWithLevel:-1 andOperators:[_operatorsSelectView operatorsSelected]];
            [self.navigationController pushViewController:gvc animated:YES];
            break;
        }
        case 6:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}



@end
