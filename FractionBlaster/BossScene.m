//
//  GameScene.m
//  FractionBlaster
//
//  Created by CS121 on 11/2/14.
//  Copyright (c) 2014 MatherTeresa. All rights reserved.
//

#import "BossScene.h"
#import "Constants.h"

@implementation BossScene {
    int _score;
    int _bossStage;
    int _lastAsteroidGenerated;
    BOOL _asteroidGenOneDestroyed;
    BOOL _asteroidGenTwoDestroyed;
    SKLabelNode* _asteroidsLabel;
    SKLabelNode* _asteroidsValueLabel;
    SKNode* _bossNode;
    NSTimer* _asteroidGenerationTimer;
    // TODO delete me
    NSTimer* _testTimer;
}

-(id)initWithSize:(CGSize)size andLevel:(int)level andShipNum:(int)shipNum andDelegate:(id<AsteroidAction>)deli{
    if (self = [super initWithSize:size]) {
        self.deli = deli;
        
        [self createPlayerWithShipNum:shipNum];
        [self createExplosionFrames];
        [self createBackground];
        
        [self createBoss];
        [self advanceBossStage];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
    }
    
    return self;
}

- (void)advanceBossStage
{
    if (_bossStage == 0) {        // Boss moving onto screen, starting battle
        _bossNode.position = CGPointMake(self.size.width/2, self.size.height + 200.0);
        CGPoint destination = CGPointMake(self.size.width/2.0, self.size.height - 180.0);
        SKAction* moveAction = [SKAction moveTo:destination duration:15.0];
        [_bossNode runAction:moveAction];
        
        SKAction* moveUp = [SKAction moveByX:0.0 y:8.0 duration:1.5];
        moveUp.timingMode = SKActionTimingEaseInEaseOut;
        SKAction* moveDown = [SKAction moveByX:0.0 y:-8.0 duration:1.5];
        moveDown.timingMode = SKActionTimingEaseInEaseOut;
        
        [_bossNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveUp, moveDown]]]];
        
        // TODO this is some hacky terrible code right here.  Need to fix our delegation I think.
        [self addEquation:[self.deli initializeTarget] ToBossPart:[_bossNode childNodeWithName:@"shieldGen1"]];
        [self addEquation:[self.deli initializeTarget] ToBossPart:[_bossNode childNodeWithName:@"shieldGen2"]];
    }
    else if (_bossStage == 1) { // one shieldGen destroyed
        // If one shield generator is destroyed, lower the shield opacity
        [[_bossNode childNodeWithName:@"shield"] runAction:[SKAction fadeAlphaBy:-0.25 duration:2.0]];
    }
    else if (_bossStage == 2) { // both shieldGens destroyed
        // If both generators are destroyed, the shield disappears
        [[_bossNode childNodeWithName:@"shield"] runAction:
         [SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:2.0], [SKAction removeFromParent]]]];
        
        [self addEquation:[self.deli initializeTarget] ToBossPart:[_bossNode childNodeWithName:@"asteroidGen1"]];
        [self addEquation:[self.deli initializeTarget] ToBossPart:[_bossNode childNodeWithName:@"asteroidGen2"]];
        
        [[_bossNode childNodeWithName:@"asteroidGen1"] childNodeWithName:@"collisionBody"].physicsBody.categoryBitMask = BOSS_CATEGORY;
        [[_bossNode childNodeWithName:@"asteroidGen2"] childNodeWithName:@"collisionBody"].physicsBody.categoryBitMask = BOSS_CATEGORY;
    }
    else if (_bossStage == 3) { // one asteroidGen destroyed
        
    }
    else if (_bossStage == 4) { // both asteroidGens destroyed
        [self addEquation:[self.deli initializeTarget] ToBossPart:[_bossNode childNodeWithName:@"warpGen"]];
        [[_bossNode childNodeWithName:@"warpGen"] childNodeWithName:@"collisionBody"].physicsBody.categoryBitMask = BOSS_CATEGORY;
    }
    else if (_bossStage == 5) { // warpGen destroyed; boss death animation
        [self createExplosions:20 OnNode:_bossNode WithSize:[_bossNode calculateAccumulatedFrame].size AndInterval:0.2];
        // boss death animation
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 5.0*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           [self.deli lastAsteroidDestroyed];
        });
    }
    else {
        // ????
    }
    
    _bossStage++;
}

- (void)addEquation:(Equation*)equation ToBossPart:(SKNode*)part
{
    [[part childNodeWithName:@"collisionBody"] userData][@"frequency"] = [equation getSolution];
    [[part childNodeWithName:@"frequencyLabel"] removeFromParent];
    SKNode* labelNode = [self createLabelForEquation:equation];
    labelNode.name = @"frequencyLabel";
    [part addChild:labelNode];
}

