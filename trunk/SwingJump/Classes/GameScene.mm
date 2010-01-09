//
//  GameScene.mm
//  SwingJump
//
//  Created by Sean Stavropoulos on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.hh"
#import "SimpleAudioEngine.h"
#import "GameScene.hh"

#define PTM_RATIO 32

b2World *world;
b2Body* links[numLinks];

@implementation GameScene
- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite * bg = [CCSprite spriteWithFile:@"mainmenu_bg.png"]; //change this to be the level background
        [bg setPosition:ccp(240, 165)];
        [self addChild:bg z:0];
        //[self addChild:[GameLayer node] z:1];
        [self addChild:[ControlLayer node] z:1];
        [self addChild:[HUDLayer node] z:2];
    }
    return self;
}
@end

@implementation GameLayer

- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite *swingSet = [CCSprite spriteWithFile:@"swingset_supports.png"];
        [swingSet setPosition:ccp(240,160)];
        [self addChild:swingSet z:4];
        //swingChain = [CCSprite spriteWithFile:@"swingchain.png"];
        //[swingChain setAnchorPoint:ccp(0.5,1)];
        //[swingChain setPosition:ccp((swingSet.contentSize.width/2), (swingSet.contentSize.height)-2)];
        //[self addChild:swingChain z:1];
		
		
		//PHYSICS STARTS HERE
		CCSprite *ball = [CCSprite spriteWithFile:@"ball.png"];
		[ball setPosition:CGPointMake(150, 400)];
		[self addChild:ball z:0];
        
		//Create a world
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		b2AABB worldAABB;
		float borderSize = 96/PTM_RATIO;
		worldAABB.lowerBound.Set(-borderSize, -borderSize);
		worldAABB.upperBound.Set(screenSize.width/PTM_RATIO+borderSize, screenSize.height/PTM_RATIO+borderSize);
		b2Vec2 gravity(0.0f, -10.0f);
		bool doSleep = true;
		world = new b2World(worldAABB, gravity, doSleep);
        
		world->SetContinuousPhysics(true);
		
		
		GLESDebugDraw *m_debugDraw = new GLESDebugDraw(PTM_RATIO);
		uint32 flags = 0;
		flags += 1	* b2DebugDraw::e_shapeBit;
		//flags += 1	* b2DebugDraw::e_jointBit;
		//flags += 1	* b2DebugDraw::e_controllerBit;
		//flags += 1	* b2DebugDraw::e_coreShapeBit;
		//flags += 1	* b2DebugDraw::e_aabbBit;
		//flags += 1	* b2DebugDraw::e_obbBit;
		//flags += 1	* b2DebugDraw::e_pairBit;
		//flags += 1	* b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);
		world->SetDebugDraw(m_debugDraw);
		
		//Create a ground box
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(screenSize.width/PTM_RATIO/2, 1.3f);
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		b2PolygonDef groundShapeDef;
		groundShapeDef.SetAsBox(screenSize.width/PTM_RATIO, 1.0f);
		groundBody->CreateShape(&groundShapeDef);
		
        [self createSwingChain:246.0f];
        
		[self schedule:@selector(tick:)];
		
    }
    return self;
}
-(void) createSwingChain:(float)yPos
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    //Create pivot point for swing
    b2BodyDef pivotBodyDef;
    pivotBodyDef.position.Set(screenSize.width/PTM_RATIO/2, 247.0f/PTM_RATIO);
    b2Body* pivotBody = world ->CreateBody(&pivotBodyDef);
    b2PolygonDef pivotBodyShapeDef;
    pivotBodyShapeDef.SetAsBox(0.1f,.1f);
    pivotBody->CreateShape(&pivotBodyShapeDef);
    
    b2Body *chainBody;
    //Create chain body and shape
    b2BodyDef chainBodyDef;
    b2CircleDef chainShapeDef;
    b2RevoluteJointDef rj;
    b2Body *link = pivotBody;
    int i;
    for(i = 0; i < numLinks; i++)
    {
        chainBodyDef.position.Set(7.5f,(yPos-(5*i))/PTM_RATIO);
        chainBody = world->CreateBody(&chainBodyDef);
        chainShapeDef.radius = (4.0f/PTM_RATIO);
        chainShapeDef.density =  100.0f;
        chainShapeDef.friction = 0.5f;
        chainShapeDef.restitution = 0.0f;
        chainBody->CreateShape(&chainShapeDef);
        chainBody->SetMassFromShapes();
        chainBody->SetLinearVelocity(b2Vec2(0.5f,0.5f));
        
        rj.Initialize(&(*chainBody), &(*link), link->GetPosition());
        rj.motorSpeed = 0.0f;
        rj.maxMotorTorque = 3.0f;
        rj.enableMotor = true;
        world->CreateJoint(&rj);
        link = chainBody;
        links[i] = link;
    }
    b2PolygonDef swingSeat;
    chainBodyDef.position.Set(7.5f,(yPos-(5*i))/PTM_RATIO);
    chainBody = world->CreateBody(&chainBodyDef);
    swingSeat.SetAsBox(0.5f, 0.1f);
    swingSeat.density =  300.0f;
    swingSeat.friction = 0.5f;
    swingSeat.restitution = 0.0f;
    chainBody->CreateShape(&swingSeat);
    chainBody->SetMassFromShapes();
    chainBody->SetLinearVelocity(b2Vec2(0.5f,0.5f));
    links[numLinks-1] = chainBody;
    b2DistanceJointDef jointDef;
    jointDef.Initialize(&(*chainBody), &(*link), chainBody->GetPosition(), link->GetPosition());
    jointDef.collideConnected = true;
    world->CreateJoint(&jointDef);   
}

