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
    NSTimer* _asteroidGenerationTimer;
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
    
    // If survival mode, Equation Generator is created with the selected operators and hard difficulty
    if (_level == -1) {
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:2];
    }
    
    return self;
}

// Function required to keep the SKScene from crashing the program.
- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
}

// Function required to remake the VC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initialize];
}

// Initialization of data members
- (void)initialize
{
    // Play the background music
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"gameBGM" withExtension:@"mp3"];
    
    // If boss level (i.e. level 10), play a different track
    if (_level == 10) {
        backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"bossBGM" withExtension:@"mp3"];
    }
    
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        
        // Create all necessary data members
        // If campaign mode, create the Equation Generator by determining the operators and difficulty based on level
        if (_level > 0) {
            _equationGenerator = [[EquationGenerator alloc] initWithOperators:[self findOperators] andDenominatorLimit:12 andDifficulty:[self findDifficulty]];
        }
        
        _numAsteroid = [self findAsteroidsToDestroy:_level];
        _initialFractions = [_equationGenerator initialFractions];
        [self createGameView];
        [self createSideBar];
        [self createHealthBar];
        [self createScene];
        
        
        
        // If campaign mode and level is between 1 and 4, show tips screen
        if (_level > 0 && _level < 5){
            [self createTipView];
        }
        else {
            [self dismissTip];
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

// Creates the gameview
- (void)createGameView
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect labelsAndButtonsFrame = CGRectMake(0, 0, width, height);
    _gameView = [[GameView alloc] initWithFrame:labelsAndButtonsFrame andAsteroidCount:_numAsteroid andScore:_score];
    
    // Set the delegate appropriately
    [_gameView setDelegate:self];
    
    [self.view addSubview:_gameView];
}

// Creates the healthbar
- (void)createHealthBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect healthBarFrame = CGRectMake(width * 0.005, height * 0.56, width*0.1, height* 0.38);
    _healthBar = [[HealthBarView alloc] initWithFrame:healthBarFrame];
    
    [self.view addSubview:_healthBar];
}

// Creates the sidebar
- (void)createSideBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect sideBarFrame = CGRectMake(width * 0.875, height * 0.55, width*0.13, height* 0.42);
    _sidebar = [[SideBarView alloc] initWithFrame:sideBarFrame];
    
    // Set the labels on the buttons with the initial fractions
    for (int i = 0; i < [_initialFractions count]; i++) {
        Fraction *toInsert = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:i]];
        [_sidebar setValueAtIndex:i withValue:toInsert];
    }
    
    // Set the delegate appropriately
    [_sidebar setDelegate:self];
    
    [self.view addSubview:_sidebar];
}

// Creates the scene
- (void)createScene
{
    SKView *skView = (SKView *)self.view;
    _scene = [[GameScene alloc] initWithSize:skView.bounds.size andLevel:_level andShipNum:_shipNum];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Set the delegate appropriately
    [(GameScene*)_scene setDeli:self];
    
    [skView presentScene:_scene];
}


