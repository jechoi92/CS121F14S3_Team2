//
//  GameViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameViewController.h"
#import <QuartzCore/QuartzCore.h>
@import AVFoundation;

@interface GameViewController ()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

int TOTAL_INITIAL_FRACTIONS = 5;
int HEALTHPENALTY = 20;
CGFloat INSET_RATIO = 0.02;

@implementation GameViewController
{
    HealthBarView* _healthBar;
    SideBarView* _sidebar;
    GameScene* _scene;
    EquationGenerator* _equationGenerator;
    NSMutableArray* _initialFractions;
    NSTimer* _asteroidGenerationTimer;
    int _level;
    int _score;
    UIButton* _backButton;
    UILabel* _levelLabel;
    UILabel* _levelValueLabel;
    UILabel* _scoreLabel;
    UILabel* _scoreValueLabel;
    UILabel* _fireLabel;
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


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSError *error;
    //NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    //self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
  //  self.backgroundMusicPlayer.numberOfLoops = -1;
   // [self.backgroundMusicPlayer prepareToPlay];
   // [self.backgroundMusicPlayer play];
    
    
    
    // TO DO will create an array of operators that the user selects.
    NSArray* operators = [self findOperators];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:0];
        _initialFractions = [_equationGenerator getInitialFractions];
        [self createSideBar];
        [self createHealthBar];
        [self createScene];
        [self createTopButtonsAndLabels];
        
        // Timer that creates an asteroid every given time interval.
        _asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:6.0
                                                                    target:self
                                                                  selector:@selector(createAsteroid:)
                                                                  userInfo:nil
                                                                   repeats:YES];
    }
}


- (void)createTopButtonsAndLabels
{
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    CGFloat itemWidth = size / 15;
    CGFloat itemY = CGRectGetHeight(frame) * INSET_RATIO * 0.3;
    
    CGFloat backButtonLength = itemWidth;
    CGFloat backButtonWidth = itemWidth;
    CGFloat backButtonX = CGRectGetWidth(frame) * INSET_RATIO;
    CGFloat backButtonY = CGRectGetHeight(frame) * INSET_RATIO;
    CGRect backButtonFrame = CGRectMake(backButtonX, backButtonY, backButtonLength, backButtonWidth);
    
    _backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [_backButton setBackgroundColor:[UIColor yellowColor]];
    [[_backButton layer] setBorderWidth:2.5f];
    [[_backButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_backButton layer] setCornerRadius:12.0f];
    
    // TODO delegate pop whatever.
    
    [self.view addSubview:_backButton];
    
    CGFloat levelLabelLength = itemWidth * 2;
    CGFloat levelLabelWidth = itemWidth;
    CGFloat levelLabelX = CGRectGetWidth(frame) * 0.45;
    CGFloat levelLabelY = itemY;
    CGRect levelLabelFrame = CGRectMake(levelLabelX, levelLabelY, levelLabelLength, levelLabelWidth);
    
    _levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
    
    [_levelLabel setText:@"Level"];
    [_levelLabel setTextColor:[UIColor whiteColor]];
    [_levelLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    
    [self.view addSubview:_levelLabel];
    
    CGFloat levelValueLabelLength = itemWidth * 2;
    CGFloat levelValueLabelWidth = itemWidth;
    CGFloat levelValueLabelX = CGRectGetWidth(frame) * 0.52;
    CGFloat levelValueLabelY = itemY;
    CGRect levelValueLabelFrame = CGRectMake(levelValueLabelX, levelValueLabelY, levelValueLabelLength, levelValueLabelWidth);
    
    _levelValueLabel = [[UILabel alloc] initWithFrame:levelValueLabelFrame];
    
    [_levelValueLabel setText:[NSString stringWithFormat:@"%i", _level]];
    [_levelValueLabel setTextColor:[UIColor whiteColor]];
    [_levelValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    
    [self.view addSubview:_levelValueLabel];
    
    
    CGFloat scoreLabelLength = itemWidth * 2;
    CGFloat scoreLabelWidth = itemWidth;
    CGFloat scoreLabelX = CGRectGetWidth(frame) * 0.83;
    CGFloat scoreLabelY = itemY;
    CGRect scoreLabelFrame = CGRectMake(scoreLabelX, scoreLabelY, scoreLabelLength, scoreLabelWidth);
    
    _scoreLabel = [[UILabel alloc] initWithFrame:scoreLabelFrame];
    
    [_scoreLabel setText:@"Score"];
    [_scoreLabel setTextColor:[UIColor whiteColor]];
    [_scoreLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    
    [self.view addSubview:_scoreLabel];
    
    CGFloat scoreValueLabelLength = itemWidth * 2;
    CGFloat scoreValueLabelWidth = itemWidth;
    CGFloat scoreValueLabelX = CGRectGetWidth(frame) * 0.90;
    CGFloat scoreValueLabelY = itemY;
    CGRect scoreValueLabelFrame = CGRectMake(scoreValueLabelX, scoreValueLabelY, scoreValueLabelLength, scoreValueLabelWidth);
    
    _scoreValueLabel = [[UILabel alloc] initWithFrame:scoreValueLabelFrame];
    
    [_scoreValueLabel setText:[[NSString alloc] initWithFormat:@"%d", _score]];
    [_scoreValueLabel setTextColor:[UIColor whiteColor]];
    [_scoreValueLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    
    [self.view addSubview:_scoreValueLabel];
    
    
    
    
    
    
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
    
    CGRect fireLabelFrame = CGRectMake(width * 0.91, height * 0.55, width  * 0.09, height * 0.03);
    
    _fireLabel = [[UILabel alloc] initWithFrame:fireLabelFrame];
    
    [_fireLabel setText:@"Fire!"];
    [_fireLabel setTextColor:[UIColor whiteColor]];
    [_fireLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    
    [self.view addSubview:_fireLabel];
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

-(void)createGameOverScene
{
    SKView * skView = (SKView *)self.view;
    _scene = [GameScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:_scene];
    GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:_scene.size won:NO];
    [skView presentScene:gameOverScene];
}

// Decreases health level, and checks if health is equal to or lower than 0.
// If so, then game over.
- (void)asteroidReachedBottom
{
    [_healthBar setHealthLevel:([_healthBar getHealthLevel] - HEALTHPENALTY)];
    if ([_healthBar getHealthLevel] <= 0) {
        SKView * skView = (SKView *)self.view;
        _scene = [GameScene sceneWithSize:skView.bounds.size];
        _scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [_asteroidGenerationTimer invalidate];
        
        // Present the scene.
        [skView presentScene:_scene];
        GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:_scene.size won:NO];
        [skView presentScene:gameOverScene];
        
        //      SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        //      _scene = [[MyScene alloc] initWithSize:_scene.size];
        //      [skView presentScene:_scene transition: reveal];
        
    }
}

- (void)incrementScore:(int)value
{
    _score += value;
    [_scoreValueLabel setText:[[NSString alloc] initWithFormat:@"%d", _score]];
}

// Gets a random equation from the generator, and then creates an asteroid on the scene
// with that asteroid on it.
- (void)createAsteroid:(id)sender
{
    Equation* randomEquation = [_equationGenerator generateRandomEquation];
    [_scene createAsteroid: randomEquation];
    
    CGFloat rate = _asteroidGenerationTimer.timeInterval;
    [_asteroidGenerationTimer invalidate];
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
        [operators addObject:@"$"];
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

