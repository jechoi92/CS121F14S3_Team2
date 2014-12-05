//
//  ShipSelectView.m
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ShipSelectView.h"

CGFloat INSET_RATIO;

@implementation ShipSelectView
{
    UIButton *_startButton;
    NSMutableArray *_shipSelection;
    //int _currentShipSelected;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _shipSelection = [[NSMutableArray alloc] init];
        [self createShipSelectionButtons:[UIButton alloc]];
        [self createTitleImage];
        [self createBackButton];
        [self createLaunchButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

- (void)createBackButton
{
    CGRect frame = self.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    CGFloat itemWidth = size / 15;
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    UIButton* backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [backButton setBackgroundImage:[UIImage imageNamed:@"StartOverIcon"] forState:UIControlStateNormal];
    [[backButton layer] setBorderWidth:2.5f];
    [[backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[backButton layer] setCornerRadius:12.0f];
    [backButton addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = -1;
    [self addSubview:backButton];
}

- (void)createTitleImage
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(0, -50, frameWidth, frameHeight*.5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"Levels.png"];
    [self addSubview:imageView];
}

- (void)createShipSelectionButtons:(UIButton*)button
{
    CGFloat buttonSize = CGRectGetWidth(self.frame) / 6.5;
    // Set the base offset and vertical offset for all of the buttons in the frame
    CGFloat baseOffset = buttonSize / 4;
    CGFloat vertOffset = CGRectGetHeight(self.frame) * 0.5;
    
    CGFloat xOffset = buttonSize;
    
    
    for (int col = 0; col < 4; ++col) {
        // Set up frame and cell and add it to the button sub view
        CGRect cellFrame = CGRectMake(xOffset, vertOffset, buttonSize, buttonSize);
        button = [[UIButton alloc] initWithFrame:cellFrame];
        
        [self addSubview: button];
        
        // Create target for cell
        [button addTarget:self action:@selector(shipSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self setImageForButton:button withTag:col];
        
        // Add the button to the correct spot in the nested arrays
        [_shipSelection insertObject:button atIndex:col];
        
        // Update column offset
        xOffset += buttonSize + baseOffset;
    }

}


- (void) setImageForButton:(UIButton*)button withTag:(int)tag
{
    button.tag = tag;
    if (tag == 0) {
        [self setCurrentShipSelected:(int)button.tag];
        [button setImage:[UIImage imageNamed:@"blueSpaceShip"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    } else if (tag == 1) {
        [button setImage:[UIImage imageNamed:@"brownSpaceShip"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
    } else if (tag == 2) {
        [button setImage:[UIImage imageNamed:@"silverSpaceShip"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
    } else {
        [button setImage:[UIImage imageNamed:@"redSpaceShip"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
    }
}

// Updates the array of buttons based on which button the player has selected
// and updates the button tag that we are currently highlighting
-(void)shipSelected:(id)sender
{
    UIButton *newButton = (UIButton*)sender;
    
    int shipNum = [self currentShipSelected];
    UIButton *oldButton = [_shipSelection objectAtIndex:shipNum];
    
    int newTag = newButton.tag;
    
    [oldButton setBackgroundColor:[UIColor grayColor]];
    [newButton setBackgroundColor:[UIColor whiteColor]];
    
    // Update which button is currently selected
    [self setCurrentShipSelected:(int)newTag];
}

- (void)createLaunchButton
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    // Create start button with the appropriate delegate
    CGRect startButtonFrame = CGRectMake(width * 0.2, height * 0.8, width * 0.6, height * 0.15);
    UIButton *startButton = [[UIButton alloc] initWithFrame:startButtonFrame];
    
    UIImage *image = [UIImage imageNamed:@"launch2.png"];
    [startButton setImage:image forState:UIControlStateNormal];
    
    [startButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    startButton.tag = 0;
    [self addSubview:startButton];
}


-(void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

@end
