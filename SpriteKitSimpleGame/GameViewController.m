//
//  ViewController.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "GameViewController.h"
#import "MyScene.h"

@import AVFoundation;

@interface GameViewController (){
  SKView *_gameView;
}
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation GameViewController

- (void)viewWillLayoutSubviews
{
  NSError *error;
  NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
  self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
  self.backgroundMusicPlayer.numberOfLoops = -1;
  [self.backgroundMusicPlayer prepareToPlay];
  //[self.backgroundMusicPlayer play];
  
  [self createHealthBar];
  [self createSideBar];
  
  // Configure the view.
  _gameView = (SKView *)self.view;
  if (!_gameView.scene) {
    _gameView.showsFPS = YES;
    _gameView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:_gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [_gameView presentScene:scene];
  }
}

- (void)createHealthBar
{

}

- (void)createSideBar
{
    
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
