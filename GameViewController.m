//
//  GameViewController.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameViewController.h"

@import AVFoundation;

@interface GameViewController ()
//@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

int HEALTHPENALTY = 20;

@implementation GameViewController
{
    HealthBarView* _healthBar;
    SideBarView* _sidebar;
    GameScene* _scene;
    EquationGenerator* _equationGenerator;
    NSMutableArray* _initialFractions;
    NSTimer* asteroidGenerationTimer;
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

    //NSError *error;
    //NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    //self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    //self.backgroundMusicPlayer.numberOfLoops = -1;
    //[self.backgroundMusicPlayer prepareToPlay];
    //[self.backgroundMusicPlayer play];
    
    // TO DO will create an array of operators that the user selects.
    NSMutableArray* operators = [[NSMutableArray alloc] initWithCapacity:1];
    [operators addObject:@"$"];
    [operators addObject:@"+"];
    [operators addObject:@"-"];
    [operators addObject:@"*"];
    [operators addObject:@"/"];
    
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        _equationGenerator = [[EquationGenerator alloc] initWithOperators:operators andDenominatorLimit:12 andDifficulty:0];
        _initialFractions = [_equationGenerator getInitialFractions];
        [self createSideBar];
        [self createHealthBar];
        [self createScene];
        
        // Timer that creates an asteroid every given time interval.
        asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:8.0
                                                                   target:self
                                                                 selector:@selector(createAsteroid:)
                                                                 userInfo:nil
                                                                  repeats:YES];
    }
}


// Creates the sidebar.
- (void)createSideBar
{
    CGFloat x = CGRectGetWidth(self.view.frame);
    CGFloat y = CGRectGetHeight(self.view.frame);
    
    UIView *fracContainer = [[UIView alloc] initWithFrame:CGRectMake(x*.90,y*.79,x*0.1,y*0.33)];
    _sidebar = [[SideBarView alloc] initWithFrame:fracContainer.frame];
    
    for (int i = 0; i < 4; i++) {
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
    
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [GameScene sceneWithSize:skView.bounds.size];
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
    
    CGRect healthBarFrame = CGRectMake(width * 0.1, height * 0.48, width, height * 0.49);
    
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
        
        // Present the scene.
        [skView presentScene:_scene];
        GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:_scene.size won:NO];
        [skView presentScene:gameOverScene];
        
        //      SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        //      _scene = [[MyScene alloc] initWithSize:_scene.size];
        //      [skView presentScene:_scene transition: reveal];
        
    }
}

// Gets a random equation from the generator, and then creates an asteroid on the scene
// with that asteroid on it.
- (void)createAsteroid:(id)sender
{
    Equation* randomEquation = [_equationGenerator generateRandomEquation];
    [_scene createAsteroid: randomEquation];
    
    CGFloat rate = asteroidGenerationTimer.timeInterval;
    [asteroidGenerationTimer invalidate];
    asteroidGenerationTimer = [NSTimer scheduledTimerWithTimeInterval:rate * 0.99
                                                               target:self
                                                             selector:@selector(createAsteroid:)
                                                             userInfo:nil
                                                              repeats:YES];
}

// Gets the tag of the pressed button and then fires a laser on the scene with that laser value.
- (void)laserFrequencyChosen:(NSNumber*)buttonTag {
    int tag = [buttonTag intValue];
    Fraction* selected = [[Fraction alloc] initWithFraction:[_initialFractions objectAtIndex:tag]];
    [_scene fireLaser:selected];
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

