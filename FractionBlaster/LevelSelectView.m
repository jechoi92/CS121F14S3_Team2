//
//  LevelButtonView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LevelSelectView.h"

CGFloat INSET_RATIO;

@implementation LevelSelectView
{
    NSMutableArray *_levelButtons;
}

int BUTTONS_PER_ROW = 5;
int NUM_LEVELS = 10;

// Create the subview with all of these buttons on the level select view controller
-(id)initWithFrame:(CGRect)frame andUnlockedLevel:(int)level
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Set up rows of buttons
        int numRows = NUM_LEVELS/BUTTONS_PER_ROW;
        _levelButtons = [[NSMutableArray alloc] initWithCapacity:numRows];
        
        // Initialize and add the two arrays of rows in the array of rows
        for (int i = 0; i < numRows; ++i) {
            [_levelButtons addObject:[[NSMutableArray alloc] initWithCapacity:BUTTONS_PER_ROW]];
        }
        
        [self createEachButton:[UIButton alloc] withUnlockedLevel:level andNumRows:numRows];
        [self createTitle];
        [self createLaunchButton];
        [self createBackButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    
    return self;
}

// Goes through each slot in the nested array and places a button
// in the slot with its designated parameters
-(void)createEachButton:(UIButton*)button
                 withUnlockedLevel:(int)unlockedLevel
                       andNumRows:(int)numRows
{
    CGFloat buttonSize = CGRectGetWidth(self.frame) / 8;
    // Set the base offset and vertical offset for all of the buttons in the frame
    CGFloat baseOffset = buttonSize / 4;
    CGFloat vertOffset = CGRectGetHeight(self.frame) * 0.5;
    
    // Run through both row arrays and instatntiate each button approporately based on
    // whcih levels should be unlocked and which button is currently selected
    for (int row = 0; row < numRows; ++row){
        // Set reset xOffset for new column
        CGFloat xOffset = buttonSize;
        
        for (int col = 0; col < BUTTONS_PER_ROW; ++col){
            // Set up frame and cell and add it to the button sub view
            CGRect cellFrame = CGRectMake(xOffset, vertOffset, buttonSize, buttonSize);
            button = [[UIButton alloc] initWithFrame:cellFrame];
            [self addSubview: button];
            
            // Create target for cell
            [button addTarget:self action:@selector(levelSelected:)
                  forControlEvents:UIControlEventTouchUpInside];
            
            [self setImageForButtton:button withTag:(row * BUTTONS_PER_ROW) + col andUnlockedLevel:unlockedLevel];
            
            // Set all of the buttons that are not accessible to the player to
            // be non-responsive
            if (button.tag > unlockedLevel) {
                button.enabled = NO;
            }
            
            // Add the button to the correct spot in the nested arrays
            [[_levelButtons objectAtIndex:row] insertObject:button atIndex:col];
            
            // Update column offset
            xOffset += buttonSize + baseOffset;
        }
        
        // Update row offset
        vertOffset += buttonSize + baseOffset;
    }
}

// Appropriately instantiate the specific button with the image that designates
// the status of the button in the correct row and column in the nested array
-(void)setImageForButtton:(UIButton*)button
                  withTag:(int)tag
         andUnlockedLevel:(int)unlockedLevel
{
    // Set up the images for each button
    button.tag = tag;
    if (button.tag == 0){
        // When the game first begins, we must highlight the first button
        [self setCurrentLevelSelected:(int)button.tag];
        UIImage *strechableButtonImageNormal = [[UIImage imageNamed:@"button1highlight.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [button setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
    }
    else {
        // For all of the other buttons, check if the button should be accessible
        // by the player or not
        if (button.tag-1 < unlockedLevel) {
            NSString *deselect = [[NSString alloc] initWithFormat:@"button%ld.png", (long)button.tag+1];
            UIImage *deselectImage = [[UIImage imageNamed:deselect] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [button setBackgroundImage:deselectImage forState:UIControlStateNormal];
        } else {
            NSString *deselect = [[NSString alloc] initWithFormat:@"!button%ld.png", (long)button.tag+1];
            UIImage *deselectImage = [[UIImage imageNamed:deselect] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [button setBackgroundImage:deselectImage forState:UIControlStateNormal];
        }
    }
}

-(void)createLaunchButton
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

// Creates the level select title image at the top of the screen
-(void)createTitle
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

-(void)createBackButton
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
    backButton.tag = -1;
    [self addSubview:backButton];
}


-(void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

// Updates the array of buttons based on which button the player has selected
// and updates the button tag that we are currently highlighting
-(void)levelSelected:(id)sender
{
    UIButton *newButton = (UIButton*)sender;
    
    int row = [self currentLevelSelected] / BUTTONS_PER_ROW;
    int positionInRow = [self currentLevelSelected] % BUTTONS_PER_ROW;
    UIButton *oldButton = [[_levelButtons objectAtIndex:row] objectAtIndex:positionInRow];
    
    // Update the button images based on the new and old button tags being set
    NSString *deselect = [[NSString alloc] initWithFormat:@"button%ld.png", (long) oldButton.tag+1];
    NSString *select = [[NSString alloc] initWithFormat:@"button%ldhighlight.png", (long) newButton.tag+1];
    
    UIImage *deselectImage = [[UIImage imageNamed:deselect] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [oldButton setBackgroundImage:deselectImage forState:UIControlStateNormal];
    
    UIImage *selectImage = [[UIImage imageNamed:select] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [newButton setBackgroundImage:selectImage forState:UIControlStateNormal];
    
    // Update which button is currently selected
    [self setCurrentLevelSelected:(int)newButton.tag];
}

@end
