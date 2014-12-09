//
//  ShipSelectViewController.m
//  FractionBlaster
//
//  Created by Alejandro Mendoza on 12/4/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "ShipSelectViewController.h"

// Enum object for button tags
typedef enum {
    BlueShip,
    BrownShip,
    SilverShip,
    RedShip,
    StartTag,
    BackTag
} ButtonTags;

@implementation ShipSelectViewController
{
    ShipSelectView *_shipSelectView;
    NSArray *_operators;
    int _level;
}

// Function to relay information about level and operators to GameVC
- (id)initWithLevel:(int)level andOperators:(NSArray*)operators
{
    self = [super init];
    _level = level;
    _operators = operators;
    return self;
}

// Initialize the level ship select view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the view and delegate
    _shipSelectView = [[ShipSelectView alloc] initWithFrame:self.view.frame];
    [_shipSelectView setDelegate:self];
    [self.view addSubview: _shipSelectView];
}

// Function to perform action according to button selected
- (void)buttonSelected:(id)sender
{
    // Figure out which button was selected
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    
    switch (tag) {
        
        // Start game
        case StartTag:
        {
            [self launchSound];
            
            // Determine which ship was selected
            int shipNum = [_shipSelectView currentShipSelected];
            
            // Create the game
            GameViewController *gvc = [[GameViewController alloc]
                                           initWithLevel:_level
                                           andOperators:_operators
                                           andShipNumber:shipNum];
            [self.navigationController pushViewController:gvc animated:YES];
            break;
        }
            
        // Back button selected, move to previous screen
        case BackTag:
        {
            [self backSound];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        default:
        {
            [self shipSelectedSound];
            break;
        }
    }
}

// Play the sound to the select a ship
- (void)shipSelectedSound {
    NSError *error;
    NSURL *progressButton = [[NSBundle mainBundle] URLForResource:@"ship-select" withExtension:@"mp3"];
    self.shipSelectSound = [[AVAudioPlayer alloc] initWithContentsOfURL:progressButton error:&error];
    [self.shipSelectSound prepareToPlay];
    [self.shipSelectSound play];
}

// Play the sound to go to the previous screen
- (void)backSound {
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-09" withExtension:@"wav"];
    self.shipBackSound = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.shipBackSound prepareToPlay];
    [self.shipBackSound play];
}

// Play the sound to go to the next screen
- (void)launchSound
{
    NSError *error;
    NSURL *backButton = [[NSBundle mainBundle] URLForResource:@"button-3" withExtension:@"wav"];
    self.shipLaunch = [[AVAudioPlayer alloc] initWithContentsOfURL:backButton error:&error];
    [self.shipLaunch prepareToPlay];
    [self.shipLaunch play];
}

@end