- (void)createBoss
{
    _bossStage = 0;
    _lastAsteroidGenerated = 1;
    
    _bossNode = [SKNode node];
    
    // Do stuff
    SKNode* warpGen = [self createWarpGenerator];
    warpGen.name = @"warpGen";
    
    SKNode* asteroidGen1 = [self createAsteroidGenerator];
    asteroidGen1.name = @"asteroidGen1";
    asteroidGen1.position = CGPointMake(-170.0, 40);
    
    SKNode* asteroidGen2 = [self createAsteroidGenerator];
    asteroidGen2.name = @"asteroidGen2";
    asteroidGen2.position = CGPointMake(170.0, 40);
    
    SKNode* shieldGen1 = [self createShieldGenerator];
    shieldGen1.name = @"shieldGen1";
    shieldGen1.position = CGPointMake(-300.0, 40);
    
    SKNode* shieldGen2 = [self createShieldGenerator];
    shieldGen2.name = @"shieldGen2";
    shieldGen2.position = CGPointMake(300.0, 40);
    
    SKNode* shield = [self createShield];
    shield.name = @"shield";
    shield.position = CGPointMake(0.0, 30.0);
    
    [_bossNode addChild:shieldGen1];
    [_bossNode addChild:shieldGen2];
    [_bossNode addChild:asteroidGen1];
    [_bossNode addChild:asteroidGen2];
    [_bossNode addChild:warpGen];
    [_bossNode addChild:shield];
    
    
    _bossNode.position = CGPointMake(self.size.width/2.0, self.size.height - 180.0);
    // Do stuff
    
    [_bossNode setScale:0.85];
    
    [self addChild:_bossNode];
}

- (SKNode*)createShield
{
    SKNode* container = [SKNode node];
    SKSpriteNode* shield = [SKSpriteNode spriteNodeWithImageNamed:@"shield"];
    
    shield.name = @"collisionBody";
    
    shield.blendMode = SKBlendModeAdd;
    shield.alpha = 0.5;
    [shield setScale:1.25];
    
    // Set up the generator's contact detection body
    shield.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:shield.size.width/2.0*0.9];
    shield.physicsBody.dynamic = YES; // 2
    shield.physicsBody.categoryBitMask = SHIELD_CATEGORY; // 3
    shield.physicsBody.contactTestBitMask = LASER_CATEGORY; // 4
    shield.physicsBody.collisionBitMask = 0; // 5
    
    SKAction* shieldScaleUp = [SKAction scaleTo:1.28 duration:3.0];
    SKAction* shieldScaleDown = [SKAction scaleTo:1.22 duration:3.0];
    [shield runAction:[SKAction repeatActionForever:[SKAction sequence:@[shieldScaleUp, shieldScaleDown]]]];
    [container addChild:shield];
    return container;
}

- (SKNode*)createShieldGenerator
{
    SKNode* container = [SKNode node];
    SKSpriteNode* shieldGen = [SKSpriteNode spriteNodeWithImageNamed:@"shieldgen"];
    shieldGen.userData = [NSMutableDictionary dictionary];
    [shieldGen userData][@"hitPoints"] = [NSNumber numberWithInt:SHIELDGEN_HP];
    
    shieldGen.name = @"collisionBody";
    
    // Set up the generator's contact detection body
    shieldGen.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:shieldGen.size];
    shieldGen.physicsBody.dynamic = YES; // 2
    shieldGen.physicsBody.categoryBitMask = BOSS_CATEGORY; // 3
    shieldGen.physicsBody.contactTestBitMask = LASER_CATEGORY; // 4
    shieldGen.physicsBody.collisionBitMask = 0; // 5
    
    shieldGen.yScale = -1.0;
    
    SKSpriteNode* shieldCore = [SKSpriteNode spriteNodeWithImageNamed:@"tube"];
    shieldCore.name = @"shieldCore";
    [shieldCore runAction:[SKAction rotateByAngle:M_PI/-2.0 duration:0]];
    shieldCore.position = CGPointMake(0.0, 30.0); // This is a really bad guess tbh
    
    [container addChild:shieldCore];
    [container addChild:shieldGen];
    return container;
}

