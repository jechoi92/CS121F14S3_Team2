//
//  GameScene.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "Projectile.h"

static const uint32_t laserCategory     =  0x1 << 0;
static const uint32_t asteroidCategory  =  0x1 << 1;

// TODO make a spritenode that represents the surface of the earth for asteroid collisions?

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* player;
//@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
//@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int asteroidsDestroyed;
@end

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        [self.player setScale:0.3];
        self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.width/2);
        [self addChild:self.player];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void) createAsteroid: (Equation*) equation {
    NSString* text = [equation toString];
    SKLabelNode* label = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica-Bold"];
    
    label.text = text;
    label.fontSize = 24;
    label.fontColor = [UIColor whiteColor];
    
    Projectile* asteroid = [Projectile spriteNodeWithImageNamed:@"asteroid"];
    [asteroid setValue:[equation getSolution]];
    [asteroid addChild:label];
    
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2 - 5]; // 1
    asteroid.physicsBody.dynamic = YES; // 2
    asteroid.physicsBody.categoryBitMask = asteroidCategory; // 3
    asteroid.physicsBody.contactTestBitMask = laserCategory; // 4
    asteroid.physicsBody.collisionBitMask = 0; // 5
    
    // Determine where to spawn the asteroid along the X axis
    int minX = asteroid.size.width / 2;
    int maxX = self.frame.size.width - asteroid.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the asteroid slightly off-screen along the top edge,
    // and along a random position along the X axis as calculated above
    asteroid.position = CGPointMake(actualX, self.frame.size.height + asteroid.size.height/2);
    [self addChild:asteroid];
    
    // Determine speed of the asteroid
    // TODO this should be less hard-coded, and at some point should correspond roughly with difficulty level
    //    int minDuration = 10.0;
    //    int maxDuration = 14.0;
    int minDuration = 30.0;
    int maxDuration = 35.0;
    
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, -asteroid.size.height/2) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        [self asteroidHitBottom];
    }];
    [asteroid runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
}

-(void)asteroidHitBottom
{
  [self.delegate asteroidReachedBottom];
}



//- (void)addAsteroid {
//    // Create sprite
//    SKSpriteNode * asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
//    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2 - 5]; // 1
//    asteroid.physicsBody.dynamic = YES; // 2
//    asteroid.physicsBody.categoryBitMask = asteroidCategory; // 3
//    asteroid.physicsBody.contactTestBitMask = laserCategory; // 4
//    asteroid.physicsBody.collisionBitMask = 0; // 5
//
//    // Determine where to spawn the asteroid along the X axis
//    int minX = asteroid.size.width / 2;
//    int maxX = self.frame.size.width - asteroid.size.width / 2;
//    int rangeX = maxX - minX;
//    int actualX = (arc4random() % rangeX) + minX;
//
//    // Create the asteroid slightly off-screen along the top edge,
//    // and along a random position along the X axis as calculated above
//    asteroid.position = CGPointMake(actualX, self.frame.size.height + asteroid.size.height/2);
//    [self addChild:asteroid];
//
//    // Determine speed of the asteroid
//    // TODO this should be less hard-coded, and at some point should correspond roughly with difficulty level
//    int minDuration = 10.0;
//    int maxDuration = 14.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
//
//    // Create the actions
//    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, -asteroid.size.height/2) duration:actualDuration];
//    SKAction * actionMoveDone = [SKAction removeFromParent];
//    SKAction * loseAction = [SKAction runBlock:^{
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
//        [self.view presentScene:gameOverScene transition: reveal];
//    }];
//    [asteroid runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
//}

//- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
//    self.lastSpawnTimeInterval += timeSinceLast;
//    if (self.lastSpawnTimeInterval > 4) {
//        self.lastSpawnTimeInterval = 0;
//        [self addAsteroid];
//    }
//}
//
//- (void)update:(NSTimeInterval)currentTime {
//    // Handle time delta.
//    // If we drop below 60fps, we still want everything to move the same distance.
//    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
//    self.lastUpdateTimeInterval = currentTime;
//    if (timeSinceLast > 1) { // more than a second since last update
//        timeSinceLast = 1.0 / 60.0;
//        self.lastUpdateTimeInterval = currentTime;
//    }
//
//    [self updateWithTimeSinceLastUpdate:timeSinceLast];
//}

- (CGPoint)boundPlayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, [self.player size].width);
    retval.x = MIN(retval.x, -[self.player size].width + winSize.width);
    retval.y = self.player.position.y;
    return retval;
}

- (void)translatePlayer:(CGPoint)translation {
    CGPoint position = [self.player position];
    CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
    [self.player setPosition:[self boundPlayerPos:newPos]];
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self translatePlayer:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.player removeAllActions];
    }
}

- (void)fireLaser:(Fraction*)value {
    Projectile* projectile = [Projectile spriteNodeWithImageNamed:@"LaserBeamSprite"];
    [projectile setValue:value];
    
    projectile.position = self.player.position;
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = laserCategory;
    projectile.physicsBody.contactTestBitMask = asteroidCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    projectile.yScale = -1.0;
    
    [self addChild:projectile];
    
    [self runAction:[SKAction playSoundFileNamed:@"jobro__laser6.wav" waitForCompletion:NO]];
    
    // 8 - Add the shoot amount to the current position
    CGPoint realDest = CGPointMake(projectile.position.x, self.size.height);
    
    // 9 - Create the actions
    float velocity = 800.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
}

- (void)laser:(Projectile*)laser didCollideWithAsteroid:(Projectile*)asteroid {
    //NSLog(@"Hit");
    if ([laser.value compare:asteroid.value] == NSOrderedSame) {
        [self runAction:[SKAction playSoundFileNamed:@"ryansnook__medium-explosion.wav" waitForCompletion:NO]];
        [asteroid removeFromParent];
        self.asteroidsDestroyed++;
        if (self.asteroidsDestroyed > 10) {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
            [self.view presentScene:gameOverScene transition: reveal];
        }
    } else {
        //NSLog(@"Miss! laser value: %@  asteroid value: %@", laser.value, asteroid.value);
    }
    [laser removeFromParent];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & laserCategory) != 0 &&
        (secondBody.categoryBitMask & asteroidCategory) != 0)
    {
        [self laser:(Projectile*) firstBody.node didCollideWithAsteroid:(Projectile*) secondBody.node];
        //NSLog(@"projectile x:%f y:%f monster x:%f y:%f", firstBody.node.position.x, firstBody.node.position.y, secondBody.node.position.x, secondBody.node.position.y);
    }
}

- (void)gameOver
{
    SKAction* gameOver = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition:reveal];
    }];
    [self runAction:[SKAction sequence:@[gameOver]]];
}

@end