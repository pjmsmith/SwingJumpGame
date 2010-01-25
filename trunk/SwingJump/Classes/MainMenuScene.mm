//
//  MainMenuScene.m
//  SwingJump
//
//  Created by Patrick Smith on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.hh"
#import "SimpleAudioEngine.h"
#import "GameScene.hh"
#import "Box2D.h"
#import "GLES-Render.h"

#define PTM_RATIO 32
#define numLinks 28
float yPos = 250.0f;
float xPos = (480.0f/2)/32;
bool disableMusic = false;
b2World *world;

@implementation MainMenuScene
- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite * bg01 = [CCSprite spriteWithFile:@"bg01.png"];
		[bg01 setScale:2.3f];
		//[bg01 setPosition:ccp(0,-50)];
        [bg01 setPosition:ccp(440, 240)]; //the positioning is weird...I made it so it matches with the Default.png's positioning (less noticeable on load)
        [self addChild:bg01 z:0];
		
		CCSprite * bg02 = [CCSprite spriteWithFile:@"bg02.png"];
        [bg02 setPosition:ccp(240, 240)];
		[bg02 setScale:1.5f];
		[self addChild:bg02 z:1];
		
		CCSprite * fg = [CCSprite spriteWithFile:@"fg.png"];
		//[fg setPosition:ccp(0,-50)];
		[fg setPosition:ccp(240, 240)];
		[self addChild:fg z:2];
		
		CCSprite * title = [CCSprite spriteWithFile:@"title.png"];
		//[fg setPosition:ccp(0,-50)];
		[title setPosition:ccp(240, 250)];
		[self addChild:title z:2];
		
		[self addChild:[MenuLayer node] z:4];
		[self addChild:[SwingLayer node] z:3];

		
    }
    return self;
}
@end
@implementation SwingLayer

- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite *swingSet = [CCSprite spriteWithFile:@"swingset_supports.png"];
        //[swingSet setScaleY:1.6];
        [swingSet setPosition:ccp(xPos*PTM_RATIO,yPos-80.0f)];
        [self addChild:swingSet z:4];
		
		//Create a world
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		b2AABB worldAABB;
        
		float borderSize = 96/PTM_RATIO;
		worldAABB.lowerBound.Set(-20*borderSize, -20*borderSize);
		worldAABB.upperBound.Set(20*screenSize.width/PTM_RATIO+borderSize, 20*screenSize.height/PTM_RATIO+borderSize);
		b2Vec2 gravity(0.0f, -10.0f);
		bool doSleep = true;
		world= new b2World(worldAABB, gravity, doSleep);
		world->SetContinuousPhysics(true);
        
		GLESDebugDraw *m_debugDraw = new GLESDebugDraw(PTM_RATIO);
		uint32 flags = 0;
		flags += 1	* b2DebugDraw::e_shapeBit;
		//flags += 1	* b2DebugDraw::e_jointBit;
		//flags += 1	* b2DebugDraw::e_controllerBit;
		flags += 1	* b2DebugDraw::e_coreShapeBit;
		//flags += 1	* b2DebugDraw::e_aabbBit;
		//flags += 1	* b2DebugDraw::e_obbBit;
		//flags += 1	* b2DebugDraw::e_pairBit;
		//flags += 1	* b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);
		world->SetDebugDraw(m_debugDraw);
		
		//Create pivot point for swing
		b2BodyDef pivotBodyDef;
		pivotBodyDef.position.Set(xPos, (yPos+1.0f)/PTM_RATIO);
		b2Body* pivotBody = world ->CreateBody(&pivotBodyDef);
		b2PolygonDef pivotBodyShapeDef;
		pivotBodyShapeDef.SetAsBox(0.1f,.1f);
		pivotBody->CreateShape(&pivotBodyShapeDef);
		
		
		//Create chain body and shape
		b2BodyDef chainBodyDef;
		b2CircleDef chainShapeDef;
		b2RevoluteJointDef rj;
		b2DistanceJointDef dj;
		b2Body *link = pivotBody;
		b2Body *links[numLinks];
		int i;
		for(i = 0; i < numLinks; i++)
		{
			chainBodyDef.position.Set(xPos,(yPos-(5*i))/PTM_RATIO);
			b2Body *chainBody = world->CreateBody(&chainBodyDef);
			chainShapeDef.radius = (1.5f/PTM_RATIO);
			chainShapeDef.density =  50.0f;
			chainShapeDef.friction = 0.5f;
			chainShapeDef.restitution = 0.0f;
			chainShapeDef.filter.categoryBits = 0x0000;
			chainBody->CreateShape(&chainShapeDef);
			chainBody->SetMassFromShapes();
			
			/*rj.Initialize(&(*chainBody), &(*link), link->GetPosition());
			 rj.enableMotor = true;
			 rj.maxMotorTorque = 0.0f;
			 rj.motorSpeed = 0.0f;
			 world->CreateJoint(&rj);
			 */
			dj.Initialize(&(*chainBody), &(*link), chainBody->GetPosition(),link->GetPosition());
			dj.length = 5.0f/PTM_RATIO;
			world->CreateJoint(&dj);
			
			if (i>3){
				dj.Initialize(&(*chainBody), &(*links[i-3]), chainBody->GetPosition(),links[i-3]->GetPosition());
				dj.length = 15.0f/PTM_RATIO;
				//dj.frequencyHz = 12.0f;
				world->CreateJoint(&dj);
			}
			
			link = chainBody;
			links[i] = link;
		}
		b2PolygonDef swingSeat;
		chainBodyDef.position.Set(xPos,(yPos-(5*i))/PTM_RATIO);
		b2Body *chainBody = world->CreateBody(&chainBodyDef);
		swingSeat.SetAsBox(0.3f, 0.1f);
		swingSeat.density =  100.0f;
		swingSeat.friction = 0.5f;
		swingSeat.restitution = 0.0f;
		chainBody->CreateShape(&swingSeat);
		chainBody->SetMassFromShapes();
		
		links[numLinks-1] = chainBody;
		
		chainBody->SetLinearVelocity(b2Vec2(10.0f,0));
		b2RevoluteJointDef revDef;
		
		revDef.Initialize(&(*chainBody), &(*link), chainBody->GetPosition());
		revDef.lowerAngle= -0.125f * b2_pi;
		revDef.upperAngle= 0.125f * b2_pi;
		revDef.enableLimit = true;
		world->CreateJoint(&revDef); 
		
		b2Vec2 seatPos = links[numLinks-1]->GetPosition();
		b2Vec2 rseatPos = seatPos;
		b2Vec2 lseatPos = seatPos;
		lseatPos.x = seatPos.x - 0.2f;
		rseatPos.x = seatPos.x + 0.2f;
		//seatPos.x = seatPos.x-.2f;
		//seatPos.y = seatPos.y+.01f;
		b2DistanceJointDef jointDef;
		jointDef.Initialize(&(*links[numLinks-3]), &(*links[numLinks-1]), links[numLinks-3]->GetPosition(), lseatPos);
		jointDef.collideConnected = false;
		//jointDef.frequencyHz = 12.0f;
		jointDef.length = 15.4f/PTM_RATIO;
		world->CreateJoint(&jointDef);
		
		jointDef.Initialize(&(*links[numLinks-3]), &(*links[numLinks-1]), links[numLinks-3]->GetPosition(), rseatPos);
		jointDef.collideConnected = false;
		//jointDef.frequencyHz = 12.0f;
		jointDef.length = 15.4f/PTM_RATIO;
		world->CreateJoint(&jointDef);
		
		[self schedule:@selector(tick:)];
		
		//timeStationary = 0;
		
    }
    return self;
}
-(void) draw{
	[super draw];
	glEnableClientState(GL_VERTEX_ARRAY);
	world->DrawDebugData();
	glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)tick:(ccTime) dt{
	world->Step(dt, 40, 10);
}

