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
    NSMutableArray *_initialFractions;
    NSTimer *_asteroidGenerationTimer;
    int _level;
    int _score;
}

- (id)initWithLevel:(int)level andOperators:(NSArray*)operators
{
    self = [super init];
    _level = level;
    if (operators == NULL) {
        operators = [self findOperators];
    }
    _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:0];
    return self;
}

// Function required to keep the SKScene from crashing the program.
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

- (void)initialize
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    SKView *skView = (SKView *)self.view;
    if (!skView.scene) {
        // Create all necessary data members.
        _initialFractions = [_equationGenerator getInitialFractions];
        [self createGameView];
        [self createSideBar];
        [self createHealthBar];
        [self createScene];
        
        // Timer that creates an asteroid every given time interval.
        _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                                    target:self
                                                                  selector:@selector(createAsteroid:)
                                                                  userInfo:nil
                                                                   repeats:YES];
        [_scene startLevelAnimation];
    }
    self.view.multipleTouchEnabled = YES;
}

// Creates the gameview.
- (void)createGameView
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect labelsAndButtonsFrame = CGRectMake(0, 0, width, height);
    
    _gameView= [[GameView alloc] initWithFrame:labelsAndButtonsFrame andLevel:_level andScore:_score];
    [_gameView setDelegate:self];
    [self.view addSubview:_gameView];
}

// Creates the sidebar.
- (void)createSideBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect sideBarFrame = CGRectMake(0,0,width,height);
    _sidebar = [[SideBarView alloc] initWithFrame:sideBarFrame];
    for (int i = 0; i < [_initialFractions count]; i++) {
        Fraction *toInsert = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:i]];
        [_sidebar setValueAtIndex:i withValue:toInsert];
    }
    
    [_sidebar setDelegate:self];
    [self.view addSubview:_sidebar];
}

// Creates the health bar.
- (void)createHealthBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect healthBarFrame = CGRectMake(width * 0.005, height * 0.55, width * 0.1, height * 0.42);
    _healthBar = [[HealthBarView alloc] initWithFrame:healthBarFrame];
    [self.view addSubview:_healthBar];
}

// Creates the scene.
- (void)createScene
{
    SKView *skView = (SKView *)self.view;
    _scene = [[GameScene alloc] initWithSize:skView.bounds.size andLevel:_level];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    [(GameScene*)_scene setDeli:self];
    [skView presentScene:_scene];
}


// Creates the appropriate GameOverScene upon the end of a game
-(void)createGameOverSceneWithWin:(BOOL)winning
{
    // First cleanup the data members.
    [self cleanup];
    
    // If we have won, then update game progress.
    if (winning) {
        _score += _level * 1000;
        [self updateProgress];
        
        // But if we have beaten the last level, then we load the final end view.
        if (_level == 10) {
            [self updateHighScores];
            [self createGameEndViewVictory];
            return;
        }
    }
    // If we have lost, then update highscores accordingly.
    else {
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
    [_healthBar setHealthLevel:([_healthBar getHealthLevel] - HEALTHPENALTY)];
    if ([_healthBar getHealthLevel] <= 0) {
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

// Function to get a random equation whose solution is not value.
- (Equation*)wrongAnswerAttempt:(Fraction*)value
{
    [self incrementScore:-50];
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
    [_asteroidGenerationTimer invalidate];
    CGFloat rate = _asteroidGenerationTimer.timeInterval;
    _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:rate * 0.98
                                                                target:self
                                                              selector:@selector(createAsteroid:)
                                                              userInfo:nil
                                                               repeats:YES];
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

// Updates the Progress text file to save the progress of the player
// after  the player closes and reopens the game
- (int)readProgress
{
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

// Writes the highest level beaten so that progress can be saved.
-(void)updateProgress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithFormat:@"%d", MAX([self readProgress],_level)];
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
}

// Function to update high scores, if any are changed.
-(void)updateHighScores
{
    NSArray* currentHighScores = [self loadHighScores];
    NSString* lowestScoreString = [currentHighScores objectAtIndex:4];
    int lowestScore = [self getScoreFromString:lowestScoreString];
    
    // If our score is greater than the lowest highscore, then first ask for username.
    if (_score > lowestScore) {
        [self requestUserName];
    }
}

-(int)getScoreFromString:(NSString*)scoreString
{
    return [[scoreString substringToIndex:7] intValue];
}

// Read highscores from text file, return array of 5 scores.
-(NSArray*) loadHighScores
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    // If there is no such text file, then set it by default.
    if (content == NULL) {
        content = @"0000000   \n0000000   \n0000000   \n0000000   \n0000000   \n";
    }
    NSMutableArray* scores = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Store into an array.
    for (int i = 0; i < 5; i++) {
        NSString* score = [content substringWithRange:NSMakeRange(11 * i, 10)];
        [scores addObject:score];
    }
    return [[NSArray alloc] initWithArray:scores];
}

// Prompts user for username, to store for highscore.
-(void)requestUserName
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"High Score!"
                                                    message:@"Enter your initials! (3 alphabets)"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

// Alertview function to prompt user for username.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* name = [alertView textFieldAtIndex:0].text;
    if ([name length] == 3) {
        [self writeScore:[name uppercaseString]];
    }
    // If user does not input a 3 character long string, then request again.
    else {
        [self requestUserName];
    }
}

// Writes the new highscore with the username.
-(void)writeScore: (NSString*)name
{
    NSMutableArray* currentHighScores = [[NSMutableArray alloc] initWithArray:[self loadHighScores]];
    NSString* scoreString = [NSString stringWithFormat:@"%007d", _score];
    NSString* scoreAndNameString = [[NSString alloc] initWithFormat:@"%@%@", scoreString, name];
    
    // Loop to insert the new high score in the array depending on its score.
    for (int i = 0; i < 5; i++) {
        NSString* currentScoreString = [currentHighScores objectAtIndex:i];
        if (_score > [self getScoreFromString:currentScoreString]) {
            [currentHighScores insertObject:scoreAndNameString atIndex:i];
            break;
        }
    }
    
    // Creates an output string from the array to write it onto a txt file.
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
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt",
                          documentsDirectory];
    [output writeToFile:fileName
             atomically:NO
               encoding:NSStringEncodingConversionAllowLossy
                  error:nil];
}

// Creates the gameEndView.
-(void)createGameEndView:(BOOL)win
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrame:gameEndViewFrame withLevel:_level andScore:_score andWin:win];
    [_gameEndView setDelegate:self];
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
}

// Creates the gameEndView when we have finished the game.
-(void)createGameEndViewVictory
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrameVictory:gameEndViewFrame];
    [_gameEndView setDelegate:self];
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
}

// Back button to main menu.
-(void)backToMainMenu
{
    [self cleanup];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Reload the gameVC with the next level if won, or a score of 0 if lost.
-(void)backToGameWithNextLevel:(BOOL)won
{
    if (won){
        ++_level;
    }
    else {
        _score = 0;
    }
    
    [_gameEndView removeFromSuperview];
    if (_level > 0) {
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:[self findOperators] andDenominatorLimit:12 andDifficulty:0];
    }
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

