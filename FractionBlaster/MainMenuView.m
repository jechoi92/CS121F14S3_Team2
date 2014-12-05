//
//  MainMenuButtonsView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/14/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuView.h"

@implementation MainMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTitle];
        [self createSelectionButtons];
        [self createImages];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

- (void)createTitle
{
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width  = CGRectGetWidth(self.frame);
    
    // Title image
    UIImage *titleImage =[UIImage imageNamed:@"logo.png"];
    CGFloat titleXOffset = (width-titleImage.size.width)/2;
    CGFloat titleYOffset = 0.2 * height;
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(titleXOffset, titleYOffset, titleImage.size.width, titleImage.size.height)];
    [titleView setImage:titleImage];
    [self addSubview:titleView];

}

- (void)createSelectionButtons
{
    CGFloat buttonWidth = CGRectGetWidth(self.frame) * 0.6;
    CGFloat buttonHeight = CGRectGetHeight(self.frame) * 0.05;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.2;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.4;
    
    
    for (int i = 0; i < 4; ++i) {
        yOffset += buttonHeight * 2.25;
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);

        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Create target for cell
        [button addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
        // Set up title
        NSString *title;
        switch (i) {
            case 0:
                title = @"start_mission";
                break;
            case 1:
                title = @"instructions";
                break;
            case 2:
                title = @"leaderboards";
                break;
            case 3:
                title = @"credits";
                [button setTitle:@"Credits" forState:UIControlStateNormal];
                [button.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0f]];
                break;
            default:
                break;
        }
        
        [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
        button.tag = i;
        
        // This creates the border around the button
        UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
        background.image = [UIImage imageNamed:@"menuBorder"];
        
        [self addSubview:background];
        [self addSubview:button];
    }
}

// Here we create the pipes that underly the buttons
- (void)createImages
{
    CGFloat pipeWidth = CGRectGetWidth(self.frame) * 0.1;
    CGFloat pipeHeight = CGRectGetHeight(self.frame) * 0.2;
    CGFloat pipexOffset1 = CGRectGetWidth(self.frame) * 0.3;
    CGFloat pipexOffset2 = CGRectGetWidth(self.frame) * 0.6;
    CGFloat pipeyOffset = CGRectGetHeight(self.frame) * 0.55;
    
    CGRect pipeFrame1 = CGRectMake(pipexOffset1, pipeyOffset, pipeWidth, pipeHeight);
    CGRect pipeFrame2 = CGRectMake(pipexOffset2, pipeyOffset, pipeWidth, pipeHeight);
    
    UIImageView *pipe1 = [[UIImageView alloc] initWithFrame:pipeFrame1];
    pipe1.image = [UIImage imageNamed:@"pipe"];
    
    UIImageView *pipe2 = [[UIImageView alloc] initWithFrame:pipeFrame2];
    pipe2.image = [UIImage imageNamed:@"pipe"];
    
    [self addSubview:pipe1];
    [self addSubview:pipe2];
    [self sendSubviewToBack:pipe1];
    [self sendSubviewToBack:pipe2];
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

@end
