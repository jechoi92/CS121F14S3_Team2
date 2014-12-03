//
//  GameScene.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameScene.h"

static const uint32_t laserCategory     =  0x1 << 0;
static const uint32_t asteroidCategory  =  0x1 << 1;

CGFloat INSET_RATIO;
int SLOW_SPEED = 35;
int MEDIUM_SPEED = 30;
int MAX_SPEED = 25;
int ALLOWED_WRONG_ANSWERS = 2;
CGFloat LASER_VELOCITY = 1500.0;

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* player;
@end

@implementation GameScene {
    int _minimumAsteroidDuration;
    int _asteroidsToDestroy;
    int _score;
    SKLabelNode* _asteroidsLabel;
    SKLabelNode* _asteroidsValueLabel;
    SKNode* _levelNode;
    NSArray* _explosionFrames;
}

-(id)initWithSize:(CGSize)size andLevel:(int)level {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        // store the minimum time an asteroid can spend on screen for this level
        _minimumAsteroidDuration = [self findMinimumAsteroidDuration:(int)level];
        // Store the number of asteroids that must be destroyed to clear the level
        _asteroidsToDestroy = [self findAsteroidsToDestroy:(int)level];
        
        [self createPlayer];
        [self displayLevel:level];
        [self createLabel];
        [self initializeSprites];
        
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }

    return self;
}

// Create node for the player's ship sprite
- (void)createPlayer
{
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    [self.player setScale:0.3];
    self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.width/2);
    self.player.zPosition = 1;
    [self addChild:self.player];
}

// Create labels displaying the number of asteroids left in the level
- (void)createLabel
{
    if (_asteroidsToDestroy > 0) {
        CGRect frame = self.frame;
        CGFloat asteroidsLabelX = CGRectGetWidth(frame) * 0.84;
        CGFloat asteroidsLabelY = CGRectGetHeight(frame) * 0.93;
    
        // Create label with "Asteroids remaining" text
        _asteroidsLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
        _asteroidsLabel.fontSize = 18;
        _asteroidsLabel.position =  CGPointMake(asteroidsLabelX, asteroidsLabelY);
        _asteroidsLabel.text = @"Asteroids remaining";
        _asteroidsLabel.zPosition = 1;
        [self addChild:_asteroidsLabel];
    
        CGFloat asteroidsValueLabelX = CGRectGetWidth(frame) * 0.97;
        CGFloat asteroidsValueLabelY = CGRectGetHeight(frame) * 0.93;
    
        // Create label displaying the actual number of asteroids left
        _asteroidsValueLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
        _asteroidsValueLabel.fontSize = 18;
        _asteroidsValueLabel.position =  CGPointMake(asteroidsValueLabelX, asteroidsValueLabelY);
        _asteroidsValueLabel.text = [[NSString alloc] initWithFormat:@"%d", _asteroidsToDestroy];
        _asteroidsValueLabel.zPosition = 1;
        [self addChild:_asteroidsValueLabel];
    }
}

// Creates the label node on the scene
-(void) displayLevel:(int)level
{
    CGRect frame = self.frame;
    CGFloat screenWidth = CGRectGetWidth(frame) ;
    CGFloat screenHeight = CGRectGetHeight(frame);
    
    NSString* levelDisp;
    if (level == -1) {
        levelDisp = [[NSString alloc] initWithFormat:@"survival_mode"];
    } else {
        levelDisp = [[NSString alloc] initWithFormat:@"level%d", level];
    }
    
    _levelNode = [SKSpriteNode spriteNodeWithImageNamed:levelDisp];
    _levelNode.position = CGPointMake(screenWidth*0.5 , screenHeight*0.93);
    _levelNode.physicsBody.dynamic = YES;
    
    [self addChild:_levelNode];
}

// Runs the animation of moving around the level node
-(void) startLevelAnimation
{
    CGPoint midDest = CGPointMake(_levelNode.position.x, self.size.height*0.6);
    CGPoint finalDest = CGPointMake(_levelNode.position.x, self.size.height*0.96);
    
    SKAction * moveDown = [SKAction moveTo:midDest  duration:1];
    SKAction * moveUp = [SKAction moveTo:finalDest  duration:1.2];
    SKAction * scaleDown = [SKAction scaleBy:0.5 duration:1.2];
    SKAction *group = [SKAction group:@[moveUp, scaleDown]];
    
    [_levelNode runAction:[SKAction sequence:@[moveDown, group]]];
}

