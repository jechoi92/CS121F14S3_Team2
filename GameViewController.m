//
//  GameViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>

int TOTAL_INITIAL_FRACTIONS = 5;
int HEALTHPENALTY = 100;
CGFloat INSET_RATIO = 0.02;

@implementation GameViewController
{
    HealthBarView* _healthBar;
    SideBarView* _sidebar;
    GameScene* _scene;
    EquationGenerator* _equationGenerator;
    GameView* _gameView;
    GameEndView* _gameEndView;
    NSMutableArray* _initialFractions;
    NSTimer* _asteroidGenerationTimer;
    int _level;
    int _score;
}

-(id)initWithLevel:(int)level andScore:(int)score
{
    self = [super init];
    _level = level;
    _score = score;
    return self;
}

- (void)loadView {
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
    
    
    // TO DO will create an array of operators that the user selects.
    NSArray* operators = [self findOperators];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:0];
        _initialFractions = [_equationGenerator getInitialFractions];
        [self createLabelsAndButtons];
        [self createSideBar];
        [self createHealthBar];
        [self createScene];
        
        
        // Timer that creates an asteroid every given time interval.
        _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:7.0
                                                                    target:self
                                                                  selector:@selector(createAsteroid:)
                                                                  userInfo:nil
                                                                   repeats:YES];
    }
}


- (void)createLabelsAndButtons
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect labelsAndButtonsFrame = CGRectMake(0, 0, width, height);
    
    
    _gameView= [[GameView alloc] initWithFrame:labelsAndButtonsFrame andLevel:_level];
    [self.view addSubview:_gameView];
}

// Creates the sidebar.
- (void)createSideBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGRect sideBarFrame = CGRectMake(width * 0.90, height * 0.58, width  * 0.095, height * 0.35);
    
    _sidebar = [[SideBarView alloc] initWithFrame:sideBarFrame];
    
    for (int i = 0; i < [_initialFractions count]; i++) {
        Fraction *toInsert = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:i]];
        [_sidebar setValueAtIndex:i withValue:toInsert];
    }
    
    [_sidebar setDelegate:self];
    [self.view addSubview:_sidebar];
}


// Creates the scene.
- (void)createScene
{
    SKView * skView = (SKView *)self.view;
    
    //_scene = [GameScene sceneWithSize:skView.bounds.size];
    _scene = [[GameScene alloc] initWithSize:skView.bounds.size andLevel:_level];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [_scene setDelegate:self];
    [skView presentScene:_scene];
}

// Creates the health bar.
- (void)createHealthBar
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame) * 0.05;
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect healthBarFrame = CGRectMake(width * 0.1, height * 0.48, width, height * 0.45);
    
    
    _healthBar = [[HealthBarView alloc] initWithFrame:healthBarFrame];
    [self.view addSubview:_healthBar];
}


// Creates the appropriate GameOverScene upon the end of a game
-(void)createGameOverSceneWithWin:(BOOL)winning
{
    [self cleanup];
    [self createGameEndView:winning];
    
    if (winning) {
        [self updateProgress];
    }
    else {
        [self updateHighScores];
    }
}

-(void)cleanup
{
    [_asteroidGenerationTimer invalidate];
    [_sidebar removeFromSuperview];
    [_healthBar removeFromSuperview];
    [_gameView removeFromSuperview];
    SKView* skView = (SKView *)self.view;
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
    [_gameView updateScore:_score];
}

// Gets a random equation from the generator, and then creates an asteroid on the scene
// with that asteroid on it.
- (void)createAsteroid:(id)sender
{
    Equation* randomEquation = [_equationGenerator generateRandomEquation];
    [_scene createAsteroid: randomEquation];
    [_asteroidGenerationTimer invalidate];
    CGFloat rate = _asteroidGenerationTimer.timeInterval;
    _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:rate * 0.99
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

- (NSArray*)findOperators
{
    NSMutableArray* operators = [[NSMutableArray alloc] initWithCapacity:1];
    if (_level == 1 || _level == 8 || _level == 9) {
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
    
    if (_level == 10) {
        [operators addObject:@"$"];
        [operators addObject:@"+"];
        [operators addObject:@"-"];
        [operators addObject:@"/"];
        [operators addObject:@"*"];
    }
    
    return operators;
}



-(void)updateProgress
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Progress.txt",
                          documentsDirectory];
    //create content - four lines of text
    NSString *content = [[NSString alloc] initWithFormat:@"%d", _level];
    //save content to the documents directory
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
}

-(void)updateHighScores
{
    NSArray* currentHighScores = [self loadHighScores];
    NSString* lowestScoreString = [currentHighScores objectAtIndex:4];
    int lowestScore = [self getScoreFromString:lowestScoreString];
    
    if (_score > lowestScore) {
        [self requestUserName];
    }
}

-(int)getScoreFromString:(NSString*)scoreString
{
    return [[scoreString substringToIndex:7] intValue];
}

-(NSArray*) loadHighScores
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fileName = [NSString stringWithFormat:@"%@/HighScores.txt",
                          documentsDirectory];
    NSString* content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    if (content == NULL) {
        content = @"0000000   \n0000000   \n0000000   \n0000000   \n0000000   \n";
    }
    
    NSMutableArray* scores = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0; i < 5; i++) {
        NSString* score = [content substringWithRange:NSMakeRange(11 * i, 10)];
        [scores addObject:score];
    }
    
    return [[NSArray alloc] initWithArray:scores];
}

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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* name = [alertView textFieldAtIndex:0].text;
    if ([name length] == 3) {
        [self writeScore:[name uppercaseString]];
    }
    else {
        [self requestUserName];
    }
}

-(void)writeScore: (NSString*)name
{
    NSMutableArray* currentHighScores = [[NSMutableArray alloc] initWithArray:[self loadHighScores]];
    NSString* scoreString = [NSString stringWithFormat:@"%007d", _score];
    NSString* scoreAndNameString = [[NSString alloc] initWithFormat:@"%@%@", scoreString, name];
    
    for (int i = 0; i < 5; i++) {
        NSString* currentScoreString = [currentHighScores objectAtIndex:i];
        if (_score > [self getScoreFromString:currentScoreString]) {
            [currentHighScores insertObject:scoreAndNameString atIndex:i];
            break;
        }
    }
    
    NSMutableString* output = [[NSMutableString alloc] initWithString:@""];
    for (int j = 0; j < 5; j++) {
        NSString* scoreString = [currentHighScores objectAtIndex:j];
        [output appendString:scoreString];
        [output appendString:@"\n"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/HighScores.txt",
                          documentsDirectory];
    //save content to the documents directory
    [output writeToFile:fileName
             atomically:NO
               encoding:NSStringEncodingConversionAllowLossy
                  error:nil];
}

-(void)createGameEndView:(BOOL)win
{
    CGRect frame = self.view.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect gameEndViewFrame = CGRectMake(0, 0, width, height);
    _gameEndView = [[GameEndView alloc] initWithFrame:gameEndViewFrame andWin:win];
    [self.view addSubview:_gameEndView];
    [self.view sendSubviewToBack:_gameView];
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
    // Release any cached data, images, etc that aren't in use.
}

@end

