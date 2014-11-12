//
//  GameScene.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"

static const uint32_t laserCategory     =  0x1 << 0;
static const uint32_t asteroidCategory  =  0x1 << 1;

CGFloat INSET_RATIO;
int SLOW_SPEED = 35;
int MEDIUM_SPEED = 30;
int MAX_SPEED = 25;

// TODO make a spritenode that represents the surface of the earth for asteroid collisions?

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* player;
@end

@implementation GameScene {
    int _minimumAsteroidDuration;
    int _asteroidsToDestroy;
    int _score;
    SKLabelNode* _asteroidsLabel;
    SKLabelNode* _asteroidsValueLabel;
    NSArray* _explosionFrames;
}

-(id)initWithSize:(CGSize)size andLevel:(int)level {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.name = @"BACKGROUND";
        [self addChild:background];
        
        _minimumAsteroidDuration = [self findMinimumAsteroidDuration:(int)level];
        _asteroidsToDestroy = [self findAsteroidsToDestroy:(int)level];
        
        [self createPlayer];
        [self createLabel];
        [self initializeSprites];
        
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    
    return self;
}

- (void)createPlayer
{
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    [self.player setScale:0.3];
    self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.width/2);
    self.player.zPosition = 1;
    [self addChild:self.player];
}

- (void)createLabel
{
    CGRect frame = self.frame;
    
    CGFloat asteroidsLabelX = CGRectGetWidth(frame) * 0.84;
    CGFloat asteroidsLabelY = CGRectGetHeight(frame) * 0.93;
    
    _asteroidsLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    _asteroidsLabel.fontSize = 18;
    _asteroidsLabel.position =  CGPointMake(asteroidsLabelX, asteroidsLabelY);
    _asteroidsLabel.text = @"Asteroids remaining:";
    _asteroidsLabel.blendMode = YES;
    _asteroidsLabel.zPosition = 1;
    [self addChild:_asteroidsLabel];
    
    CGFloat asteroidsValueLabelX = CGRectGetWidth(frame) * 0.97;
    CGFloat asteroidsValueLabelY = CGRectGetHeight(frame) * 0.93;
    
    _asteroidsValueLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    _asteroidsValueLabel.fontSize = 18;
    _asteroidsValueLabel.position =  CGPointMake(asteroidsValueLabelX, asteroidsValueLabelY);
    _asteroidsValueLabel.text = [[NSString alloc] initWithFormat:@"%d", _asteroidsToDestroy];
    _asteroidsValueLabel.blendMode = YES;
    _asteroidsValueLabel.zPosition = 1;
    [self addChild:_asteroidsValueLabel];
}

- (void)initializeSprites
{
    SKTextureAtlas* explosionAtlas = [SKTextureAtlas atlasNamed:@"explosionFrames"];
    int numFrames = (int)explosionAtlas.textureNames.count/2;
    // The texture atlas includes two sprite resolutions, so we need to divide by two
    NSMutableArray* explosionFrames = [[NSMutableArray alloc] init];
    for (int i = 0; i < numFrames; i++) {
        NSString* frame = [NSString stringWithFormat:@"explosion_frame_%d", i];
        SKTexture* temp = [explosionAtlas textureNamed:frame];
        [explosionFrames addObject:temp];
    }
    NSLog(@"%d", (int)explosionFrames.count);
    _explosionFrames = [[NSArray alloc] initWithArray:explosionFrames];
    int size = [_explosionFrames count];
    NSLog(@"Frames: %d",size);
}

- (int)findMinimumAsteroidDuration:(int)level
{
    if (level == 10) {
        return 15;
    }
    
    if (level < 5) {
        return SLOW_SPEED;
    }
    else if (level < 9) {
        return MEDIUM_SPEED;
    }
    else {
        return MAX_SPEED;
    }
}

