//
//  GameViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameViewController.h"

int TOTAL_INITIAL_FRACTIONS = 5;
int HEALTHPENALTY = 20;
CGFloat INSET_RATIO = 0.02;

// Enum object for difficulty
typedef enum {
    Easy,
    Medium,
    Hard
}DifficultyLevel;

@implementation GameViewController
{
    HealthBarView *_healthBar;
    SideBarView *_sidebar;
    GameScene *_scene;
    EquationGenerator *_equationGenerator;
    GameView *_gameView;
    GameEndView *_gameEndView;
    TipView *_tipView;
    NSMutableArray *_initialFractions;
    NSTimer *_asteroidGenerationTimer;
    int _level;
    int _score;
    int _numAsteroid;
    int _shipNum;
}

- (id)initWithLevel:(int)level andOperators:(NSArray*)operators andShipNumber:(int)shipNum
{
    self = [super init];
    _level = level;
    _shipNum = shipNum;
    
    // If survival mode, create EquationGenerator according to specified operators and medium difficulty
    if (_level == -1) {
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:Medium];
    }
    
    // Else, determine operators and difficulty according to level
    else {
        operators = [self determineOperators];
        int difficulty = [self determineDifficulty];
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:difficulty];
    }
    
    return self;
}

// Function required to keep the SKScene from crashing the program
- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initialize];
}

// Initialization function
- (void)initialize
{
    // Create background music to play indeterminately
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    //[self.backgroundMusicPlayer play];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        
        // Create all necessary data members
        _numAsteroid = [self determineAsteroidsToDestroy:_level];
        _initialFractions = [_equationGenerator getInitialFractions];
        
        [self createGameView];
        [self createSideBar];
        [self createHealthBar];
        [self createScene];
        
        if (_level < 5){
            [self createTipView];
        }
    }
}

// Creates the tip view
- (void)createTipView
{
    // Frame constants
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);
    CGFloat ratioOfScreen = 0.70;
    
    // Frame dimensions
    CGFloat tipWidth = ratioOfScreen * frameWidth;
    CGFloat tipHeight = ratioOfScreen * frameHeight;
    CGFloat tipXOff = (frameWidth - tipWidth) / 2;
    CGFloat tipYOff = (frameHeight - tipHeight) / 2;
    
    // Set up frame and view
    CGRect tipViewFrame = CGRectMake(tipXOff, tipYOff, tipWidth, tipHeight);
    _tipView = [[TipView alloc] initWithFrame:tipViewFrame andLevel:_level];
    
    // Set delegate
    [_tipView setDelegate:self];
    
    // Add subview
    [self.view addSubview:_tipView];
}

// Creates the gameview.
- (void)createGameView
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect gameViewFrame = CGRectMake(0, 0, width, height);
    
    // Create gameview with the number of asteroids to destroy and current score
    _gameView = [[GameView alloc] initWithFrame:gameViewFrame andAsteroidCount:_numAsteroid andScore:_score];
    
    // Set the delegate appropriately
    [_gameView setDelegate:self];
    
    [self.view addSubview:_gameView];
}

// Create the healthbar
- (void)createHealthBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect healthBarFrame = CGRectMake(width * 0.005, height * 0.56, width*0.1, height* 0.38);
    _healthBar = [[HealthBarView alloc] initWithFrame:healthBarFrame];
    
    [self.view addSubview:_healthBar];
}

// Create the sidebar
- (void)createSideBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect sideBarFrame = CGRectMake(width * 0.875, height * 0.55, width*0.13, height* 0.42);
    _sidebar = [[SideBarView alloc] initWithFrame:sideBarFrame];
    
    // Set each fraction in the buttons
    for (int i = 0; i < [_initialFractions count]; i++) {
        Fraction *toInsert = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:i]];
        [_sidebar setValueAtIndex:i withValue:toInsert];
    }
    
    // Set the delegate appropriately
    [_sidebar setDelegate:self];
    
    [self.view addSubview:_sidebar];
}

// Create the scene
- (void)createScene
{
    SKView *skView = (SKView *)self.view;
    
    // Create the scene with the appropriate data
    _scene = [[GameScene alloc] initWithSize:skView.bounds.size andLevel:_level andShipNum:_shipNum];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Set delegate appropriately
    [(GameScene*)_scene setDeli:self];
    [skView presentScene:_scene];
}


