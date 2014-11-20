//
//  LevelButtonView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LevelButtonView.h"

@implementation LevelButtonView
{
    NSMutableArray *_levelButtons;
    int _currentLevelSelected;
    UIColor *_regularBGColor;
    UIColor *_highlightBGColor;
    
}

int BUTTONS_PER_ROW = 5;
int NUM_LEVELS = 10;
int IPAD_FONT_SIZE = 40;

// Create the subview with all of these buttons on the level select view controller
-(id)initWithFrame:(CGRect)frame
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
        
        // Setup cell size and offset
        CGFloat frameWidth = CGRectGetWidth(frame);
        
        // 5 buttons, plus 1 cellSize reserved for borders
        CGFloat buttonSize = frameWidth/(5.0 + 1.0);
        
        UIButton *levelButton;
        
        // Retrieve the number to see if the level button should be unlocked
        int unlockedLevel = [self readProgress];
        
        [self createEachButtonWithButton:levelButton andButtonSize:(CGFloat)buttonSize andUnlockedLevel:unlockedLevel andNumRows:numRows];
    }
    
    return self;
}

// Goes through each slot in the nested array and places a button
// in the slot with its designated parameters
-(void)createEachButtonWithButton:(UIButton*)button
                    andButtonSize:(CGFloat)buttonSize
                 andUnlockedLevel:(int)unlockedLevel
                       andNumRows:(int)numRows
{
    // Set the base offset and vertical offset for all of the buttons in the frame
    CGFloat baseOffset = buttonSize/(6.0);
    CGFloat vertOffset = baseOffset * 3 / 6;
    
    // Run through both row arrays and instatntiate each button approporately based on
    // whcih levels should be unlocked and which button is currently selected
    for (int row = 0; row < numRows; ++row){
        // Set reset xOffset for new column
        CGFloat xOffset = baseOffset;
        
        for (int col = 0; col < BUTTONS_PER_ROW; ++col){
            // Set up frame and cell and add it to the button sub view
            CGRect cellFrame = CGRectMake(xOffset, vertOffset, buttonSize, buttonSize);
            button = [[UIButton alloc] initWithFrame:cellFrame];
            [self addSubview: button];
            
            // Create target for cell
            [button addTarget:self action:@selector(levelSelected:)
                  forControlEvents:UIControlEventTouchUpInside];
            
            [self setImageForButtton:button withRow:row andColumn:col andUnlockedLevel:unlockedLevel];
            
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
                  withRow:(int)row
                andColumn:(int)col
         andUnlockedLevel:(int)unlockedLevel
{
    // Set up the images for each button
    button.tag = (row * BUTTONS_PER_ROW) + col;
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

// Updates the Progress text file to save the progress of the player
// after  the player closes and reopens the game
- (int)readProgress
{
    // Retrieve the path to the location of where to place the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    // Use simple alert from my library (see previous post for details)
    return [content intValue];;
}

@end