@end
@implementation MenuLayer

- (id) init {
    self = [super init];
    if (self != nil) {
        [CCMenuItemFont setFontSize:25];
        [CCMenuItemFont setFontName:@"Marker Felt"];
		
		CCMenuItemFont *space1 = [CCMenuItemFont itemFromString: @" "];
		CCMenuItemFont *space2 = [CCMenuItemFont itemFromString: @" "];
		CCMenuItemFont *space3 = [CCMenuItemFont itemFromString: @" "];
        CCMenuItem *start = [CCMenuItemFont itemFromString:@"Start Game"
                                                target:self
                                              selector:@selector(startGame:)];
        CCMenuItem *help = [CCMenuItemFont itemFromString:@"Instructions"
                                               target:self
                                             selector:@selector(help:)];
		CCMenuItem *options = [CCMenuItemFont itemFromString:@"Options"
												   target:self
												 selector:@selector(help:)];
		CCMenuItem *scoreboard = [CCMenuItemFont itemFromString:@"Scoreboard"
												   target:self
												 selector:@selector(help:)];
        CCMenu *menu = [CCMenu menuWithItems:start, space3, help, space1, space2, scoreboard, options, nil];
		//[menu alignItemsHorizontallyWithPadding:100.0f];
		[menu alignItemsInColumns:[NSNumber numberWithUnsignedInt:3],[NSNumber numberWithUnsignedInt:2], [NSNumber numberWithUnsignedInt:2], nil];
		[menu setPosition:ccp(230.0f,68.0f)];
		//[menu alignItemsVerticallyWithPadding:100];
        [self addChild:menu];

		CCMenuItem *soundOn = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithFile:@"soundON.png"] selectedSprite:[CCSprite spriteWithFile:@"soundON.png"]];
		//[soundOn setScale:0.2f];
		CCMenuItem *soundOff = [CCMenuItemImage itemFromNormalSprite:[CCSprite spriteWithFile:@"soundOFF.png"] selectedSprite:[CCSprite spriteWithFile:@"soundOFF.png"]];
		//[soundOff setScale:0.2f];
		CCMenuItemToggle *toggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleSound:) items:soundOn,soundOff,nil];
		CCMenu *menuSound = [CCMenu menuWithItems:toggle, nil];
		//[menuSound setOpacity:128];
		[menuSound setPosition:ccp(450,20)];
		[self addChild:menuSound];
		
		if (disableMusic) {
			toggle.selectedIndex = 1;
		}
		else {
				if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
					[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hz_t_menumusic.mp3"];
				}
		}
		
    }
    return self;
}

-(void)toggleSound: (id)sender {
	if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hz_t_menumusic.mp3"];
		disableMusic = false;
		
    }
    else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
		disableMusic = true;
    }
	
	
}

-(void)startGame: (id)sender {
	GameScene * gs = [GameScene node];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.0 scene: gs]];
    NSLog(@"start game");
}
-(void)help: (id)sender {
       
	NSLog(@"help");
}
@end