// Creates the appropriate screen upon the end of a game
-(void)createGameOverSceneWithWin:(BOOL)winning
{
    // First cleanup all data members
    [self cleanup];
    
    // If we have won
    if (winning) {
        
        // Play victory sound effect
        NSError *error;
        NSURL *defeatSoundURL = [[NSBundle mainBundle] URLForResource:@"victory_applause" withExtension:@"wav"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:defeatSoundURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        
        // Increment score for completion of a level
        _score += _level * 1000;
        
        // Update current progress
        [self updateProgress];
        
        // If we have beaten the last level, then we load the final end view
        if (_level == 10) {
            [self createGameEndViewVictory];
            
            // Update high scores
            [self updateHighScores];
            return;
        }
    }
    
    // If we have lost
    else {
        
        // Play defeat sound effect
        NSError *error;
        NSURL *defeatSoundURL = [[NSBundle mainBundle] URLForResource:@"defeat_explosion" withExtension:@"wav"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:defeatSoundURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        
        // Update high cores
        [self updateHighScores];
    }
    
    // Create the ending screen
    [self createGameEndView:winning];
}

// Function that performs a cleanup of all data members
- (void)cleanup
{
    [_backgroundMusicPlayer stop];
    [_asteroidGenerationTimer invalidate];
    [_sidebar removeFromSuperview];
    [_healthBar removeFromSuperview];
    [_gameView removeFromSuperview];
    [(SKView *)self.view presentScene:nil];
}

// Function to handle case when the scene indicates that the level is over
- (void)lastAsteroidDestroyed
{
  [self createGameOverSceneWithWin:YES];
}

// Function to handle case when the scene indicates that an asteroid has reached the bottom of the screen
- (void)asteroidReachedBottom
{
    // First decrease health level
    [_healthBar setHealthLevel:([_healthBar getHealthLevel] - HEALTHPENALTY)];
    
    // If current health level is below 0, then game over
    if ([_healthBar getHealthLevel] <= 0) {
        [self createGameOverSceneWithWin:NO];
    }
}

// Function to handle case when the scene indicates that the score has changed
- (void)incrementScore:(int)value
{
    // First increment score
    _score += value;
    
    // If the score happens to go below 0, reset it back to 0
    if (_score < 0) {
        _score = 0;
    }
    [_gameView updateScore:_score];
}

// Function to handle case when the scene indicates that the number of asteroids has changed
- (void)incrementAsteroid:(int)numAsteroid
{
    // If survival mode
    if (_level == -1) {
        
        // Increment number of asteroids
        _numAsteroid++;
    }
    
    // If campaign mode
    else {
        
        // Decrement number of asteroids
        _numAsteroid--;
    }
    
    // Update asteroid count on the view
    [_gameView updateAsteroidCount:_numAsteroid];
}

// Returns the number of asteroids that must be destroyed in the given level
- (int)determineAsteroidsToDestroy:(int)level
{
    if (level < 0) {
        return 0;
    }
    else if (level < 2) {
        return 10;
    }
    else if (level < 5) {
        return 12;
    }
    else if (level < 8) {
        return 16;
    }
    else if (level < 9) {
        return 20;
    }
    else {
        return 25;
    }
}

// Function to handle the case when a wrong answer has been attempted too many times (i.e. 3 times)
- (Equation*)wrongAnswerAttempt:(Fraction*)value
{
    // Decrement score by 100
    [self incrementScore:-100];
    
    // Get a random equation
    Equation *randomEquation = [_equationGenerator generateRandomEquation];
    
    // Make sure that we end up with an equation whose solution doesn't match the failed answer attempt
    while ([[randomEquation getSolution] compare:value] == NSOrderedSame) {
        randomEquation = [_equationGenerator generateRandomEquation];
    }
    
    return randomEquation;
}

// Create an asteroid for the scene and update the asteroid generation timer
- (void)createAsteroid
{
    // Get an equation from the equation generator and create an asteroid on the scene with this
    Equation *randomEquation = [_equationGenerator generateRandomEquation];
    [_scene createAsteroid: randomEquation];
    
    // Recreate the asteroid generation timer so that asteroids are being generated faster progressively
    [_asteroidGenerationTimer invalidate];
    CGFloat rate = _asteroidGenerationTimer.timeInterval;
    _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:rate * 0.99
                                        target:self selector:@selector(createAsteroid)
                                        userInfo:nil repeats:YES];
}

// Fires a laser with a selected fraction
- (void)laserFrequencyChosen:(NSNumber*)buttonTag {
    // Gets the fraction of the pressed button on the sidebar
    int tag = [buttonTag intValue];
    Fraction* selected = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:tag]];
    
    // Fires a laser with this fraction
    [_scene fireLaser:selected fromButton:tag];
}

// Function that returns an array of operators depending on current level
- (NSArray*)determineOperators
{
    NSMutableArray* operators = [[NSMutableArray alloc] initWithCapacity:1];
    if (_level == 1 || _level == 5 || _level == 8 || _level == 9) {
        [operators addObject:@"$"];
    }
    if (_level == 4 || _level == 7 || _level == 8 || _level == 9) {
        [operators addObject:@"+"];
        [operators addObject:@"-"];
    }
    if (_level == 2 || _level == 6 || _level == 8 || _level == 9) {
        [operators addObject:@"*"];
    }
    if (_level == 3 || _level == 6 || _level == 8 || _level == 9) {
        [operators addObject:@"/"];
    }
    
    // TODO: Implement boss level for lvl 5 and 10!
    if (_level == 10) {
        [operators addObject:@"$"];
        [operators addObject:@"+"];
        [operators addObject:@"-"];
        [operators addObject:@"/"];
        [operators addObject:@"*"];
    }
    
    return operators;
}

