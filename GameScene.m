//
//  GameScene.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "GameScene.h"
#import "Constants.h"

CGFloat INSET_RATIO;

// Enum object for ship numbers
typedef enum {
    BlueShip,
    BrownShip,
    SilverShip,
    RedShip
}ShipNumbers;

// Enum object for laser numbers
typedef enum {
    GreenLaser,
    BlueLaser,
    RedLaser,
    HawtPinkLaser,
    GoldLaser
}LaserNumbers;

@interface GameScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode* player;
@end

@implementation GameScene {
    int _minimumAsteroidDuration;
    int _asteroidsToDestroy;
    int _score;
    int _level;
    SKNode* _levelNode;
    NSArray* _explosionFrames;
}

-(id)initWithSize:(CGSize)size andLevel:(int)level andShipNum:(int)shipNum
{
    if (self = [super initWithSize:size]) {
        _level = level;
        
        // Minimum time an asteroid can spend on screen for this level
        _minimumAsteroidDuration = [self findMinimumAsteroidDuration:(int)level];
        
        // Number of asteroids that must be destroyed to clear the level
        _asteroidsToDestroy = [self findAsteroidsToDestroy:(int)level];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        [self createPlayerWithShipNum:shipNum];
        [self createExplosionFrames];
        [self createBackground];
    }
    return self;
}

- (void)createBackground
{
    SKSpriteNode* background;
    if (_level < 5) {
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    } else if (_level == 5) {
        background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    } else {
        background = [SKSpriteNode spriteNodeWithImageNamed:@"foreign-back"];
    }
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = -1;
    [self addChild:background];
}

// Create node for the player's ship sprite
- (void)createPlayerWithShipNum:(int)shipNum
{
    // Determine the image depending on the ship number
    NSString *shipType;
    switch (shipNum) {
        case BlueShip:
        {
            shipType = [NSString stringWithFormat:@"blueSpaceShip"];
            break;
        }
        case BrownShip:
        {
            shipType = [NSString stringWithFormat:@"brownSpaceShip"];
            break;
        }
        case SilverShip:
        {
            shipType = [NSString stringWithFormat:@"silverSpaceShip"];
            break;
        }
        case RedShip:
        {
            shipType = [NSString stringWithFormat:@"redSpaceShip"];
            break;
        }
    }
    
    // Create the player node
    self.player = [SKSpriteNode spriteNodeWithImageNamed:shipType];
    [self.player setScale:0.3];
    self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.width/2);
    
    // Bring to front
    self.player.zPosition = 1;
    
    [self addChild:self.player];
}

// Creates the label node on the scene
- (void)createLevelLabel
{
    CGRect frame = self.frame;
    CGFloat screenWidth = CGRectGetWidth(frame);
    CGFloat screenHeight = CGRectGetHeight(frame);
    
    // Create level string depending on level and mode
    NSString* levelDisp;
    if (_level == -1) {
        levelDisp = [[NSString alloc] initWithFormat:@"survival_mode"];
    }
    else {
        levelDisp = [[NSString alloc] initWithFormat:@"level%d", _level];
    }
    
    _levelNode = [SKSpriteNode spriteNodeWithImageNamed:levelDisp];
    _levelNode.position = CGPointMake(screenWidth*0.5 , screenHeight*0.93);
    _levelNode.physicsBody.dynamic = YES;
    
    [self addChild:_levelNode];
}

// Runs the animation of moving around the level node
-(void)startLevelAnimation
{
    [self createLevelLabel];
    
    // Play the start sound effect
    [self runAction:[SKAction playSoundFileNamed:@"sirens.wav" waitForCompletion:NO]];
    
    CGPoint midDest = CGPointMake(_levelNode.position.x, self.size.height*0.6);
    CGPoint finalDest = CGPointMake(_levelNode.position.x, self.size.height*0.96);
    
    SKAction *moveDown = [SKAction moveTo:midDest duration:1];
    SKAction *moveUp = [SKAction moveTo:finalDest duration:1.2];
    SKAction *scaleDown = [SKAction scaleBy:0.5 duration:1.2];
    SKAction *group = [SKAction group:@[moveUp, scaleDown]];
    
    [_levelNode runAction:[SKAction sequence:@[moveDown, group]]];
}

