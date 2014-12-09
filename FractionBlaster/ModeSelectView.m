//
//  ModeSelectView.m
//  FractionBlaster
//
//  Created by CS121 on 11/30/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ModeSelectView.h"

CGFloat INSET_RATIO;

// Enum object for button tags
typedef enum {
    LevelSelectTag,
    OperatorSelectTag,
    BackTag
}ButtonTags;

@implementation ModeSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTitleImage];
        [self createSelectionButtons];
        [self createLabels];
        [self createBackButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

// Create the title
- (void)createTitleImage
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(frameWidth*0.1, frameHeight*0.05, frameWidth*0.8, frameHeight*.18);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"mode_select"];
    
    [self addSubview:imageView];
}

// Create selection buttons for the two modes i.e. campaign and survival
- (void)createSelectionButtons
{
    CGFloat buttonWidth = CGRectGetWidth(self.frame) * 0.6;
    CGFloat buttonHeight = CGRectGetHeight(self.frame) * 0.1;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.2;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.3;
    
    // Create the two buttons
    for (int i = 0; i < 2; ++i){
        CGRect buttonFrame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        
        // Create target for buttons
        [button addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
        // Style button
    //   [button.titleLabel setFont:[UIFont fontWithName:@"SpaceAge" size:42.0f]];
      //  [[button layer] setBorderWidth:6.0f];
      //  [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
      //  [[button layer] setCornerRadius:18.0f];
        
        // Set up tag to determine action accordingly when button selected
        button.tag = i;
        
        // Set up titles for each button
        switch (button.tag){
            case LevelSelectTag:
                [button setBackgroundImage:[UIImage imageNamed:@"campaign_mode_button"] forState:UIControlStateNormal];
                
                break;
            case OperatorSelectTag:
                [button setBackgroundImage:[UIImage imageNamed:@"survival_mode_button"] forState:UIControlStateNormal];
                break;
        }
        
        // Create background image for button
        UIImageView *background = [[UIImageView alloc] initWithFrame:buttonFrame];
        background.image = [UIImage imageNamed:@"menuBorder"];
        
        [self addSubview:background];
        [self addSubview:button];
        
        // Increment offset for the next button frame
        yOffset += buttonHeight * 3;
    }
}

// Create description labels for each mode
- (void)createLabels
{
    CGFloat labelWidth = CGRectGetWidth(self.frame) * 0.6;
    CGFloat labelHeight = CGRectGetHeight(self.frame) * 0.3;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.2;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.3;
    
    // Create the two labels
    for (int i = 0; i < 2; ++i){
        CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.numberOfLines = 3;
        label.textAlignment = NSTextAlignmentCenter;
        
        // Create target for buttons
        [label setFont:[UIFont fontWithName:@"SpaceAge" size:24.0f]];
        [label setTextColor:[UIColor whiteColor]];
        
        // Set titles for each button
        switch (i){
            case 0:
                [label setText:@"Play the campaign to complete all missions and save Earth!"];
                break;
            case 1:
                [label setText:@"Challenge your friends to an endless fraction frenzy!"];
                break;
        }
        
        [self addSubview:label];
        
        // Increment offset for the next label frame
        yOffset += labelHeight ;
    }
}

// Create the back button
- (void)createBackButton
{
    CGFloat size = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat itemWidth = size / 15;
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(self.frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(self.frame) * INSET_RATIO;
    
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[backButton layer] setCornerRadius:12.0f];
    
    [backButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    
    // Set the tag accordingly
    backButton.tag = BackTag;
    [self addSubview:backButton];
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}


@end

