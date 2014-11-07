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
UIColor *regularBGColor = nil;
UIColor *highlightBGColor = nil;

+(void)initialize
{
  if (!regularBGColor){
    regularBGColor = [UIColor colorWithRed:0.898 green:0.973
                                      blue:1.0 alpha:1.0];
  }
  if (!highlightBGColor){
    highlightBGColor = [UIColor colorWithRed:0.486 green:0.816
                                         blue:0.447 alpha:1.0];
  }
}

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if (self){
    // Set up rows of buttons
    int numRows = NUM_LEVELS/BUTTONS_PER_ROW;
    for (int i = 0; i < numRows; ++i) {
      [_levelButtons addObject:[[NSMutableArray alloc] initWithCapacity:BUTTONS_PER_ROW]];
    }
    
    // Setup cell size and offset
    CGFloat frameSize = MIN(CGRectGetHeight(frame), CGRectGetWidth(frame));
    
    // 5 buttons, plus 2.5 cellSize reserved for borders
    CGFloat cellSize = frameSize/(5.0 + 2.5);
    
    // 6 Borders for 5 buttons
    CGFloat baseOffset = cellSize/(6.0);
    CGFloat yOffset = baseOffset;
    
    UIButton *levelButton;
    
    for (int row = 0; row < 9; ++row){
      // Set/reset xOffset for new column
      CGFloat xOffset = baseOffset;
      
      for (int col = 0; col < 9; ++col){
        
        // Set up frame and cell
        CGRect cellFrame = CGRectMake(xOffset, yOffset, cellSize, cellSize);
        levelButton = [[UIButton alloc] initWithFrame:cellFrame];

        [self addSubview: levelButton];
        
        // Create target for cell
        [levelButton addTarget:self action:@selector(levelSelected:)
              forControlEvents:UIControlEventTouchUpInside];
        levelButton.tag = (row * BUTTONS_PER_ROW) + col + 1;
        
        // Highlight color arbitrarily chosen for aesthetic pleasure
        // It's green
        if (levelButton.tag == 1){
          [levelButton setBackgroundColor:highlightBGColor];
        } else {
          [levelButton setBackgroundColor:regularBGColor];
        }
        
        [levelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        levelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        // Make the tag such that the first digit represents the row, and the
        // second represents the column
        levelButton.tag = (row * 10) + col;
        
        [[_levelButtons objectAtIndex:row] insertObject:levelButton atIndex:col];
        
        // Update column offset
        xOffset += cellSize + baseOffset;
      }
      
      // Update row offset
      yOffset += cellSize + baseOffset;
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

@end
