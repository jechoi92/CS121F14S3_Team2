//
//  ShipSelectView.m
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ShipSelectView.h"

CGFloat INSET_RATIO;

// Enum object for button tags
typedef enum {
    StartTag,
    BackTag
}ButtonTags;

// Enum object for ship numbers
typedef enum {
    BlueShip,
    BrownShip,
    SilverShip,
    RedShip
}ShipNumbers;

@implementation ShipSelectView
{
    UIButton *_startButton;
    NSMutableArray *_shipSelection;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _shipSelection = [[NSMutableArray alloc] init];
        [self createShipSelectionButtons];
        [self createTitleImage];
        [self createBackButton];
        [self createStartButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    return self;
}

// Create the back button
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
    
    // Create target for button
    [backButton addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // Set tag
    backButton.tag = BackTag;
    
    [self addSubview:backButton];
}

// Create the title
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

// Create the buttons to select the ships
- (void)createShipSelectionButtons
{
    CGFloat buttonSize = CGRectGetWidth(self.frame) / 6.5;
    CGFloat baseOffset = buttonSize / 4;
    CGFloat vertOffset = CGRectGetHeight(self.frame) * 0.5;
    CGFloat xOffset = buttonSize;
    
    // Create the four selection buttons
    for (int tag = 0; tag < 4; ++tag) {
        // Set up frame and cell and add it to the button sub view
        CGRect cellFrame = CGRectMake(xOffset, vertOffset, buttonSize, buttonSize);
        UIButton *button = [[UIButton alloc] initWithFrame:cellFrame];
        [button setBackgroundColor:[UIColor grayColor]];
        
        // Set the tag appropriately
        button.tag = tag;
        
        switch(tag) {
            case BlueShip:
            {
                // Default select the first button
                [self setCurrentShipSelected:tag];
                [button setBackgroundColor:[UIColor whiteColor]];
                
                [button setImage:[UIImage imageNamed:@"blueSpaceShip"] forState:UIControlStateNormal];
                break;
            }
            case BrownShip:
            {
                [button setImage:[UIImage imageNamed:@"brownSpaceShip"] forState:UIControlStateNormal];
                break;
            }
            case SilverShip:
            {
                [button setImage:[UIImage imageNamed:@"silverSpaceShip"] forState:UIControlStateNormal];
                break;
            }
            case RedShip:
            {
                [button setImage:[UIImage imageNamed:@"redSpaceShip"] forState:UIControlStateNormal];
                break;
            }
        }
        
        // Create target for button
        [button addTarget:self action:@selector(shipSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
        // Add the button to the correct spot in the nested arrays
        [_shipSelection insertObject:button atIndex:tag];
        
        [self addSubview: button];
        
        // Increment offset for next button frame
        xOffset += buttonSize + baseOffset;
    }
}

// Updates the array of buttons based on which button the player has selected
// and updates the button tag that we are currently highlighting
-(void)shipSelected:(id)sender
{
    UIButton *newButton = (UIButton*)sender;
    
    int shipNum = [self currentShipSelected];
    UIButton *oldButton = [_shipSelection objectAtIndex:shipNum];
    
    int newTag = (int) newButton.tag;
    
    // Unhighlight the previous selected button and highlight the newly selected button
    [oldButton setBackgroundColor:[UIColor grayColor]];
    [newButton setBackgroundColor:[UIColor whiteColor]];
    
    // Update which button is currently selected
    [self setCurrentShipSelected:(int)newTag];
}

// Create the start button
- (void)createStartButton
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect startButtonFrame = CGRectMake(width * 0.2, height * 0.8, width * 0.6, height * 0.15);
    UIButton *startButton = [[UIButton alloc] initWithFrame:startButtonFrame];
    
    // Set image for button
    UIImage *image = [UIImage imageNamed:@"launch2.png"];
    [startButton setImage:image forState:UIControlStateNormal];
    
    // Create target for button
    [startButton addTarget:self action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    
    // Set the tag appropriately
    startButton.tag = StartTag;
    
    [self addSubview:startButton];
}

-(void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

@end