// Creates the appropriate ending scene upon the end of a game
-(void)createGameOverSceneWithWin:(BOOL)winning
{
    // First cleanup the data members.
    [self cleanup];
    
    // If we have won,
    if (winning) {
        
        // Play the victory sound effect
        NSError *error;
        NSURL *victorySoundURL = [[NSBundle mainBundle] URLForResource:@"victory_applause" withExtension:@"wav"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:victorySoundURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        
        // Increment score based on completion of a level
        _score += _level * 1000;
        
        // Update current progress
        [self updateProgress];
        
        // But if we have beaten the last level, then we load the final end view and update highscores
        if (_level == 10) {
            [self updateHighScores];
            [self createGameEndViewVictory];
            return;
        }
    }
    
    // If we have lost, then update highscores accordingly.
    else {
        
        // Play the defeat sound effect
        NSError *error;
        NSURL *defeatSoundURL = [[NSBundle mainBundle] URLForResource:@"defeat_explosion" withExtension:@"wav"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:defeatSoundURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = 0;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        
        // Update high scores
        [self updateHighScores];
        
        
    }
    
    // Load the end view.
    [self createGameEndView:winning];
}

// General cleanup of all data members.
- (void)cleanup
{
    [_backgroundMusicPlayer stop];
    [_asteroidGenerationTimer invalidate];
    [_sidebar removeFromSuperview];
    [_healthBar removeFromSuperview];
    [_gameView removeFromSuperview];
    SKView *skView = (SKView *)self.view;
    [skView presentScene:nil];
}

// Delegate handler for when scene indicates that the level is over
- (void)lastAsteroidDestroyed
{
  [self createGameOverSceneWithWin:YES];
}

// Decreases health level, and checks if health is equal to or lower than 0.
// If so, then game over.
- (void)asteroidReachedBottom
{
    [_healthBar setHealthLevel:([_healthBar healthLevel] - HEALTHPENALTY)];
    if ([_healthBar healthLevel] <= 0) {
        [self createGameOverSceneWithWin:NO];
    }
}

- (void)incrementScore:(int)value
{
    _score += value;
    if (_score < 0) {
        _score = 0;
    }
    [_gameView updateScore:_score];
}

// Update the asteroid label on the game view to reflect an increase in asteroids
// destroyed if on survival mode or decrement aateroids left to destroy if not
// on survival mode.
- (void)incrementAsteroid:(int)numAsteroid
{
    // If level = -1, we are on survival mode and we increment, otherwise
    // we decrement the asteroids to destroy.
    if (_level == -1) {
        _numAsteroid++;
    } else {
        _numAsteroid--;
    }
    [_gameView updateAsteroidCount:_numAsteroid];
}

// Returns the number of asteroids that must be destroyed in the given level
- (int)findAsteroidsToDestroy:(int)level
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

// Function to get a random equation whose solution is not value.
- (Equation*)wrongAnswerAttempt:(Fraction*)value
{
    // Decrement 100 points and get another random equation
    [self incrementScore:-100];
    Equation* randomEquation = [_equationGenerator generateRandomEquation];
    
    // Make sure that we end up with an equation whose solution doesn't match the failed answer attempt
    while ([[randomEquation getSolution] compare:value] == NSOrderedSame) {
        randomEquation = [_equationGenerator generateRandomEquation];
    }
    
    return randomEquation;
}

// Gets a random equation from the generator, and then creates an asteroid on the scene
// with that asteroid on it.
- (void)createAsteroid:(id)sender
{
    Equation* randomEquation = [_equationGenerator generateRandomEquation];
    [_scene createAsteroid: randomEquation];
    
    // The rate at which asteroids are being created are progressively increased by a factor
    [_asteroidGenerationTimer invalidate];
    CGFloat rate = _asteroidGenerationTimer.timeInterval;
    _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:rate * 0.997
                                        target:self selector:@selector(createAsteroid:)
                                        userInfo:nil repeats:YES];
}

// Gets the tag of the pressed button and then fires a laser on the scene with that laser value.
- (void)laserFrequencyChosen:(NSNumber*)buttonTag {
    int tag = [buttonTag intValue];
    Fraction* selected = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:tag]];
    [_scene fireLaser:selected fromButton:tag];
}

// Returns our array of operators depending on our current level.
- (NSArray*)findOperators
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

// Returns the difficulty of the Equation Generator depending on our current level.
- (int)findDifficulty
{
    if (_level < 5) {
        return 0;
    }
    else if (_level < 8) {
        return 1;
    }
    else {
        return 2;
    }
}

// Updates the Progress text file to save the progress of the player
// after  the player closes and reopens the game
- (int)readProgress
{
    // Read the contents of the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    return [content intValue];
}