-(void) draw{
	[super draw];
	glEnableClientState(GL_VERTEX_ARRAY);
	world->DrawDebugData();
	glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)tick:(ccTime) dt{
	world->Step(dt, 10, 8);
	for(b2Body* b = world->GetBodyList();b;b=b->GetNext())
	{
		if(b->GetUserData()!=NULL)
		{
			CCSprite* ballData = (CCSprite*)b->GetUserData();
			ballData.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
		}
	}
}

@end

@implementation ControlLayer
@synthesize leftArrow;
@synthesize rightArrow;
@synthesize gl;
@synthesize isRightBeingTouched;
@synthesize isLeftBeingTouched;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.isTouchEnabled = YES;
        isRightBeingTouched = NO;
        isLeftBeingTouched = NO;
        leftArrow = [CCSprite spriteWithFile:@"circlearrow.png"];
        [leftArrow setPosition:ccp(50,160)];
        [leftArrow setOpacity:128];
        leftArrow.rotation = 180;
        [self addChild:leftArrow z:1];
        rightArrow = [CCSprite spriteWithFile:@"circlearrow.png"];
        [rightArrow setPosition:ccp(430,160)];
        [rightArrow setOpacity:128];
        [self addChild:rightArrow z:1];
        gl = [GameLayer node];
        [self addChild:gl z:0]; //added as a child so touchesEnded can call a function contained in GameLayer
        
    }
    return self;
}

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
        CGFloat tempX = location.x;
        location.x = location.y;
        location.y = tempX;
        
		if (CGRectContainsPoint([leftArrow boundingBox], location)) {
            //NSLog(@"Left touched");
            if(!isRightBeingTouched)
            {
                isLeftBeingTouched = YES;
                [leftArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:255]];
                [self performSelectorInBackground:@selector(rotateChainLeft) withObject:nil];
            }
        }
        if (CGRectContainsPoint([rightArrow boundingBox], location)) {
            //NSLog(@"Right touched");
            if(!isLeftBeingTouched)
            {
                isRightBeingTouched = YES;
                [rightArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:255]];
                [self performSelectorInBackground:@selector(rotateChainRight) withObject:nil];
            } 
        }
	}
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(isLeftBeingTouched)
    {
        [leftArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:128]];
        isLeftBeingTouched = NO;
    }
    if(isRightBeingTouched)
    {
        [rightArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:128]];
        isRightBeingTouched = NO;
    }
    
	return kEventHandled;
}

- (void)rotateChainLeft
{
    if(isLeftBeingTouched) 
    {
		links[numLinks-1]->ApplyForce(b2Vec2(-300.0f, 0.0f),links[numLinks-1]->GetPosition());
		[self runAction:[CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:0],[CCCallFunc actionWithTarget:self selector:@selector(rotateChainLeft)], nil]];
	}    
}

- (void)rotateChainRight
{
    if(isRightBeingTouched) 
    {
		links[numLinks-1]->ApplyForce(b2Vec2(300.0f, 0.0f),links[numLinks-1]->GetPosition());
		[self runAction:[CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:0],[CCCallFunc actionWithTarget:self selector:@selector(rotateChainRight)], nil]];
	}
}

@end


@implementation HUDLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [CCMenuItemFont setFontSize:14];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        CCMenuItem *start = [CCMenuItemFont itemFromString:@"Main Menu"
													target:self
												  selector:@selector(gameSceneBtn:)];
		
        CCMenu *menu = [CCMenu menuWithItems:start, nil];
        [menu setPosition:ccp(440, 10)];
        [self addChild:menu];
    }
    
    return self;
}

-(void)gameSceneBtn: (id)sender {
    MainMenuScene * ms = [MainMenuScene node];
	[[CCDirector sharedDirector] replaceScene: [CCCrossFadeTransition transitionWithDuration:0.5 scene: ms]];
}

@end