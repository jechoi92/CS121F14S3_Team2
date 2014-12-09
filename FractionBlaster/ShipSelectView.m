//
//  ShipSelectView.m
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ShipSelectView.h"
#import "Constants.h"

// Enum object for button tags
typedef enum {
    BlueShip,
    BrownShip,
    SilverShip,
    RedShip,
    StartTag,
    BackTag
}ButtonTags;


@implementation ShipSelectView
{
    UIButton *_startButton;
    NSMutableArray *_shipSelected;
    UILabel *_shipInfo;
    BOOL blueSelected;
    BOOL brownSelected;
    BOOL silverSelected;
    BOOL redSelected;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _shipSelected = [[NSMutableArray alloc] init];
        [self createShipSelectionButtons];
        [self createTitle];
        [self createDescriptionLabel];
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
- (void)createTitle
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(frameWidth*0.1, frameHeight*0.05, frameWidth*0.8, frameHeight*.18);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"ship_select"];
    
    [self addSubview:imageView];
}

// Create the label that has the description of the ship selected
- (void)createDescriptionLabel
{
    CGFloat labelWidth = CGRectGetWidth(self.frame) * 0.8;
    CGFloat labelHeight = CGRectGetHeight(self.frame) * 0.23;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.1;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.57;
    
    CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    
    _shipInfo = [[UILabel alloc] initWithFrame:labelFrame];
    _shipInfo.numberOfLines = 7;
    _shipInfo.textAlignment = NSTextAlignmentCenter;
    
    [_shipInfo setFont:[UIFont fontWithName:@"SpaceAge" size:32.0f]];
    [_shipInfo setTextColor:[UIColor whiteColor]];
    
    // Default set it to the first ship selected i.e. Blueship
    [_shipInfo setText:@"AlphA-clAss mAntis\r\rAmerican built. Light, manueverable, and effective."];
    
    [self addSubview:_shipInfo];
}

// Create the buttons to select the ships
- (void)createShipSelectionButtons
{
    CGFloat buttonSize = CGRectGetWidth(self.frame) / 6.5;
    CGFloat baseOffset = buttonSize / 4;
    CGFloat vertOffset = CGRectGetHeight(self.frame) * 0.4;
    CGFloat xOffset = buttonSize;
    
    // Create the four selection buttons, ship tags will be from 2 through 5,
    // observe the enum above
    for (int tag = 0; tag < 4; ++tag) {
        // Set up frame and cell and add it to the button sub view
        CGRect cellFrame = CGRectMake(xOffset, vertOffset, buttonSize, buttonSize);
        UIButton *button = [[UIButton alloc] initWithFrame:cellFrame];
        
        // Set the tag appropriately
        button.tag = tag;
        
        switch(tag) {
            case BlueShip:
            {
                // Default select the first button
                [self setCurrentShipSelected:tag];
                [button setImage:[UIImage imageNamed:@"blueSS_highlight"] forState:UIControlStateNormal];
                blueSelected = true;
                break;
            }
            case BrownShip:
            {
                [button setImage:[UIImage imageNamed:@"brownSS_no_highlight"] forState:UIControlStateNormal];
                brownSelected = false;
                break;
            }
            case SilverShip:
            {
                [button setImage:[UIImage imageNamed:@"silverSS_no_highlight"] forState:UIControlStateNormal];
                silverSelected = false;
                break;
            }
            case RedShip:
            {
                [button setImage:[UIImage imageNamed:@"redSS_no_highlight"] forState:UIControlStateNormal];
                redSelected = false;
                break;
            }
        }
        
        // Create target for button
        [button addTarget:self action:@selector(shipSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        
        // This is used to play the selection sound in the view controller
        [button addTarget:self action:@selector(buttonSelected:)
              forControlEvents:UIControlEventTouchUpInside];
        
        // Add the button to the correct spot in the nested arrays
        [_shipSelected insertObject:button atIndex:tag];
        
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
    int newTag = (int) newButton.tag;
    
    
    
    // Determine which button was previously being selected
    int shipNum = [self currentShipSelected];
    UIButton *oldButton = [_shipSelected objectAtIndex:shipNum];

    // First unhighlight the button that was previously selected
    switch(oldButton.tag) {
        case BlueShip:
        {
            [oldButton setImage:[UIImage imageNamed:@"blueSS_no_highlight"] forState:UIControlStateNormal];
            blueSelected = false;
            break;
        }
        case BrownShip:
        {
            [oldButton setImage:[UIImage imageNamed:@"brownSS_no_highlight"] forState:UIControlStateNormal];
            brownSelected = false;
            break;
        }
        case SilverShip:
        {
            [oldButton setImage:[UIImage imageNamed:@"silverSS_no_highlight"] forState:UIControlStateNormal];
            silverSelected = false;
            break;
        }
        case RedShip:
        {
            [oldButton setImage:[UIImage imageNamed:@"redSS_no_highlight"] forState:UIControlStateNormal];
            redSelected = false;
            break;
        }
    }
    
    // Then highlight the newly selected button
    switch(newTag) {
        case BlueShip:
        {
            [newButton setImage:[UIImage imageNamed:@"blueSS_highlight"] forState:UIControlStateNormal];
            blueSelected = true;
            break;
        }
        case BrownShip:
        {
            [newButton setImage:[UIImage imageNamed:@"brownSS_highlight"] forState:UIControlStateNormal];
            brownSelected = false;
            break;
        }
        case SilverShip:
        {
            [newButton setImage:[UIImage imageNamed:@"silverSS_highlight"] forState:UIControlStateNormal];;
            silverSelected = false;
            break;
        }
        case RedShip:
        {
            [newButton setImage:[UIImage imageNamed:@"redSS_highlight"] forState:UIControlStateNormal];
            redSelected = false;
            break;
        }
    }
    

    
    // Update which button is currently selected
    [self setCurrentShipSelected:(int)newTag];
    
    // Update the description label
    [self updateDescription];
}

// Function that updates the description label describing the current ship selected
- (void)updateDescription
{
    // Update the ship information label at the bottom of the screen
    switch(_currentShipSelected) {
        case BlueShip:
        {
            [_shipInfo setText:@"AlphA-clAss mAntis\r\rAmericAn model.\rlight, mAnueverAble, And effective."];
            break;
        }
        case BrownShip:
        {
            [_shipInfo setText:@"omegA-clAss mAntis\r\rrussiAn model.\rthis dAted model from the soviet erA is heAvy And bulking, yet powerful!"];
            break;
        }
        case SilverShip:
        {
            [_shipInfo setText:@"fury-clAss mAntis\r\reuropeAn model.\rThe newest And most sophisticAted Amongst the mAntis models!"];
            break;
        }
        case RedShip:
        {
            [_shipInfo setText:@"centurion-clAss mAntis\r\rchinese model.\rA prototype mAntis designed to be the most deAdly mAntis!"];
            break;
        }
    }
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