// Prepare the frames of the explosion animation for when asteroids are destroyed
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
    _explosionFrames = [[NSArray alloc] initWithArray:explosionFrames];
}

// Used to determine the speed of asteroids for a given level
- (int)findMinimumAsteroidDuration:(int)level
{
    if (level == -1) {
        return MEDIUM_SPEED;
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

// Returns the number of asteroids that must be destroyed in the given level
- (int)findAsteroidsToDestroy:(int)level
{
    if (level  < 0) {
        return -1;
    } else if (level < 2) {
        return 10;
    } else if (level < 5) {
        return 12;
    } else if (level < 8) {
        return 16;
    } else if (level < 9) {
        return 20;
    } else {
        return 25;
    }
}

// Spawns an asteroid with a corresponding equation at a random x location
- (void) createAsteroid: (Equation*) equation {
    SKSpriteNode* asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    asteroid.userData = [NSMutableDictionary dictionary];
    // Store the solution for the equation, the laser frequency which will destroy the asteroid
    [asteroid userData][@"frequency"] = [equation getSolution];
    // Store the number of wrong answers left before the asteroid will change its equation
    [asteroid userData][@"attemptsLeft"] = [NSNumber numberWithInt:ALLOWED_WRONG_ANSWERS];
    
    // Display the equation on the asteroid sprite
    [asteroid addChild:[self createLabelForEquation:equation]];
    
    // Set up the asteroid's contact detection body
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2];
    asteroid.physicsBody.dynamic = YES; // 2
    asteroid.physicsBody.categoryBitMask = asteroidCategory; // 3
    asteroid.physicsBody.contactTestBitMask = laserCategory; // 4
    asteroid.physicsBody.collisionBitMask = 0; // 5
    
    // Determine where to spawn the asteroid along the X axis
    int minX = self.player.size.width * 1.5;
    int maxX = self.frame.size.width - self.player.size.width * 1.5;
    int actualX = minX + (arc4random() % (maxX - minX));
    
    // Create the asteroid slightly off-screen along the top edge,
    // and along a random position along the X axis as calculated above
    asteroid.position = CGPointMake(actualX, self.frame.size.height + asteroid.size.height/2);
    [self addChild:asteroid];
    
    // Determine speed of the asteroid
    int minDuration = _minimumAsteroidDuration;
    int rangeDuration = minDuration * 0.1;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Determine a slight random x offset so the asteroids will not just travel straight down
    int endX = actualX;
    endX += arc4random_uniform(self.frame.size.width) * 2 - self.frame.size.width;
    
    if (endX < minX) {
        endX = minX;
    } else if (endX > maxX) {
        endX = maxX;
    }
    
    // Create the actions and animate the asteroid's motion
    SKAction * actionMove = [SKAction moveTo:CGPointMake(endX, -asteroid.size.height/2) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        [self asteroidHitBottom];
    }];
    [asteroid runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
}

// Create an SKNode with text representing an equation
- (SKNode*)createLabelForEquation:(Equation*)equation
{
    SKNode* eqn = [SKNode node];
    SKNode* first = [self createLabelForFraction:[equation getFraction1]];
    NSString* op = [NSString stringWithFormat:@"%c" , [equation getOperator]];
    // Add the first fraction to the equation node
    [eqn addChild:first];
    
    // If the operator isn't simplification, there will be more things to place
    if (![op isEqualToString:@"$"]) {
        SKNode* oper = [self createLabelForOperator:op];
        SKNode* second = [self createLabelForFraction:[equation getFraction2]];
        
        // Adjust the positions of the fractions and the operator in their parent node
        first.position = CGPointMake(-30.0, 0.0);
        oper.position = CGPointMake(0.0, -15.0);
        second.position = CGPointMake(30.0, 0.0);
        
        [eqn addChild:oper];
        [eqn addChild:second];
    }
    
    return eqn;
}

// Create an SKNode with text representing a fraction
- (SKNode*)createLabelForFraction:(Fraction*)fraction
{
    // Create the line dividing the numerator and denominator
    SKLabelNode* line = [[SKLabelNode alloc] initWithFontNamed:@"Arial Bold"];
    line.text = @"__";
    line.fontSize = 24;
    line.fontColor = [UIColor whiteColor];
    
    // Create a label for the numerator
    SKLabelNode* numer = [[SKLabelNode alloc] initWithFontNamed:@"SpaceAge"];
    numer.text = [NSString stringWithFormat:@"%d", [fraction numerator]];
    numer.fontSize = 24;
    numer.fontColor = [UIColor whiteColor];
    numer.position = CGPointMake(0.0, 5.0);
    
    // Create a label for the denominator
    SKLabelNode* denom = [[SKLabelNode alloc] initWithFontNamed:@"SpaceAge"];
    denom.text = [NSString stringWithFormat:@"%d", [fraction denominator]];
    denom.fontSize = 24;
    denom.fontColor = [UIColor whiteColor];
    denom.position = CGPointMake(0.0, -30.0);
    
    // Add them all to a single node to return
    SKNode* verticalFraction = [SKNode node];
    [verticalFraction addChild:numer];
    [verticalFraction addChild:line];
    [verticalFraction addChild:denom];
    
    return verticalFraction;
}

// Creates a node with the corresponding nice-looking symbol for each operator string
- (SKNode*)createLabelForOperator:(NSString*)operator
{
    SKLabelNode* oper = [[SKLabelNode alloc] initWithFontNamed:@"Arial Bold"];
    
    if ([operator isEqualToString:@"/"]) {
        oper.text = @"÷";
    } else if ([operator isEqualToString:@"+"]) {
        oper.text = @"+";
    } else if ([operator isEqualToString:@"-"]) {
        oper.text = @"-";
    } else {
        oper.text = @"x";
    }
    
    oper.fontSize = 30;
    oper.fontColor = [UIColor whiteColor];
    
    return oper;
}

// Inform the deligate that the player failed to destroy an asteroid in time
-(void)asteroidHitBottom
{
    SKSpriteNode* background = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:self.size];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    
    
    [self.deli asteroidReachedBottom];
}

