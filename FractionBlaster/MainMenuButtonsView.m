//
//  MainMenuButtonsView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/14/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuButtonsView.h"

@implementation MainMenuButtonsView
{
    NSMutableArray *_buttons;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor blackColor];
    
    int IPAD_FONT_SIZE = 40;
    
    
    // Make 2 buttons for now
    int numButtons = 3;
    int buttonsPerRow = 1;
    int rows = numButtons / buttonsPerRow;
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:numButtons];
    
    // Set up borders - currently each border will be 1/4 of button size
    int baseBorder = 0.25;
    int totalBorderPerRow = (buttonsPerRow + 1) * baseBorder;
    int totalBorderPerCol = (rows + 1) * baseBorder;
    
    // Setup button size
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetWidth(frame);
    CGFloat buttonWidth = frameWidth / (buttonsPerRow + totalBorderPerRow);
    CGFloat buttonHeight = frameHeight / (rows + totalBorderPerCol);
    
    CGFloat xOffset = baseBorder;
    CGFloat yOffset = baseBorder;
    
    UIButton* button;
    for (int i = 0; i < rows; ++i){
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        
        button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Create target for cell
        [button addTarget:self action:@selector(buttonSelected:)
              forControlEvents:UIControlEventTouchUpInside];
        
        // Set up title
        NSString *titleString;
        switch (i){
            case 0:
                titleString = @"Start Game";
                break;
            case 1:
                titleString = @"Instructions";
                break;
            case 2:
                titleString = @"Leaderboard";
                break;
            default:
                titleString = @"Unassigned";
                break;
        }
        [button setTitle:titleString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                      size:IPAD_FONT_SIZE];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        // Tag the button for identification
        button.tag = i;
        
        [self addSubview:button];
        [_buttons addObject:button];
        
        yOffset += buttonHeight;
    }
    
    return self;
}

-(void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

@end
