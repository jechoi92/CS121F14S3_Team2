//
//  MainMenuButtonsView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/14/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "MainMenuView.h"

// Enum object for button tags
typedef enum {
    StartMissionTag,
    InstructionsTag,
    LeaderboardTag,
    CreditsTag
}ButtonTags;

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

// Create title image
- (void)createTitle
{
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width  = CGRectGetWidth(self.frame);
    UIImage *titleImage =[UIImage imageNamed:@"logo.png"];
    CGFloat titleXOffset = (width-titleImage.size.width)/2;
    CGFloat titleYOffset = 0.2 * height;
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(titleXOffset, titleYOffset, titleImage.size.width, titleImage.size.height)];
    [titleView setImage:titleImage];
    
    [self addSubview:titleView];
}

// Create selection buttons for the main menu
- (void)createSelectionButtons
{
    CGFloat buttonWidth = CGRectGetWidth(self.frame) * 0.6;
    CGFloat buttonHeight = CGRectGetHeight(self.frame) * 0.05;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.2;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.42;
    
    
    // Create the four buttons
    for (int i = 0; i < 4; ++i) {
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);

        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Create target for cell
        [button addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
        // Set tag number appropriately
        button.tag = i;
        
        // Set up titles
        NSString *title;
        switch (button.tag) {
            case StartMissionTag:
                title = @"start_mission";
                break;
            case InstructionsTag:
                title = @"instructions";
                break;
            case LeaderboardTag:
                title = @"leaderboards";
                break;
            case CreditsTag:
                title = @"credits";
                
                //[button setTitle:@"Credits" forState:UIControlStateNormal];
                //[button.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:36.0f]];
                break;
            default:
                break;
        }
        
        // Set background images for each button
        [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
        
        // Set border images for each button
        UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
        background.image = [UIImage imageNamed:@"menuBorder"];
        
        [self addSubview:background];
        [self addSubview:button];
        
        // Increment offset for next button frame
        yOffset += buttonHeight * 2.25;
    }
}

// Create images (pipes) for aesthetic purposes
- (void)createImages
{
    CGFloat pipeWidth = CGRectGetWidth(self.frame) * 0.1;
    CGFloat pipeHeight = CGRectGetHeight(self.frame) * 0.2;
    CGFloat pipexOffset1 = CGRectGetWidth(self.frame) * 0.3;
    CGFloat pipexOffset2 = CGRectGetWidth(self.frame) * 0.6;
    CGFloat pipeyOffset1 = CGRectGetHeight(self.frame) * 0.57;
    CGFloat pipeyOffset2 = CGRectGetHeight(self.frame) * 0.7;
    
    CGRect pipeFrame1 = CGRectMake(pipexOffset1, pipeyOffset1, pipeWidth, pipeHeight);
    CGRect pipeFrame2 = CGRectMake(pipexOffset2, pipeyOffset1, pipeWidth, pipeHeight);
    CGRect pipeFrame3 = CGRectMake(pipexOffset1, pipeyOffset2, pipeWidth, pipeHeight);
    CGRect pipeFrame4 = CGRectMake(pipexOffset2, pipeyOffset2, pipeWidth, pipeHeight);
    
    // Create images
    UIImageView *pipe1 = [[UIImageView alloc] initWithFrame:pipeFrame1];
    pipe1.image = [UIImage imageNamed:@"pipe"];
    UIImageView *pipe2 = [[UIImageView alloc] initWithFrame:pipeFrame2];
    pipe2.image = [UIImage imageNamed:@"pipe"];
    
    UIImageView *pipe3 = [[UIImageView alloc] initWithFrame:pipeFrame3];
    pipe3.image = [UIImage imageNamed:@"pipe"];
    
    UIImageView *pipe4 = [[UIImageView alloc] initWithFrame:pipeFrame4];
    pipe4.image = [UIImage imageNamed:@"pipe"];
    
    [self addSubview:pipe1];
    [self addSubview:pipe2];
    [self addSubview:pipe3];
    [self addSubview:pipe4];
    [self sendSubviewToBack:pipe1];
    [self sendSubviewToBack:pipe2];
    [self sendSubviewToBack:pipe3];
    [self sendSubviewToBack:pipe4];
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

@end
