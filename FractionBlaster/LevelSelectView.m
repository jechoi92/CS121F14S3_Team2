//
//  LevelButtonView.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LevelSelectView.h"
#import "Constants.h"

// Enum object for button tags
typedef enum {
    Level1,
    Level2,
    Level3,
    Level4,
    Level5,
    Level6,
    Level7,
    Level8,
    Level9,
    Level10,
    StartTag,
    BackTag
}ButtonTags;

@implementation LevelSelectView
{
    NSMutableArray *_levelButtons;
    UILabel *_levelInfo;
}

// Allow adding extra levels later on
int BUTTONS_PER_ROW = 5;
int NUM_LEVELS = 10;

// Create the subview with all of these buttons on the level select view controller
- (id)initWithFrame:(CGRect)frame andUnlockedLevel:(int)level
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Set up rows of buttons
        int numRows = NUM_LEVELS/BUTTONS_PER_ROW;
        _levelButtons = [[NSMutableArray alloc] initWithCapacity:2];
        
        // Initialize and add the two arrays of rows in the array of rows
        for (int i = 0; i < numRows; ++i) {
            [_levelButtons addObject:[[NSMutableArray alloc] initWithCapacity:BUTTONS_PER_ROW]];
        }
        
        [self createEachButton:[UIButton alloc] withUnlockedLevel:level andNumRows:numRows];
        [self createTitle];
        [self createDescriptionLabel];
        [self createStartButton];
        [self createBackButton];
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"main_background"]]];
    }
    
    return self;
}