- (SKNode*)createAsteroidGenerator
{
    SKNode* container = [SKNode node];
    SKSpriteNode* asteroidGen = [SKSpriteNode spriteNodeWithImageNamed:@"asteroidgen"];
    asteroidGen.userData = [NSMutableDictionary dictionary];
    [asteroidGen userData][@"hitPoints"] = [NSNumber numberWithInt:ASTEROIDGEN_HP];
    
    asteroidGen.name = @"collisionBody";
    
    // Set up the generator's contact detection body
    asteroidGen.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:asteroidGen.size];
    asteroidGen.physicsBody.dynamic = YES; // 2
    asteroidGen.physicsBody.categoryBitMask = 0; // 3
    asteroidGen.physicsBody.contactTestBitMask = LASER_CATEGORY; // 4
    asteroidGen.physicsBody.collisionBitMask = 0; // 5
    
    asteroidGen.yScale = -1.0;
    
    [container addChild:asteroidGen];

    return container;

}

- (SKNode*)createWarpGenerator
{
    SKNode* container = [SKNode node];
    SKSpriteNode* warpGen = [SKSpriteNode spriteNodeWithImageNamed:@"warpgen"];
    warpGen.userData = [NSMutableDictionary dictionary];
    [warpGen userData][@"hitPoints"] = [NSNumber numberWithInt:WARPGEN_HP];
    
    warpGen.name = @"collisionBody";
    
    // Set up the generator's contact detection body
    warpGen.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:warpGen.size];
    warpGen.physicsBody.dynamic = YES; // 2
    warpGen.physicsBody.categoryBitMask = 0; // 3
    warpGen.physicsBody.contactTestBitMask = LASER_CATEGORY; // 4
    warpGen.physicsBody.collisionBitMask = 0; // 5
    
    warpGen.yScale = -1.0;
    
    SKSpriteNode* warpField = [SKSpriteNode spriteNodeWithImageNamed:@"glowball"];
    warpField.alpha = 0.5;
    warpField.blendMode = SKBlendModeMultiplyX2;
    
    // Add animation effects to the warp field
    SKAction* fadeIn = [SKAction fadeAlphaBy:0.4 duration:1.2];
    SKAction* fadeOut = [SKAction fadeAlphaBy:-0.4 duration:1.2];
    [warpField runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeIn, fadeOut]] ]];
    [warpField runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:-360.0 duration:5]]];
    
    // The Multiply blend mode makes transparency appear black, so we have to mask the warp field
    SKSpriteNode* warpFieldMaskNode = [SKSpriteNode spriteNodeWithImageNamed:@"glowball"];
    SKCropNode* warpFieldCrop = [SKCropNode node];
    [warpFieldCrop setMaskNode:warpFieldMaskNode];
    [warpFieldCrop addChild:warpField];
    warpFieldCrop.name = @"warpField";
    
    // Make the sprite actually cover the whole inner circle of the generator
    [warpFieldCrop setScale:0.8];
    
    SKSpriteNode* warpGlow = [SKSpriteNode spriteNodeWithImageNamed:@"glowball"];
    warpGlow.name = @"warpGlow";
    warpGlow.alpha = 0.5;
    warpGlow.blendMode = SKBlendModeAdd;
    
    SKAction* fadeIn2 = [SKAction fadeAlphaBy:0.3 duration:1];
    SKAction* fadeOut2 = [SKAction fadeAlphaBy:-0.3 duration:1];
    [warpGlow runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeIn2, fadeOut2]] ]];
    [warpGlow runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360.0 duration:5]]];
    
    [warpGlow setScale:1.1];
    
    SKSpriteNode* warpCore = [SKSpriteNode spriteNodeWithImageNamed:@"tube"];
    warpCore.name = @"warpCore";
    [warpCore runAction:[SKAction rotateByAngle:M_PI/-2.0 duration:0]];
    warpCore.position = CGPointMake(0.0, -25.0);
    
    [container addChild:warpCore];
    [container addChild:warpGen];
    [container addChild:warpGlow];
    [container addChild:warpFieldCrop];
    
    return container;
}