// Writes the highest level beaten so that progress can be saved
-(void)updateProgress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt", documentsDirectory];
    
    // Determines the maximum unlocked level depending on the previous maximum unlocked level and the currently beaten level
    int maxUnlockedLevel = MAX([self readProgress], _level);
    NSString *content = [[NSString alloc] initWithFormat:@"%d", maxUnlockedLevel];
    [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

// Function to update high scores, if any are changed
-(void)updateHighScores
{
    NSArray* currentHighScores = [self loadHighScores];
    NSString* lowestScoreString = [currentHighScores objectAtIndex:4];
    int lowestScore = [self getScoreFromString:lowestScoreString];
    
    // If our score is greater than the lowest highscore, then highscores must be changed
    if (_score > lowestScore) {
        
        // Therefore ask for the username
        [self requestUserName];
    }
}

// Parses the integer score from the score string, a string that has the score and username of the highscores
-(int)getScoreFromString:(NSString*)scoreString
{
    return [[scoreString substringToIndex:7] intValue];
}

// Read highscores from text file, return array of 5 scores
-(NSArray*) loadHighScores
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    
    // If there is no such text file, then set it by default
    if (content == NULL) {
        content = @"0000000   \n0000000   \n0000000   \n0000000   \n0000000   \n";
    }
    
    NSMutableArray* scores = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Parse the scores and store into an array
    for (int i = 0; i < 5; i++) {
        NSString* score = [content substringWithRange:NSMakeRange(11 * i, 10)];
        [scores addObject:score];
    }
    
    return [[NSArray alloc] initWithArray:scores];
}

// Prompts user for username, to store for highscore
-(void)requestUserName
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"High Score!"
                                                    message:@"Enter your initials! (3 letters)"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

// Alertview function to prompt user for username
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* name = [alertView textFieldAtIndex:0].text;
    
    // If user input is exactly 3 characters long, proceed with writing score
    if ([name length] == 3) {
        [self writeScore:[name uppercaseString]];
    }
    // If user does not input a 3 character long string, then request again
    else {
        [self requestUserName];
    }
}

// Writes the new highscore with the username
-(void)writeScore: (NSString*)name
{
    // Gets the previously high scores
    NSMutableArray* currentHighScores = [[NSMutableArray alloc] initWithArray:[self loadHighScores]];

    // Creates a string that stores both the username and highscore
    NSString* scoreString = [NSString stringWithFormat:@"%007d", _score];
    NSString* scoreAndNameString = [[NSString alloc] initWithFormat:@"%@%@", scoreString, name];
    
    // Loop to insert the new high score in the array depending on its score.
    for (int i = 0; i < 5; i++) {
        NSString* currentScoreString = [currentHighScores objectAtIndex:i];
        
        // The new high score is inserted in place
        if (_score > [self getScoreFromString:currentScoreString]) {
            [currentHighScores insertObject:scoreAndNameString atIndex:i];
            break;
        }
    }
    
    // Creates an output string from the array with the top 5 highest highscores to write it onto a txt file for storing
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

// Creates the ending screen
-(void)createGameEndView:(BOOL)win
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrame:gameEndViewFrame withLevel:_level andScore:_score andWin:win];
    
    // Set the delegate appropriately
    [_gameEndView setDelegate:self];
    
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
}

// Creates the ending screen when we have finished campaign mode.
-(void)createGameEndViewVictory
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrameVictory:gameEndViewFrame];
    
    // Set the delegate appropriately
    [_gameEndView setDelegate:self];
    
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
}

// Function that dismisses the tip screen
-(void)dismissTip
{
    // Create timer upon dismissal of tip view
    [_tipView removeFromSuperview];
    [_scene startLevelAnimation];
    _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                        target:self selector:@selector(createAsteroid:)
                                        userInfo:nil repeats:YES];
}

// Back button to main menu
-(void)backToMainMenu
{
    [self cleanup];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Reload the gameVC with the next level if won, or a score of 0 if lost.
-(void)backToGameWithNextLevel:(BOOL)won
{
    // If won, increment level
    if (won){
        ++_level;
    }
    
    // Else, reset the score
    else {
        _score = 0;
    }
    
    [_gameEndView removeFromSuperview];
    
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