// Go through the array and create the buttons for level selection
- (void)createEachButton:(UIButton*)button withUnlockedLevel:(int)unlockedLevel andNumRows:(int)numRows
{
    CGFloat buttonSize = CGRectGetWidth(self.frame) / 8;
    CGFloat baseOffset = buttonSize / 4;
    CGFloat vertOffset = CGRectGetHeight(self.frame) * 0.35;
    
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
            
            // This allows for certain sound to be played when a button is pressed
            [button addTarget:self action:@selector(buttonSelected:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [self setImageForButton:button withTag:(row * BUTTONS_PER_ROW) + col andUnlockedLevel:unlockedLevel];
            
            // Set all of the buttons that are not accessible to the player to
            // be unresponsive
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
- (void)setImageForButton:(UIButton*)button withTag:(int)tag andUnlockedLevel:(int)unlockedLevel
{
    // Set up the images for each button
    button.tag = tag;
    
    // Default select the first button
    if (button.tag == Level1) {
        [self setCurrentLevelSelected:(int)button.tag];
        UIImage *strechableButtonImageNormal = [[UIImage imageNamed:@"button1highlight.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [button setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
    }
    
    // For all of the other buttons, enable and disable according to max. unlocked level
    else {
        if (button.tag-1 < unlockedLevel) {
            NSString *deselect = [[NSString alloc] initWithFormat:@"button%ld.png", (long)button.tag+1];
            UIImage *deselectImage = [[UIImage imageNamed:deselect] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [button setBackgroundImage:deselectImage forState:UIControlStateNormal];
        }
        else {
            NSString *deselect = [[NSString alloc] initWithFormat:@"!button%ld.png", (long)button.tag+1];
            UIImage *deselectImage = [[UIImage imageNamed:deselect] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [button setBackgroundImage:deselectImage forState:UIControlStateNormal];
        }
    }
}

// Create start button
- (void)createStartButton
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
    
    // Set tag appropriately
    startButton.tag = StartTag;
    
    [self addSubview:startButton];
}

// Creates the level select title image at the top of the screen
- (void)createTitle
{
    // Get frame and frame dimensions
    CGRect frame = self.frame;
    CGFloat frameWidth = CGRectGetWidth(frame);
    CGFloat frameHeight = CGRectGetHeight(frame);
    
    // Add the level select image to the top of the view
    CGRect title = CGRectMake(frameWidth*0.1, frameHeight*0.05, frameWidth*0.8, frameHeight*.18);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:title];
    imageView.image = [UIImage imageNamed:@"new_level_select"];
    
    [self addSubview:imageView];
}

// Creates the label that describes the current level selected
- (void)createDescriptionLabel
{
    CGFloat labelWidth = CGRectGetWidth(self.frame) * 0.8;
    CGFloat labelHeight = CGRectGetHeight(self.frame) * 0.25;
    CGFloat xOffset = CGRectGetWidth(self.frame) * 0.1;
    CGFloat yOffset = CGRectGetHeight(self.frame) * 0.57;
    
    CGRect labelFrame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
    
    _levelInfo = [[UILabel alloc] initWithFrame:labelFrame];
    _levelInfo.numberOfLines = 8;
    _levelInfo.textAlignment = NSTextAlignmentCenter;
    
    [_levelInfo setFont:[UIFont fontWithName:@"SpaceAge" size:32.0f]];
    [_levelInfo setTextColor:[UIColor whiteColor]];
    
    // Default set it to the description of the first level
    [_levelInfo setText:@"Level 1\rsimplificAtion Asteroids coming in At A slow speed. Perfect conditions for A beginning cAdet to leArn the ropes!"];
    
    [self addSubview:_levelInfo];
}

// Create back button
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
    
    // Create target for button
    [backButton addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
    
    // Set tag appropriately
    backButton.tag = BackTag;
    
    [self addSubview:backButton];
}

- (void)buttonSelected:(id)sender
{
    [self.delegate buttonSelected:sender];
}

// Updates the array of buttons based on which button the player has selected
// and updates the button tag that we are currently highlighting
- (void)levelSelected:(id)sender
{
    UIButton *newButton = (UIButton*)sender;
    
    int row = [self currentLevelSelected] / BUTTONS_PER_ROW;
    int positionInRow = [self currentLevelSelected] % BUTTONS_PER_ROW;
    UIButton *oldButton = [[_levelButtons objectAtIndex:row] objectAtIndex:positionInRow];
    
    // Update the button images based on the new and old button tags being set
    NSString *deselect = [[NSString alloc] initWithFormat:@"button%ld.png", (long) oldButton.tag+1];
    NSString *select = [[NSString alloc] initWithFormat:@"button%ldhighlight.png", (long) newButton.tag+1];
    
    // Highlight the newly selected level and unhighlight the prieviously selected button
    UIImage *deselectImage = [[UIImage imageNamed:deselect] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [oldButton setBackgroundImage:deselectImage forState:UIControlStateNormal];
    UIImage *selectImage = [[UIImage imageNamed:select] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [newButton setBackgroundImage:selectImage forState:UIControlStateNormal];
    
    // Update which button is currently selected
    [self setCurrentLevelSelected:(int)newButton.tag];
    
    [self updateDescription];
}

// Function that updates the description label describing the current level selected
- (void)updateDescription
{
    // Update the level information label at the bottom of the screen
    switch (_currentLevelSelected) {
        case Level1:
            [_levelInfo setText:@"Level 1\rsimplificAtion Asteroids coming in At A slow speed. Perfect conditions for A beginning cAdet to leArn the ropes!"];
            break;
        case Level2:
            [_levelInfo setText:@"Level 2\rcAdets get their first experience with multiplicAtion Asteroids At A slow speed!"];
            break;
        case Level3:
            [_levelInfo setText:@"Level 3\rincoming division Asteroids! cAdets should use their Acquired multiplicAtion skills to combAt these Asteroids!"];
            break;
        case Level4:
            [_levelInfo setText:@"Level 4\rnew types of Asteroids incoming! detectors Are reAding both Addition And subtrAction Asteroids! CAdets must learn new solving skills!"];
            break;
        case Level5:
            [_levelInfo setText:@"Level 5\rcAdet no longer! trAvel to the source of the Asteroids And Apply All your new solving skills to stop the source of these Asteroids!"];
            break;
        case Level6:
            [_levelInfo setText:@"Level 6\ryou survived the journey! but there is no time to rest! we hAve incoming multiplicAtion And division Asteroids At medium speed!"];
            break;
        case Level7:
            [_levelInfo setText:@"Level 7\rAnother lArge wAve of Addition And division Asteroids incoming! you cAn hAndle this!"];
            break;
        case Level8:
            [_levelInfo setText:@"Level 8\rdetectors Are picking up reAdings of Another huge wAve of Asteroids! survive this wAve and become A true veterAn!"];
            break;
        case Level9:
            [_levelInfo setText:@"Level 9\rdAnger! An even lArger wAve is incoming! these Asteroids Are coming At speeds thAt hAve never been recorded!"];
            break;
        case Level10:
            [_levelInfo setText:@"Level 10\rIt All comes down to this! The source of these Asteroid AttAcks! neutrAlize this threAt once And for All to ensure the survivAl of eArth!"];
            break;
        default:
            break;
    }
}

@end