// Spawns an asteroid with a corresponding equation at a random x location
- (void)createAsteroid: (Equation*)equation
{
    CGPoint start;
    
    if (_lastAsteroidGenerated == 1) {
        _lastAsteroidGenerated = 2;
        
        if (_asteroidGenTwoDestroyed) {
            return;
        }
        
        start = CGPointMake(self.size.width - 220.0, self.size.height - 180.0);
    }
    else {
        _lastAsteroidGenerated = 1;
        
        if (_asteroidGenOneDestroyed) {
            return;
        }
        
        start = CGPointMake(220.0, self.size.height - 180.0);
    }
    
    // Create the asteroid sprite
    SKSpriteNode* asteroid = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    
    // Set up the asteroid's contact detection body
    asteroid.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:asteroid.size.width/2];
    asteroid.physicsBody.dynamic = YES; // 2
    asteroid.physicsBody.categoryBitMask = ASTEROID_CATEGORY; // 3
    asteroid.physicsBody.contactTestBitMask = LASER_CATEGORY; // 4
    asteroid.physicsBody.collisionBitMask = 0; // 5
    
    // Create the asteroid at the position of the corresponding asteroid generator
    asteroid.position = start;
    [self addChild:asteroid];
    
    // Determine speed of the asteroid
    int minDuration = MINIMUM_ASTEROID_DURATION;
    int rangeDuration = minDuration * 0.1;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Determine a slight random x offset so the asteroids will not just travel straight down
    int endX = start.x;
    endX += arc4random_uniform(self.frame.size.width);
    endX -= arc4random_uniform(self.frame.size.width);
    
    int minX = asteroid.size.width * 1.2;
    int maxX = self.frame.size.width - asteroid.size.width * 1.2;
    
    if (endX < minX) {
        endX = minX;
    } else if (endX > maxX) {
        endX = maxX;
    }
    
    // TODO make an asteroid generation animation!
    
    asteroid.userData = [NSMutableDictionary dictionary];
    // Store the solution for the equation, the laser frequency which will destroy the asteroid
    [asteroid userData][@"frequency"] = [equation getSolution];
    // Store the number of wrong answers left before the asteroid will change its equation
    [asteroid userData][@"attemptsLeft"] = [NSNumber numberWithInt:2]; //[NSNumber numberWithInt:ALLOWED_WRONG_ANSWERS];
    
    // Display the equation on the asteroid sprite
    [asteroid addChild:[self createLabelForEquation:equation]];
    
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
    SKLabelNode* numer = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica-Bold"];
    numer.text = [NSString stringWithFormat:@"%d", [fraction numerator]];
    numer.fontSize = 24;
    numer.fontColor = [UIColor whiteColor];
    numer.position = CGPointMake(0.0, 5.0);
    
    // Create a label for the denominator
    SKLabelNode* denom = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica-Bold"];
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
    [self.deli asteroidReachedBottom];
}

// Calculate acceptable locations for the player sprite to prevent it from sliding off screen
- (CGPoint)boundPlayerPos:(CGPoint)newPos
{
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, [self.player size].width * 1.2);
    retval.x = MIN(retval.x, winSize.width - [self.player size].width * 1.2);
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

- (void)didMoveToView:(SKView *)view
{
    // gestureRecognizer is used to distinguish when the player is dragging on the screen
    // versus tapping
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
    
    if ((firstBody.categoryBitMask & LASER_CATEGORY) != 0 &&
        (secondBody.categoryBitMask & ASTEROID_CATEGORY) != 0) {
        [self laser:(SKSpriteNode*) firstBody.node didCollideWithAsteroid:(SKSpriteNode*) secondBody.node];
    } else if ((firstBody.categoryBitMask & LASER_CATEGORY) != 0 &&
               (secondBody.categoryBitMask & SHIELD_CATEGORY) != 0) {
        [firstBody.node removeFromParent];
        
        [secondBody.node runAction:[SKAction sequence:@[
                [SKAction colorizeWithColor:[UIColor cyanColor] colorBlendFactor:7.0 duration:0.05],
                [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2]]]];
        [secondBody.node runAction:[SKAction sequence:@[
                [SKAction fadeAlphaBy:0.3 duration:0.05],
                [SKAction fadeAlphaBy:-0.3 duration:0.2]]]];
    } else if ((firstBody.categoryBitMask & LASER_CATEGORY) != 0 &&
              (secondBody.categoryBitMask & BOSS_CATEGORY) != 0) {
        [self laser:(SKSpriteNode*)firstBody.node hitBossPart:(SKSpriteNode*)secondBody.node];
    }
}

- (void)createExplosions:(int)numExplosions OnNode:(SKNode*)node WithSize:(CGSize)size AndInterval:(CGFloat)interval
{
    for (int i = 0; i < numExplosions; i++) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, interval*i*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CGPoint mid = [self convertPoint:node.position fromNode:node];
            mid.x += arc4random_uniform((u_int32_t) size.width) - size.width/2;
            mid.y += arc4random_uniform((u_int32_t) size.height) - size.height/2;
            [self createExplosion:mid];
        });
    }
}