// Create the frames of the explosion animation for when asteroids are destroyed
- (void)createExplosionFrames
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

// Determine the speed of asteroids for a given level
- (int)findMinimumAsteroidDuration:(int)level
{
    // If survival mode, the default is MEDIUM_SPEED
    if (level == -1) {
        return MEDIUM_SPEED;
    }
    
    // Otherwise, the speed is determined by level
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
    // If survival mode, the asteroids to destroy are set to -1
    // so that the game can never be won
    if (level  < 0) {
        return -1;
    }
    // Otherwise determined by level
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

// Creates an asteroid with a corresponding equation at a random x location
- (void) createAsteroid: (Equation*) equation {
    SKSpriteNode *asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    
    // Initializes this dictionary to store the solution of the asteroid and attempts at answering the equation
    asteroid.userData = [NSMutableDictionary dictionary];
    
    // Store the solution for the equation, the laser frequency which will destroy the asteroid
    [asteroid userData][@"frequency"] = [equation getSolution];
    
    // Store the number of wrong answers left before the asteroid will change its equation
    [asteroid userData][@"attemptsLeft"] = [NSNumber numberWithInt:ALLOWED_WRONG_ANSWERS];
    
    // Display the equation on the asteroid sprite
    [asteroid addChild:[self createLabelForEquation:equation]];
    
    // Set up the asteroid's contact detection body
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2];
    asteroid.physicsBody.dynamic = YES;
    asteroid.physicsBody.categoryBitMask = ASTEROID_CATEGORY;
    asteroid.physicsBody.contactTestBitMask = LASER_CATEGORY;
    asteroid.physicsBody.collisionBitMask = 0;
    
    // Determine where to create the asteroid along the X axis
    int minX = self.player.size.width * 1.2;
    int maxX = self.frame.size.width - self.player.size.width * 2;
    int actualX = minX + (arc4random() % (maxX - minX));
    
    // Determine a slight random x offset so the asteroids drift horizontally as well
    int offset = (arc4random_uniform(self.frame.size.width) * 2 - self.frame.size.width);
    
    // Drift is increased by a factor depending on the level
    if (_level > 0) {
        offset *= sqrt(_level);
    }
    
    // But makes sure the asteroid does not drift outside of the screen
    int endX = actualX + offset;
    if (endX < minX) {
        endX = minX;
    } else if (endX > maxX) {
        endX = maxX;
    }
    
    // Create the asteroid slightly off-screen along the top edge,
    // and along a random position along the X axis as calculated above
    asteroid.position = CGPointMake(actualX, self.frame.size.height + asteroid.size.height/2);
    [self addChild:asteroid];
    
    // Determine speed of the asteroid
    int minDuration = _minimumAsteroidDuration;
    int rangeDuration = minDuration * 0.1;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions and animate the asteroid's motion
    SKAction *actionMove = [SKAction moveTo:CGPointMake(endX, -asteroid.size.height/2) duration:actualDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *loseAction = [SKAction runBlock:^{ [self asteroidHitBottom]; }];
    [asteroid runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
}

// Create an SKNode with text representing an equation, for a more intuitive display of fractions
- (SKNode*)createLabelForEquation:(Equation*)equation
{
    SKNode *eqn = [SKNode node];
    SKNode *first = [self createLabelForFraction:[equation getFraction1]];
    NSString *op = [NSString stringWithFormat:@"%c", [equation getOperator]];
    
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

// Create an SKNode with text representing a fraction, for a more intuitive display of fractions
- (SKNode*)createLabelForFraction:(Fraction*)fraction
{
    // Create the line dividing the numerator and denominator
    SKLabelNode *line = [[SKLabelNode alloc] initWithFontNamed:@"Arial Bold"];
    line.text = @"__";
    line.fontSize = 24;
    line.fontColor = [UIColor whiteColor];
    
    // Create a label for the numerator
    SKLabelNode *numer = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
    numer.text = [NSString stringWithFormat:@"%d", [fraction numerator]];
    numer.fontSize = 24;
    numer.fontColor = [UIColor whiteColor];
    numer.position = CGPointMake(0.0, 5.0);
    
    // Create a label for the denominator
    SKLabelNode *denom = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Bold"];
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
    }
    else if ([operator isEqualToString:@"+"]) {
        oper.text = @"+";
    }
    else if ([operator isEqualToString:@"-"]) {
        oper.text = @"-";
    }
    else {
        oper.text = @"x";
    }
    
    oper.fontSize = 30;
    oper.fontColor = [UIColor whiteColor];
    
    return oper;
}

// Function to handle the case when an asteroid reaches tha bottom
- (void)asteroidHitBottom
{
    // Play a warning animation
    SKSpriteNode *warningFlash = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:self.size];
    warningFlash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    warningFlash.zPosition = 2;
    [self addChild:warningFlash];
    [warningFlash runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.5f], [SKAction removeFromParent]]]];
    
    // Inform the delegate
    [self.deli asteroidReachedBottom];
}