// Calculate acceptable locations for the player sprite to prevent it from sliding off screen
- (CGPoint)boundPlayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, self.player.size.width * 1.5);
    retval.x = MIN(retval.x, winSize.width - self.player.size.width * 1.5);
    retval.y = self.player.position.y;
    return retval;
}

// Update the player sprite's location horizontally
- (void)translatePlayer:(CGPoint)translation {
    CGPoint position = [self.player position];
    CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
    [self.player setPosition:[self boundPlayerPos:newPos]];
}

- (void)didMoveToView:(SKView *)view {
    // gestureRecognizer is used to distinguish when the player is dragging on the screen
    // versus tapping
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

// Spawns a laser sprite with the frequency and color corresponding to a given
// Fire button.
- (void)fireLaser:(Fraction*)value fromButton:(int)tag
{
    SKSpriteNode *projectile;
    
    // Determine the color of the laser beam sprite based on the button tag
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
    
    // Set the frequency of the laser
    projectile.userData = [NSMutableDictionary dictionary];
    [projectile userData][@"frequency"] = value;
    
    // Set up the laser's contact detection body
    projectile.position = CGPointMake(self.player.position.x, self.player.position.y + self.player.size.height / 2);
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = laserCategory;
    projectile.physicsBody.contactTestBitMask = asteroidCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    projectile.yScale = -1.0;
    
    [self addChild:projectile];
    
    // Play laser sound effect
    [self runAction:[SKAction playSoundFileNamed:@"jobro__laser6.wav" waitForCompletion:NO]];
    
    // Create the endpoint of the laser's trajectory
    CGPoint realDest = CGPointMake(projectile.position.x, self.size.height);
    
    // Create the actions and animate the laser's motion
    CGFloat realMoveDuration = self.size.width / LASER_VELOCITY;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

// Handle laser and asteroid collision.  If the laser's frequency solves the
// asteroid's equation, they should both be destroyed.
- (void)laser:(SKSpriteNode*)laser didCollideWithAsteroid:(SKSpriteNode*)asteroid
{
    Fraction* laserFrequency = [laser userData][@"frequency"];
    Fraction* asteroidFrequency = [asteroid userData][@"frequency"];
    
    // If the frequencies are the same, destroy both sprites and increment score
    if ([laserFrequency compare:asteroidFrequency] == NSOrderedSame) {
        // Play explosion sound effect
        [self runAction:[SKAction playSoundFileNamed:@"ryansnook__medium-explosion.wav" waitForCompletion:NO]];
        
        // Spawn animated explosion sprite
        [self spawnExplosion:[asteroid position]];
        
        // Decrement our counter of asteroids remaining in the level
        _asteroidsToDestroy--;
        
        // Calculate the score for the destroyed asteroid and spawn a notice with that score
        int asteroidScore = (10 + (int) asteroid.position.y / 100) * 10;
        [self asteroidDestroyed: (int)asteroidScore];
        [self notifyWithPosition: asteroid.position andScore: asteroidScore andPositive:YES];
        
        // Remove the asteroid sprite
        [asteroid removeFromParent];
        if (_asteroidsToDestroy == 0) {
            // If the victory condition is met, destroy all asteroids left in the scene...
            [self removeAllAsteroids];
            // ...and inform the delegate
            [self.deli lastAsteroidDestroyed];
        }
        
        // Update the label of asteroids remaining
        _asteroidsValueLabel.text = [[NSString alloc] initWithFormat:@"%d", _asteroidsToDestroy];
    } else {
        // Check how many wrong attempts are left for this asteroid
        int attemptsLeft = [[asteroid userData][@"attemptsLeft"] intValue];
        attemptsLeft--;
        
        // If all attempts are used, change the equation for this asteroid to prevent spamming
        if (attemptsLeft <= 0) {
            Equation* newEquation = [self.deli wrongAnswerAttempt:laserFrequency];
            [self notifyWithPosition: asteroid.position andScore: 50 andPositive:NO];
            [asteroid userData][@"frequency"] = [newEquation getSolution];
            [asteroid removeAllChildren];
            [asteroid addChild:[self createLabelForEquation:newEquation]];
            
            // Reset the number of attempts left
            attemptsLeft = ALLOWED_WRONG_ANSWERS;
        }
        [asteroid userData][@"attemptsLeft"] = [NSNumber numberWithInt:attemptsLeft];
    }
    [laser removeFromParent];
}

// Creates an animated explosion sprite at the provided position
- (void)spawnExplosion: (CGPoint)position
{
    SKTexture* temp = _explosionFrames[0];
    SKSpriteNode* explosion = [SKSpriteNode spriteNodeWithTexture:temp];
    explosion.position = position;
    explosion.zPosition = 1; // Set zPosition explicitly to ensure visibility of all elements
    [self addChild:explosion];
    
    // Animate over the explosion frames
    SKAction * playExplosion = [SKAction animateWithTextures:_explosionFrames
                                                timePerFrame:0.05f];
    SKAction * endAnimation = [SKAction removeFromParent];
    [explosion runAction:[SKAction sequence:@[playExplosion, endAnimation]]];
}

// Spawn a label with the number of points earned from an asteroid
- (void)notifyWithPosition: (CGPoint)position andScore: (int)score andPositive:(BOOL)plus
{
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    
    label.fontSize = 20;
    label.position =  CGPointMake(position.x, position.y);
    if (plus) {
        label.fontColor = [UIColor greenColor];
        label.text = [[NSString alloc] initWithFormat:@"+%d", score];
    }
    else {
        label.fontColor = [UIColor redColor];
        label.text = [[NSString alloc] initWithFormat:@"-%d", score];
    }
    label.zPosition = 2;
    [self addChild:label];
    
    // Have the label fade and then disappear
    [label runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:2.0f], [SKAction removeFromParent]]]];
}

// Notify delegate of score updates
- (void)asteroidDestroyed: (int)asteroidScore
{
    [self.deli incrementScore: (int)asteroidScore];
}

// Distinguish between contact of different physics bodies and respond
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & laserCategory) != 0 &&
        (secondBody.categoryBitMask & asteroidCategory) != 0)
    {
        [self laser:(SKSpriteNode*) firstBody.node didCollideWithAsteroid:(SKSpriteNode*) secondBody.node];
    }
}

// Clear the remaining asteroids in the scene
-(void)removeAllAsteroids
{
    [self enumerateChildNodesWithName:@"asteroid" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}


@end