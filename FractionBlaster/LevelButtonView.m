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
}

int BUTTONS_PER_ROW = 5;
int NUM_LEVELS = 10;
int IPAD_FONT_SIZE = 40;
UIColor *regularBGColor;
UIColor *highlightBGColor;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    regularBGColor = [UIColor colorWithRed:0.898 green:0.973
                                      blue:1.0 alpha:1.0];
    highlightBGColor = [UIColor colorWithRed:0.486 green:0.816
                                        blue:0.447 alpha:1.0];
    if (self){
      // Set up rows of buttons
      int numRows = NUM_LEVELS/BUTTONS_PER_ROW;
      _levelButtons = [[NSMutableArray alloc] initWithCapacity:numRows];
      
        for (int i = 0; i < numRows; ++i) {
        [_levelButtons addObject:[[NSMutableArray alloc] initWithCapacity:BUTTONS_PER_ROW]];
      }
      
      // Setup cell size and offset
      CGFloat frameWidth = CGRectGetWidth(frame);
      
      // 5 buttons, plus 1 cellSize reserved for borders
      CGFloat buttonSize = frameWidth/(5.0 + 1.0);
      
      // 6 Borders for 5 buttons
      CGFloat baseOffset = buttonSize/(6.0);
      CGFloat yOffset = baseOffset * 3 / 6;
    
      UIButton *levelButton;
      
      int unlockedLevel = [self readProgress];
      
      for (int row = 0; row < numRows; ++row){
        // Set/reset xOffset for new column
        CGFloat xOffset = baseOffset;
        
        for (int col = 0; col < BUTTONS_PER_ROW; ++col){
          // Set up frame and cell
          CGRect cellFrame = CGRectMake(xOffset, yOffset, buttonSize, buttonSize);
          levelButton = [[UIButton alloc] initWithFrame:cellFrame];
          
          [self addSubview: levelButton];
          
          // Create target for cell
          [levelButton addTarget:self action:@selector(levelSelected:)
                forControlEvents:UIControlEventTouchUpInside];
        
          // Set up button colors
          levelButton.tag = (row * BUTTONS_PER_ROW) + col;
          if (levelButton.tag == 0){
            [self setCurrentLevelSelected:(int)levelButton.tag];
            [levelButton setBackgroundColor:highlightBGColor];
          }
          else {
            [levelButton setBackgroundColor:regularBGColor];
          }
          
          
          // Set up title
          [levelButton setTitle:[NSString stringWithFormat:@"%ld", (long)levelButton.tag+1]
                     forState:UIControlStateNormal];
          [levelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          levelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                      size:IPAD_FONT_SIZE];
          levelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            if (levelButton.tag > unlockedLevel) {
                levelButton.enabled = NO;
                [levelButton setBackgroundColor:[UIColor grayColor]];
            }
          
          [[_levelButtons objectAtIndex:row] insertObject:levelButton atIndex:col];
          
          // Update column offset
          xOffset += buttonSize + baseOffset;
        }
        
        // Update row offset
        yOffset += buttonSize + baseOffset;
        }
    }
  
    return self;
}

- (void)levelSelected:(id)sender
{
    UIButton *newButton = (UIButton*)sender;
    
    int row = [self currentLevelSelected] / BUTTONS_PER_ROW;
    int positionInRow = [self currentLevelSelected] % BUTTONS_PER_ROW;
    UIButton *oldButton = [[_levelButtons objectAtIndex:row] objectAtIndex:positionInRow];
  
    // Change the background colors appropriately
    [oldButton setBackgroundColor:regularBGColor];
  
    // Delete button and numpad buttons are highlighted differently
    [newButton setBackgroundColor:highlightBGColor];
  
    // Update which button is currently selected
    [self setCurrentLevelSelected:(int)newButton.tag];
}

- (int)readProgress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    //use simple alert from my library (see previous post for details)

    
    return [content intValue];;
}

@end