// Calculate acceptable locations for the player sprite to prevent it from sliding off screen
- (CGPoint)boundPlayerPos:(CGPoint)newPos
{
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    
    // Place bounds as to prevent the sprite from moving onto the health and sidebars
    retval.x = MAX(retval.x, self.player.size.width * 1.2);
    retval.x = MIN(retval.x, winSize.width - self.player.size.width * 1.2);
    
    // Player can only move horizontally
    retval.y = self.player.position.y;
    
    return retval;
}

// Update the player sprite's location horizontally
- (void)translatePlayer:(CGPoint)translation
{
    CGPoint position = [self.player position];
    CGPoint newPos = CGPointMake(position.x + translation.x, position.y + translation.y);
    [self.player setPosition:[self boundPlayerPos:newPos]];
}

// Function to handle movements of the player
- (void)didMoveToView:(SKView *)view
{
    UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self translatePlayer:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.player removeAllActions];
    }
}

// Fires a laser sprite with the frequency and color corresponding to a given button.
- (void)fireLaser:(Fraction*)value fromButton:(int)tag
{
    SKSpriteNode *projectile;
    
    // Determine the color of the laser beam sprite based on the button tag
    switch (tag) {
        case GreenLaser:
        {
            projectile = [SKSpriteNode spriteNodeWithImageNamed:@"greenlaserbeam"];
            break;
        }
        case BlueLaser:
        {
            projectile = [SKSpriteNode spriteNodeWithImageNamed:@"bluelaserbeam"];
            break;
        }
        case RedLaser:
        {
            projectile = [SKSpriteNode spriteNodeWithImageNamed:@"redlaserbeam"];
            break;
        }
        case HawtPinkLaser:
        {
            projectile = [SKSpriteNode spriteNodeWithImageNamed:@"hawtpinklaserbeam"];
            break;
        }
        case GoldLaser:
        {
            projectile = [SKSpriteNode spriteNodeWithImageNamed:@"goldlaserbeam"];
            break;
        }
    }
    
    // Set the frequency of the laser
    projectile.userData = [NSMutableDictionary dictionary];
    [projectile userData][@"frequency"] = value;
    
    // Set the position of the laser
    projectile.position = CGPointMake(self.player.position.x, self.player.position.y + self.player.size.height / 2);
    
    // Set up the laser's contact detection body
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = LASER_CATEGORY;
    projectile.physicsBody.contactTestBitMask = ASTEROID_CATEGORY | SHIELD_CATEGORY | BOSS_CATEGORY;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    projectile.yScale = -1.0;
    
    [self addChild:projectile];
    
    // Play laser sound effect
    [self runAction:[SKAction playSoundFileNamed:@"jobro__laser6.wav" waitForCompletion:NO]];
    
    // Create the endpoint of the laser's trajectory, only travels vertically
    CGPoint realDest = CGPointMake(projectile.position.x, self.size.height);
    
    // Create the actions and animate the laser's motion
    CGFloat realMoveDuration = self.size.width / LASER_VELOCITY;
    SKAction *actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
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
        [self createExplosion:[asteroid position]];
        
        // Calculate the score for the destroyed asteroid and create a notice with that score
        // Score earned is higher the faster an asteroid is destroyed upon creation
        int asteroidScore = (11 + (int) asteroid.position.y / 100) * 10;
        [self asteroidDestroyed: (int)asteroidScore andAsteroidCount:(int)_asteroidsToDestroy];
        [self notifyWithPosition: asteroid.position andScore: asteroidScore andPositive:YES];
        
        // Decrement our counter of asteroids remaining in the level
        _asteroidsToDestroy--;
        
        // Remove the asteroid sprite
        [asteroid removeFromParent];
        
        if (_asteroidsToDestroy <= 0) {
            // If the victory condition is met, destroy all asteroids left in the scene...
            [self removeAllAsteroids];
            [self.deli lastAsteroidDestroyed];
        }
    }
    // If the incorrent laser was fired
    else {
        
        // Check how many wrong attempts are left for this asteroid
        int attemptsLeft = [[asteroid userData][@"attemptsLeft"] intValue];
        attemptsLeft--;
        
        // If all attempts are used, change the equation for this asteroid to prevent spamming
        if (attemptsLeft < 0) {
            
            // Get a new equation for the asteroid and set it
            Equation* newEquation = [self.deli wrongAnswerAttempt:laserFrequency];
            [asteroid userData][@"frequency"] = [newEquation getSolution];
            [asteroid removeAllChildren];
            [asteroid addChild:[self createLabelForEquation:newEquation]];
            
            // Reset the number of attempts left
            attemptsLeft = ALLOWED_WRONG_ANSWERS;
            
            // Decrement score by 100
            [self notifyWithPosition: asteroid.position andScore: 100 andPositive:NO];
        }
        
        // Update the number of attempts left for the asteroid
        [asteroid userData][@"attemptsLeft"] = [NSNumber numberWithInt:attemptsLeft];
    }
    
    // Remove the laser
    [laser removeFromParent];
}

