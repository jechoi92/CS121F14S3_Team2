//
//  LevelSelectViewController.m
//  FractionBlaster
//
//  Created by Laptop16 on 11/7/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "LevelSelectViewController.h"

// Enum object for button tags
typedef enum {
    StartTag,
    BackTag
}ButtonTags;

@implementation LevelSelectViewController
{
    LevelSelectView *_levelSelectView;
}

// Initialize the level seclect view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the subview
    _levelSelectView = [[LevelSelectView alloc] initWithFrame:self.view.frame andUnlockedLevel:[self readProgress]];
    [_levelSelectView setDelegate:self];
    [self.view addSubview: _levelSelectView];
}

- (void)buttonSelected:(id)sender
{
    // Figure out button navigation
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag){
            
        // Show ship selection screen
        case StartTag:
        {
            int currentLevel = [_levelSelectView currentLevelSelected] + 1;
            ShipSelectViewController *svc = [[ShipSelectViewController alloc]
                                       initWithLevel:currentLevel andOperators:NULL];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
            
        // Back button was pressed, show previous screen
        case BackTag:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

// Updates the Progress text file to save the progress of the player
// after the player closes and reopens the game
- (int)readProgress
{
    // Read the max. unlocked level stored in the progress file
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    return [content intValue];
}

@end
