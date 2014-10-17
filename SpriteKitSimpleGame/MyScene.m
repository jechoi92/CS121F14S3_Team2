//
//  MyScene.m
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/4/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;
static NSString* const playerNodeName = @"movable";
//static NSString* const buttonNodeName = @"shoot";

// 1
@interface MyScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int monstersDestroyed;
@property (nonatomic, strong) SKSpriteNode *selectedNode;
@end

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}
 
static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}
 
static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}
 
static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}
 
// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

@implementation MyScene
 
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
 
        // 2
        //NSLog(@"Size: %@", NSStringFromCGSize(size));
 
        // 3
        //self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.backgroundColor = [SKColor blackColor];
 
        // 4
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        [self.player setScale:0.3];
        self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.width/2);
        [self addChild:self.player];
        [self.player setName:playerNodeName];
      
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
 
    }
    return self;
}

- (void)addMonster {
 
    // Create sprite
    SKSpriteNode * monster = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
    monster.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:monster.size.width/2 - 5]; // 1
    monster.physicsBody.dynamic = YES; // 2
    monster.physicsBody.categoryBitMask = monsterCategory; // 3
    monster.physicsBody.contactTestBitMask = projectileCategory; // 4
    monster.physicsBody.collisionBitMask = 0; // 5

  
    // Determine where to spawn the monster along the X axis
    int minX = monster.size.width / 2;
    int maxX = self.frame.size.width - monster.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
 
    // Create the monster slightly off-screen along the top edge,
    // and along a random position along the Y axis as calculated above
    monster.position = CGPointMake(actualX, self.frame.size.height + monster.size.height/2);
    [self addChild:monster];
 
    // Determine speed of the monster
    int minDuration = 10.0;
    int maxDuration = 14.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
 
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX, -monster.size.height/2) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction * loseAction = [SKAction runBlock:^{
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:NO];
        [self.view presentScene:gameOverScene transition: reveal];
    }];
    [monster runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
 
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
 
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 4) {
        self.lastSpawnTimeInterval = 0;
        [self addMonster];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }

    [self updateWithTimeSinceLastUpdate:timeSinceLast];
 
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}*/

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    SKSpriteNode* touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
    if(![_selectedNode isEqual:touchedNode]) {
        _selectedNode = touchedNode;
        if([[touchedNode name] isEqualToString:playerNodeName]) {
            //what
        }
//        else if([[touchedNode name] isEqualToString:buttonNodeName]) {
//            //IDK
//        }
    }
}

- (CGPoint)boundPlayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;
    CGPoint retval = newPos;
    retval.x = MAX(retval.x, [self.player size].width/2);
    retval.x = MIN(retval.x, -[self.player size].width/2 + winSize.width);
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
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        
        touchLocation = [self convertPointFromView:touchLocation];
        
        [self selectNodeForTouch:touchLocation];
        
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y);
        [self translatePlayer:translation];
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        /*if (![[_selectedNode name] isEqualToString:playerNodeName]) {
            float scrollDuration = 0.2;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint pos = [_selectedNode position];
            CGPoint p = mult(velocity, scrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
            newPos = [self boundLayerPos:newPos];
            [_selectedNode removeAllActions];
            
            SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
            [moveTo setTimingMode:SKActionTimingEaseOut];
            [_selectedNode runAction:moveTo];
        }*/
        [_selectedNode removeAllActions];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
 
    //[self runAction:[SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO]];
    [self runAction:[SKAction playSoundFileNamed:@"jobro__laser6.wav" waitForCompletion:NO]];
 
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
 
    // 2 - Set up initial location of projectile
    SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"LaserBeamSprite"];
    projectile.position = self.player.position;
    //NSLog(@"%f",projectile.size.width);
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = monsterCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    projectile.yScale = -1.0;

    // 3- Determine offset of location to projectile
    CGPoint offset = rwSub(location, projectile.position);

    // 4 - Bail out if you are shooting down or backwards
    if (offset.y <= 0) return;

    // 5 - OK to add now - we've double checked position
    [self addChild:projectile];

    // 8 - Add the shoot amount to the current position
    CGPoint realDest = CGPointMake(projectile.position.x, self.size.height);

    // 9 - Create the actions
    float velocity = 480.0/1.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    //NSLog(@"Hit");
    [self runAction:[SKAction playSoundFileNamed:@"ryansnook__medium-explosion.wav" waitForCompletion:NO]];
    [projectile removeFromParent];
    [monster removeFromParent];
    self.monstersDestroyed++;
    if (self.monstersDestroyed > 10) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size won:YES];
        [self.view presentScene:gameOverScene transition: reveal];
    }
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
 
    // 2
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
        NSLog(@"projectile x:%f y:%f monster x:%f y:%f", firstBody.node.position.x, firstBody.node.position.y, secondBody.node.position.x, secondBody.node.position.y);
    }
}

@end