// Creates an animated explosion sprite at the provided position
- (void)createExplosion: (CGPoint)position
{
    SKTexture *temp = _explosionFrames[0];
    SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:temp];
    explosion.position = position;
    explosion.zPosition = 1; // Set zPosition explicitly to ensure visibility of all elements
    [self addChild:explosion];
    
    // Animate over the explosion frames
    SKAction * playExplosion = [SKAction animateWithTextures:_explosionFrames timePerFrame:0.05f];
    SKAction * endAnimation = [SKAction removeFromParent];
    [explosion runAction:[SKAction sequence:@[playExplosion, endAnimation]]];
    
    [self runAction:[SKAction playSoundFileNamed:@"ryansnook__medium-explosion.wav" waitForCompletion:NO]];
}

// Create a label with the number of points earned from an asteroid
- (void)notifyWithPosition: (CGPoint)position andScore: (int)score andPositive:(BOOL)plus
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
    
    label.fontSize = 20;
    label.position =  CGPointMake(position.x, position.y);
    label.zPosition = 2;
    
    // Depending on whether it is an increment or decrement, determine the text and color
    if (plus) {
        label.fontColor = [UIColor greenColor];
        label.text = [[NSString alloc] initWithFormat:@"+%d", score];
    }
    else {
        label.fontColor = [UIColor redColor];
        label.text = [[NSString alloc] initWithFormat:@"-%d", score];
    }
    
    [self addChild:label];
    
    // Have the label fade and then disappear
    [label runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:2.0f], [SKAction removeFromParent]]]];
}

// Notify delegate of score updates
- (void)asteroidDestroyed: (int)asteroidScore andAsteroidCount: (int)numAsteroid
{
    [self.deli incrementScore: (int)asteroidScore];
    [self.deli incrementAsteroid: (int)numAsteroid];
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
    
    if ((firstBody.categoryBitMask & LASER_CATEGORY) != 0 &&
        (secondBody.categoryBitMask & ASTEROID_CATEGORY) != 0)
    {
        [self laser:(SKSpriteNode*) firstBody.node didCollideWithAsteroid:(SKSpriteNode*) secondBody.node];
    }
}

// Clear the remaining asteroids in the scene
-(void)removeAllAsteroids
{
    [self enumerateChildNodesWithName:@"asteroid" usingBlock:^(SKNode *node, BOOL *stop) {[node removeFromParent];}];
}


@end