// Function that returns an int specifying the difficulty depending on current level
- (int)determineDifficulty
{
    if (_level < 5) {
        return Easy;
    }
    else if (_level < 8) {
        return Medium;
    }
    else {
        return Hard;
    }
}

// Update the Progress text file to save the progress of the player
- (int)readProgress
{
    // Reads the max. unlocked level from the progress file
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    return [content intValue];
}

// Write the highest level beaten so that progress can be saved
-(void)updateProgress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt", documentsDirectory];
    
    // Write the larger value between the current level beaten and the previously max. unlocked level
    int prevUnlockedLevel = [self readProgress];
    NSString *content = [[NSString alloc] initWithFormat:@"%d", MAX(prevUnlockedLevel,_level)];
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

// Function to update high scores, if any are changed
-(void)updateHighScores
{
    NSArray* currentHighScores = [self loadHighScores];
    NSString* lowestScoreString = [currentHighScores objectAtIndex:4];
    int lowestScore = [self getScoreFromString:lowestScoreString];
    
    // If our score is greater than the lowest highscore, then update high scores
    if (_score > lowestScore) {
        // First request username
        [self requestUserName];
    }
}

// Parse the score from a score string (i.e. string that contains score and username)
-(int)getScoreFromString:(NSString*)scoreString
{
    return [[scoreString substringToIndex:7] intValue];
}

// Read highscores from text file, return array of 5 scores.
-(NSArray*) loadHighScores
{
    // Read in the string
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    // If there is no such text file, then set it by default.
    if (content == NULL) {
        content = @"0000000   \n0000000   \n0000000   \n0000000   \n0000000   \n";
    }
    NSMutableArray* scores = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Parse the entire string and store the separate strings into an array to return
    for (int i = 0; i < 5; i++) {
        NSString* score = [content substringWithRange:NSMakeRange(11 * i, 10)];
        [scores addObject:score];
    }
    
    return [[NSArray alloc] initWithArray:scores];
}

// Prompts user for username to store for highscore
-(void)requestUserName
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"High Score!"
                            message:@"Enter your initials! (3 alphabets)" delegate:self
                            cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

// Alertview function to prompt user for username.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* name = [alertView textFieldAtIndex:0].text;
    
    // If the user input is 3 characters long, then write it
    if ([name length] == 3) {
        [self writeScore:[name uppercaseString]];
    }
    // If not, then request again
    else {
        [self requestUserName];
    }
}

// Writes the new highscore with the username.
-(void)writeScore: (NSString*)name
{
    // Get all previous high scores
    NSMutableArray* currentHighScores = [[NSMutableArray alloc] initWithArray:[self loadHighScores]];
    
    // Create the string in the necessary format for storing
    NSString* scoreString = [NSString stringWithFormat:@"%007d", _score];
    NSString* scoreAndNameString = [[NSString alloc] initWithFormat:@"%@%@", scoreString, name];
    
    // Loop to insert the new high score in the array depending on its score.
    for (int i = 0; i < 5; i++) {
        NSString* currentScoreString = [currentHighScores objectAtIndex:i];
        
        // If the new score is larger, then insert it
        if (_score > [self getScoreFromString:currentScoreString]) {
            [currentHighScores insertObject:scoreAndNameString atIndex:i];
            break;
        }
    }
    
    // Creates an output string from the array by taking the 5 highest scores to write it onto a txt file.
    NSMutableString* output = [[NSMutableString alloc] initWithString:@""];
    for (int j = 0; j < 5; j++) {
        NSString* scoreString = [currentHighScores objectAtIndex:j];
        [output appendString:scoreString];
        [output appendString:@"\n"];
    }
    
    // Write the string onto the file destination.
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt", documentsDirectory];
    [output writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

// Creates the game end screen
-(void)createGameEndView:(BOOL)win
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrame:gameEndViewFrame withLevel:_level andScore:_score andWin:win];
    
    // Set delegate appropriately
    [_gameEndView setDelegate:self];
    
    // Bring the game end screen to the front
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
}

// Creates the game end screen when we have beat the game (i.e. lvl 10)
-(void)createGameEndViewVictory
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrameVictory:gameEndViewFrame];
    
    // Set delegate appropriately
    [_gameEndView setDelegate:self];
    
    // Bring the game end screen to the front
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
}

-(void)dismissTip
{
    // Create timer upon dismissal of tip view
    [_tipView removeFromSuperview];
    [_scene startLevelAnimation];
    _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                                target:self
                                                              selector:@selector(createAsteroid:)
                                                              userInfo:nil
                                                               repeats:YES];
}

// Back button to main menu.
-(void)backToMainMenu
{
    [self cleanup];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Function to reload the gameVC
-(void)backToGameWithNextLevel:(BOOL)won
{
    // If the user has won
    if (won){
        
        // Increment the level
        ++_level;
    }
    
    // If the user has lost and is trying again
    else {
        
        // Reset the score to 0
        _score = 0;
    }
    
    [_gameEndView removeFromSuperview];
    
    // Run the initialization process again
    [self initialize];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