- (void)bossPartDestroyed:(SKSpriteNode*)part
{
    NSString* name = [part parent].name;
    if ([name isEqualToString:@"shieldGen1"] || [name isEqualToString:@"shieldGen2"]) {
        SKSpriteNode* tubeNode = (SKSpriteNode*)[[part parent] childNodeWithName:@"shieldCore"];
        [tubeNode runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"tube_dead"]]];
    }
    else if ([name isEqualToString:@"asteroidGen1"]) {
        _asteroidGenOneDestroyed = YES;
    }
    else if ([name isEqualToString:@"asteroidGen2"]) {
        _asteroidGenTwoDestroyed = YES;
    }
    else if ([name isEqualToString:@"warpGen"]) {
        SKSpriteNode* tubeNode = (SKSpriteNode*)[[part parent] childNodeWithName:@"warpCore"];
        [tubeNode runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"tube_dead"]]];
        
        [[[part parent] childNodeWithName:@"warpField"] runAction:[SKAction fadeAlphaTo:0.0 duration:2.0]];
        [[[part parent] childNodeWithName:@"warpGlow"] runAction:[SKAction fadeAlphaTo:0.0 duration:1.0]];
        
    }
    else {
        // ????
    }
    
    [part runAction:[SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.5 duration:0]];
    
    [self createExplosions:10 OnNode:part WithSize:part.size AndInterval:0.3];
    
    [[[part parent] childNodeWithName:@"frequencyLabel"] removeFromParent];
    part.physicsBody.categoryBitMask = DEAD_BOSS_CATEGORY;
    [self advanceBossStage];
}

- (void)laser:(SKSpriteNode*)laser didCollideWithAsteroid:(SKSpriteNode*)asteroid
{
    Fraction* laserFrequency = [laser userData][@"frequency"];
    Fraction* asteroidFrequency = [asteroid userData][@"frequency"];
    
    // If the frequencies are the same, destroy both sprites and increment score
    if ([laserFrequency compare:asteroidFrequency] == NSOrderedSame) {
        // Spawn animated explosion sprite
        [self createExplosion:[asteroid position]];
        
        // Calculate the score for the destroyed asteroid and spawn a notice with that score
        int asteroidScore = (10 + (int) asteroid.position.y / 100) * 10;
        [self asteroidDestroyed: (int)asteroidScore];
        [self notifyWithPosition: asteroid.position andScore: asteroidScore andPositive:YES];
        
        // Remove the asteroid sprite
        [asteroid removeFromParent];
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


- (void)laser:(SKSpriteNode*)laser hitBossPart:(SKSpriteNode*)part
{
    Fraction* laserFrequency = [laser userData][@"frequency"];
    Fraction* targetFrequency = [part userData][@"frequency"];
    
    if ([laserFrequency compare:targetFrequency] == NSOrderedSame) {
        int hitPoints = [[part userData][@"hitPoints"] intValue];
        
        if (hitPoints <= 0) {
            return; // We don't want to "damage" to an already-destroyed part.
        }
        
        hitPoints--;
        [part userData][@"hitPoints"] = [NSNumber numberWithInt:hitPoints];
        
        if (hitPoints <= 0) {
            [self bossPartDestroyed:part];
        }
        else {
            [self runAction:[SKAction playSoundFileNamed:@"ryansnook__medium-explosion.wav" waitForCompletion:NO]];
            CGPoint location = [self convertPoint:part.position fromNode:part];
            [self createExplosion:location];
            
            int score = 500; // TODO how should we decide this?  I have no ideas
            
            [self asteroidDestroyed:score]; // TODO this isn't an asteroid so we shouldn't use this method
            [self notifyWithPosition:location andScore:score andPositive:YES];
            
            // TODO now we have to put a new equation on the asteroid.  Uhhhhhhhhhh
            // BUGBUG this is the hacky fix.  need new delegate protocols.
            [self notifyWithPosition: part.position andScore: 50 andPositive:NO];
            Equation* newEquation = [self.deli wrongAnswerAttempt:laserFrequency];
            [self addEquation:newEquation ToBossPart:[part parent]];
        }
    }
    else {
        // Check how many wrong attempts are left for this part
        int attemptsLeft = [[part userData][@"attemptsLeft"] intValue];
        attemptsLeft--;
        
        // If all attempts are used, change the equation to prevent spamming
        if (attemptsLeft <= 0) {
            [self notifyWithPosition: part.position andScore: 50 andPositive:NO];
            Equation* newEquation = [self.deli wrongAnswerAttempt:laserFrequency];
            [self addEquation:newEquation ToBossPart:[part parent]];
            
            // Reset the number of attempts left
            attemptsLeft = ALLOWED_WRONG_ANSWERS;
        }
        [part userData][@"attemptsLeft"] = [NSNumber numberWithInt:attemptsLeft];
    }
    [laser removeFromParent];
}

// Clear the remaining asteroids in the scene
-(void)removeAllAsteroids
{
    [self enumerateChildNodesWithName:@"asteroid" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}


@end