- (int)findAsteroidsToDestroy:(int)level
{
    if (level == 10) {
        return 2;
    }
    
    if (level < 2) {
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


- (void) createAsteroid: (Equation*) equation {
    NSString* text = [equation toString];
    SKLabelNode* label = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica-Bold"];
    
    label.text = text;
    label.fontSize = 24;
    label.fontColor = [UIColor whiteColor];
    
    SKSpriteNode* asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    asteroid.userData = [NSMutableDictionary dictionary];
    [asteroid userData][@"frequency"] = [equation getSolution];
    [asteroid addChild:label];
    
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2 - 5]; // 1
    asteroid.physicsBody.dynamic = YES; // 2
    asteroid.physicsBody.categoryBitMask = asteroidCategory; // 3
    asteroid.physicsBody.contactTestBitMask = laserCategory; // 4
    asteroid.physicsBody.collisionBitMask = 0; // 5
    
    // Determine where to spawn the asteroid along the X axis
    int minX = asteroid.size.width;
    int maxX = self.frame.size.width - asteroid.size.width;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    // Create the asteroid slightly off-screen along the top edge,
    // and along a random position along the X axis as calculated above
    asteroid.position = CGPointMake(actualX, self.frame.size.height + asteroid.size.height/2);
    [self addChild:asteroid];
    
    // Determine speed of the asteroid
    int minDuration = _minimumAsteroidDuration;
    int rangeDuration = minDuration * 0.15;
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

- (CGPoint)boundPlayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, [self.player size].width);
    retval.x = MIN(retval.x, winSize.width - [self.player size].width * 1.2);
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

- (void)fireLaser:(Fraction*)value fromButton:(int)tag{
    SKSpriteNode *projectile;
    if (tag==1) {
        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"bluelaserbeam"];
    } else if (tag==2) {
        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"redlaserbeam"];
    } else if (tag==3) {
        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"hawtpinklaserbeam"];
    } else if (tag==4) {
        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"goldlaserbeam"];
    } else {
        projectile = [SKSpriteNode spriteNodeWithImageNamed:@"greenlaserbeam"];
    }
    
    projectile.userData = [NSMutableDictionary dictionary];
    [projectile userData][@"frequency"] = value;
    
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

- (void)laser:(SKSpriteNode*)laser didCollideWithAsteroid:(SKSpriteNode*)asteroid {
    Fraction* laserFrequency = [laser userData][@"frequency"];
    Fraction* asteroidFrequency = [asteroid userData][@"frequency"];
    if ([laserFrequency compare:asteroidFrequency] == NSOrderedSame) {
        [self runAction:[SKAction playSoundFileNamed:@"ryansnook__medium-explosion.wav" waitForCompletion:NO]];
        NSLog(@"About to spawn explosion");
        [self spawnExplosion:[asteroid position]];
        [asteroid removeFromParent];
        _asteroidsToDestroy--;
        int asteroidScore = (10 + (int) asteroid.position.y / 100) * 10;
        [self asteroidDestroyed: (int)asteroidScore];
        [self notifyWithPosition: asteroid.position andScore: asteroidScore];
      
        if (_asteroidsToDestroy <= 0) {
            [self removeAllAsteroids];
            [self.delegate lastAsteroidDestroyed];
        }
      
        _asteroidsValueLabel.text = [[NSString alloc] initWithFormat:@"%d", _asteroidsToDestroy];
    } else {
        //NSLog(@"Miss! laser value: %@  asteroid value: %@", laser.value, asteroid.value);
    }
    [laser removeFromParent];
}

- (void)spawnExplosion: (CGPoint)position
{
    NSLog(@"a");
    SKTexture* temp = _explosionFrames[0];
    NSLog(@"b");
    SKSpriteNode* explosion = [SKSpriteNode spriteNodeWithTexture:temp];
    explosion.position = position;
    NSLog(@"c");
    [self addChild:explosion];
    NSLog(@"d");
    SKAction * playExplosion = [SKAction animateWithTextures:_explosionFrames
                                                timePerFrame:0.1f];
    SKAction * endAnimation = [SKAction removeFromParent];
    [explosion runAction:[SKAction sequence:@[playExplosion, endAnimation]]];
}

- (void)notifyWithPosition: (CGPoint)position andScore: (int)score
{
    /*SKTexture* explosion = [SKTexture textureWithImageNamed:@"explosion"];
    SKSpriteNode* explosionn = [SKSpriteNode spriteNodeWithTexture:explosion];
    
    explosionn.position =  CGPointMake(position.x, position.y);
    explosionn.zPosition = 1;
    [self addChild:explosionn];*/
    
    
    
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    label.fontSize = 18;
    label.position =  CGPointMake(position.x, position.y);
    label.text = [[NSString alloc] initWithFormat:@"+%d", score];
    label.blendMode = YES;
    label.zPosition = 1;
    [self addChild:label];
    [label runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:1.0f], [SKAction removeFromParent]]]];
}

- (void)asteroidDestroyed: (int)asteroidScore
{
    [self.delegate incrementScore: (int)asteroidScore];
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
        [self laser:(SKSpriteNode*) firstBody.node didCollideWithAsteroid:(SKSpriteNode*) secondBody.node];//NSLog(@"projectile x:%f y:%f monster x:%f y:%f", firstBody.node.position.x, firstBody.node.position.y, secondBody.node.position.x, secondBody.node.position.y);
    }
}

-(void)removeAllAsteroids
{
    [self enumerateChildNodesWithName:@"asteroid" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
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