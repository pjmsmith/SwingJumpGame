//
//  GameLayer.mm
//  SwingJump
//
//  Created by Patrick Smith on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.hh"
#import "GameScene.hh"
#import "ControlLayer.hh"
#include <algorithm>
#import "EndGameLayer.hh"

#define PTM_RATIO 32

b2Body* links[numLinks];
float camX;
float camY;
Biped* ragdoll;
b2Body *chainBody;
b2Body* groundBody;
b2DistanceJointDef jointDef;
b2Joint *assJoint1;
b2Joint *assJoint2;
b2Joint *assJoint3;
b2Joint *handJoint1;
b2Joint *handJoint2;
b2Joint *headJoint;
b2Vec2 lastCamPos;
b2Vec2 camPos;
float timeStationary;
ContactListener *contactListener;
float MB_WIDTH  = 2.6f; //monkey bar collision box width

const int32 k_maxtype = 100;
const int32 k_numTypes = 4;

b2Body* type1[k_maxtype];
b2Body* type2[k_maxtype];
b2Body* type3[k_maxtype];
b2Body* type4[k_maxtype];
int32 typeCount[k_numTypes];

@implementation Actor
@synthesize type;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.type = -1;
    }
    return self;
}

- (void)dealloc {
	[super dealloc];
}

@end


void ContactListener::Add(const b2ContactPoint* point) {
	if(((Actor*)point->shape1->GetBody()->GetUserData()).type > 0 || ((Actor*)point->shape2->GetBody()->GetUserData()).type > 0)
    {
        if(((Actor*)point->shape1->GetBody()->GetUserData()).type == 1) {
			type1[typeCount[0]++] = point->shape1->GetBody();
			printf("Collision with Type 1");
		}
		else if (((Actor*)point->shape2->GetBody()->GetUserData()).type == 1){ 
			type1[typeCount[0]++] = point->shape2->GetBody();
			printf("Collision with Type 1");
		}
		
		else if (((Actor*)point->shape1->GetBody()->GetUserData()).type == 2) {
			type2[typeCount[1]++] = point->shape1->GetBody();
			printf("Collision with Type 2");
		}
		else if (((Actor*)point->shape2->GetBody()->GetUserData()).type == 2){ 
			type2[typeCount[1]++] = point->shape2->GetBody();
			printf("Collision with Type 2");
		}
		
		else if (((Actor*)point->shape1->GetBody()->GetUserData()).type == 3) {
			type3[typeCount[2]++] = point->shape1->GetBody();
			printf("Collision with Type 3");
		}
		else if (((Actor*)point->shape2->GetBody()->GetUserData()).type == 3){ 
			type3[typeCount[2]++] = point->shape2->GetBody();
			printf("Collision with Type 3");
		}
		
		else if (((Actor*)point->shape1->GetBody()->GetUserData()).type == 4) {
			type4[typeCount[3]++] = point->shape1->GetBody();
			printf("Collision with Type 3");
		}
		else if (((Actor*)point->shape2->GetBody()->GetUserData()).type == 4){ 
			type4[typeCount[3]++] = point->shape2->GetBody();
			printf("Collision with Type 3");
		}
		
        
	}
}

void ContactListener::Persist(const b2ContactPoint* point) {

}
void ContactListener::Remove(const b2ContactPoint* point) {
    
}
void ContactListener::Result(const b2ContactResult* result) {

}

@implementation GameLayer
@synthesize world;
@synthesize maxSpeed;
@synthesize maxHeight;
@synthesize noType1;
@synthesize noType2;
@synthesize noType3;
@synthesize noType4;

- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite *swingSet = [CCSprite spriteWithFile:@"swingset_supports.png"];
        [swingSet setScaleY:1.6];
        [swingSet setPosition:ccp(240,210)];
        [self addChild:swingSet z:4];
		
		maxSpeed = 0.0f;
		
		//Create a world
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		b2AABB worldAABB;
        
		worldAABB.lowerBound.Set(-100.0, -100.0);
		worldAABB.upperBound.Set(20000.0f, 20000.0f);
		b2Vec2 gravity(0.0f, -10.0f);
		bool doSleep = true;
		world = new b2World(worldAABB, gravity, doSleep);
		world->SetContinuousPhysics(true);
		
        contactListener = new ContactListener();
        world->SetContactListener(contactListener);
        
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
		
		//Create a ground box
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(screenSize.width/PTM_RATIO/2, 1.3f);
        //Actor* a = [[Actor alloc] init];
        //a.type = 2;
        //groundBodyDef.userData = a;
        
		groundBody = world->CreateBody(&groundBodyDef);
		b2PolygonDef groundShapeDef;
		groundShapeDef.SetAsBox(screenSize.width/PTM_RATIO, 1.0f);
		groundBody->CreateShape(&groundShapeDef);
		
        [self createSwingChain:350.0f];
		
		[self schedule:@selector(tick:)];
		
		timeStationary = 0;
		
    }
    return self;
}

-(void) createSwingChain:(float)yPos
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    //Create pivot point for swing
    b2BodyDef pivotBodyDef;
    pivotBodyDef.position.Set(screenSize.width/PTM_RATIO/2, (yPos+1.0f)/PTM_RATIO);
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
    int i;
    for(i = 0; i < numLinks; i++)
    {
        chainBodyDef.position.Set(7.5f,(yPos-(5*i))/PTM_RATIO);
        chainBody = world->CreateBody(&chainBodyDef);
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
    chainBodyDef.position.Set(7.5f,(yPos-(5*i))/PTM_RATIO);
    chainBody = world->CreateBody(&chainBodyDef);
    swingSeat.SetAsBox(0.3f, 0.1f);
    swingSeat.density =  10.0f;
    swingSeat.friction = 0.5f;
    swingSeat.restitution = 0.0f;
    chainBody->CreateShape(&swingSeat);
    chainBody->SetMassFromShapes();
    
    links[numLinks-1] = chainBody;
    
    b2RevoluteJointDef revDef;
    b2PrismaticJointDef prismaticJoint;
    revDef.Initialize(&(*chainBody), &(*link), chainBody->GetPosition());
    revDef.lowerAngle= -0.125f * b2_pi;
    revDef.upperAngle= 0.125f * b2_pi;
    revDef.enableLimit = true;
    world->CreateJoint(&revDef); 
    
    ragdoll = new Biped(world, b2Vec2(470.0f/PTM_RATIO/2, 165.0f/PTM_RATIO));
	ragdoll->setLaunched(false);

	jointDef.Initialize(ragdoll->RHand, &(*links[handLink]), ragdoll->RHand->GetPosition(), links[handLink]->GetPosition());
    jointDef.collideConnected = false;
	jointDef.length = 0.1f;
	jointDef.dampingRatio = 1.0f;
	//jointDef.frequencyHz = 1000.0f;
	handJoint1 = world->CreateJoint(&jointDef);  
	
    jointDef.Initialize(ragdoll->LHand, &(*links[handLink]), ragdoll->LHand->GetPosition(), links[handLink]->GetPosition());
    jointDef.collideConnected = false;
	jointDef.length = 0.1f;
	jointDef.dampingRatio = 1.0f;
	//jointDef.frequencyHz = 100.0f;
    handJoint2 = world->CreateJoint(&jointDef); 
	
	jointDef.dampingRatio = 0.0f;
	jointDef.frequencyHz = 0.0f;
	
    b2Vec2 seatPos = links[numLinks-1]->GetPosition();
	b2Vec2 rseatPos = seatPos;
	b2Vec2 lseatPos = seatPos;
	lseatPos.x = seatPos.x - 0.5f;
	rseatPos.x = seatPos.x + 0.4f;
	//seatPos.x = seatPos.x-.2f;
    //seatPos.y = seatPos.y+.01f;
    
	/*jointDef.Initialize(&(*links[0]), &(*links[numLinks-1]), links[0]->GetPosition(), seatPos);
	 jointDef.collideConnected = false;
	 jointDef.length = 5.2*(numLinks)/PTM_RATIO;
	 //jointDef.frequencyHz = 12.0f;
	 world->CreateJoint(&jointDef);
	 //jointDef.frequencyHz = 0.0f;*/
    
	jointDef.Initialize(&(*links[0]), &(*links[numLinks-1]), links[0]->GetPosition(), lseatPos);
    jointDef.collideConnected = false;
	//jointDef.frequencyHz = 12.0f;
	jointDef.length = 5.1f*(numLinks)/PTM_RATIO;
    world->CreateJoint(&jointDef);
	
	jointDef.Initialize(&(*links[0]), &(*links[numLinks-1]), links[0]->GetPosition(), rseatPos);
    jointDef.collideConnected = false;
	//jointDef.frequencyHz = 12.0f;
	jointDef.length = 5.1f*numLinks/PTM_RATIO;
    world->CreateJoint(&jointDef);
	
    jointDef.Initialize(ragdoll->Pelvis, &(*links[numLinks-1]), ragdoll->Pelvis->GetPosition(), lseatPos);
    jointDef.collideConnected = false;
	jointDef.frequencyHz = 0.0f;
	jointDef.length = 0.023f;
    assJoint1 = world->CreateJoint(&jointDef);
	
	jointDef.Initialize(ragdoll->RThigh, &(*links[numLinks-1]), ragdoll->RThigh->GetPosition(), rseatPos);
    jointDef.collideConnected = false;
	jointDef.length = 0.05f;
	assJoint2 = world->CreateJoint(&jointDef);
	
	jointDef.Initialize(ragdoll->LThigh, &(*links[numLinks-1]), ragdoll->LThigh->GetPosition(), rseatPos);
    jointDef.collideConnected = false;
	jointDef.length = 0.05f;
	assJoint3 = world->CreateJoint(&jointDef);
    
	jointDef.Initialize(ragdoll->Head, &(*links[0]), ragdoll->Head->GetPosition(), links[0]->GetPosition() );
    jointDef.collideConnected = true;
	jointDef.length = headLinkLength;
	//jointDef.frequencyHz = 2.0f;
    headJoint = world->CreateJoint(&jointDef); 
    
    ragdoll->SetSittingLimits();
	camPos = ragdoll->Chest->GetPosition();
	lastCamPos = camPos;
	
	for(int i = 0; i < numLinks; i++)
    {
		links[i]->m_linearDamping=13.0f;
		links[i]->m_angularDamping=13.0f;
	}
	ragdoll->SetLinearDamping(13.0f);
	ragdoll->SetAngularDamping(13.0f);
}

-(void) draw{
	[super draw];
	glEnableClientState(GL_VERTEX_ARRAY);
	world->DrawDebugData();
	glDisableClientState(GL_VERTEX_ARRAY);
}

-(void)tick:(ccTime) dt{
	world->Step(dt, 20, 10);
	
	b2Vec2 camPos;
	camPos = ragdoll->Chest->GetPosition();
	camX = camPos.x;
	camY = camPos.y;
	if (camY<240/PTM_RATIO) {
		camY = 240/PTM_RATIO;
	}
	float eyeZ = 415.0f+camY*3;
	if (eyeZ >1000.0f) {
		eyeZ = 1000.0f;
	}
	//b2Vec2 vel = ragdoll->Head->GetLinearVelocity();
	b2Vec2 scrolldiff = b2Vec2((camX-lastCamPos.x)*PTM_RATIO,(camY-lastCamPos.y)*PTM_RATIO);
	lastCamPos = b2Vec2(camX, camY);
	[parallaxNode scrollX:scrolldiff.x scrollY:-scrolldiff.y];
	[self.camera setCenterX:camX*PTM_RATIO-80.0f centerY:camY*PTM_RATIO+80.0f centerZ:(100+eyeZ/8)];
	[self.camera setEyeX:camX*PTM_RATIO-80.0f eyeY:camY*PTM_RATIO+80.0f eyeZ:eyeZ];
	
	//Nuke Bodies and Perform Actions
	if (typeCount>(int32)0) {
		[self CollisionHandler];
	}
	
	//Move Ground
	groundBody->SetXForm(b2Vec2((camX*PTM_RATIO-80.0f)/PTM_RATIO,2.0f), 0.0f);
	
	//Create Objects
	if(ragdoll->hasLaunched()) {
		[self CreateRandomObjects];
	}
	//Delete Objects
	[self RemovePastObjects];
	
	//Detect Stopped
	if (ragdoll->hasLaunched()) {
		[self DetectStopped:dt];
	}
	
	//Detect High Scores
	b2Vec2 vel = ragdoll->Chest->GetLinearVelocity();
	float speed =  sqrt(vel.x*vel.x+vel.y*vel.y);
	if (speed > maxSpeed) {
		maxSpeed = speed;	
	}
	
	float height = ragdoll->Chest->GetPosition().y;
	if (height > maxHeight) {
		maxHeight = height;
	}
	
}

-(void)CollisionHandler{
	if (typeCount[0] > 0 ) {
		std::sort(type1, type1 + typeCount[0]);
		int32 i = 0;
		while(i < typeCount[0])
		{
			b2Body* b = type1[i++];
			while (i < typeCount[0] && type1[i] == b)
			{
				++i;
			}
			b2Vec2 point =  b->GetPosition();
			world->DestroyBody(b);
			
			ragdoll->ApplyImpulse(b2Vec2(1.0f,1.0f), point);
		}
		b2Body *null;
		for(i = 0; i<typeCount[0];i++){
			type1[i] = null;
		}
		typeCount[0] = 0;
		noType1++;
	}
	
	else if (typeCount[1] > 0 ) {
		std::sort(type2, type2 + typeCount[1]);
		int32 i = 0;
		while(i < typeCount[1])
		{
			b2Body* b = type2[i++];
			while (i < typeCount[1] && type2[i] == b)
			{
				++i;
			}
			b2Vec2 point =  b->GetPosition();
			world->DestroyBody(b);
		}
		b2Body *null;
		for(i = 0; i<typeCount[1];i++){
			type2[i] = null;
		}
		typeCount[1] = 0;
		
		[self unschedule:@selector(tick:)];
		[(ControlLayer *)parent handleType2];
		noType2++;
	}
	
	else if (typeCount[2] > 0 ) {
		std::sort(type3, type3 + typeCount[2]);
		int32 i = 0;
		while(i < typeCount[2])
		{
			b2Body* b = type3[i++];
			while (i < typeCount[2] && type3[i] == b)
			{
				++i;
			}
			b2Vec2 point =  b->GetPosition();
			world->DestroyBody(b);
		}
		b2Body *null;
		for(i = 0; i<typeCount[2];i++){
			type3[i] = null;
		}
		typeCount[2] = 0;
		
		[self unschedule:@selector(tick:)];
		[(ControlLayer *)parent handleType3];
		noType3++;
	}
	
	else if (typeCount[3] > 0 ) {
		std::sort(type4, type4 + typeCount[3]);
		int32 i = 0;
		while(i < typeCount[3])
		{
			b2Body* b = type4[i++];
			while (i < typeCount[3] && type4[i] == b)
			{
				++i;
			}
			b2Vec2 point =  b->GetPosition();
			world->DestroyBody(b);
		}
		b2Body *null;
		for(i = 0; i<typeCount[3];i++){
			type4[i] = null;
		}
		typeCount[3] = 0;
		
		[self unschedule:@selector(tick:)];
		[(ControlLayer *)parent handleType4];
		noType4++;
	}
	
	
}

-(void)DetectStopped:(float)dt{
	b2Vec2 vel = ragdoll->Head->GetLinearVelocity();
	float linearVel = b2Sqrt((vel.x*vel.x) + (vel.y*vel.y));
	if (linearVel<speedStationaryToStop) {
		timeStationary = timeStationary+dt;
		if (timeStationary>timeStationaryToStop) {
			ragdoll->PutToSleep();
			[self unschedule:@selector(tick:)];
			EndGameLayer *egl;
			egl = [EndGameLayer node];
			[parent addChild:egl z:2];
			[[(ControlLayer *)parent hl] disableScore];
			[egl setDistance:[[(ControlLayer *)parent hl] getScore] maxSpeed:maxSpeed maxHeight:maxHeight maxMonkeyBars:[(ControlLayer *)parent getMaxMonkeyBars] fastestSwipe:[(ControlLayer *)parent getFastestSwipe] noType1:noType1 noType2:noType2 noType3:noType3];

            [self saveStats];
            [self saveHighScore];
        }
	}
	else {
		timeStationary = 0.0f;
	}
}

#pragma mark High Score and Stats Saving 
-(void)saveStats
{
    id statObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxSpeed"];
    if(statObject == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:maxSpeed] forKey:@"maxSpeed"];
    }
    else 
    {
       if(maxSpeed > [(NSNumber*)statObject floatValue])
       {
           [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:maxSpeed] forKey:@"maxSpeed"];
       }
    }

    statObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxHeight"];
    if(statObject == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:maxSpeed] forKey:@"maxHeight"];
    }
    else 
    {
        if(maxHeight > [(NSNumber*)statObject floatValue])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:maxSpeed] forKey:@"maxHeight"];
        }
    }

    statObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxMonkeyBars"];
    if(statObject == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInt:[(ControlLayer *)parent getMaxMonkeyBars]] forKey:@"maxMonkeyBars"];
    }
    else 
    {
        if([(ControlLayer *)parent getMaxMonkeyBars] > [(NSNumber*)statObject intValue])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInt:[(ControlLayer *)parent getMaxMonkeyBars]] forKey:@"maxMonkeyBars"]; 
        }
    }

    statObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"fastestSwipe"];
    if(statObject == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:[(ControlLayer *)parent getFastestSwipe]] forKey:@"fastestSwipe"];
    }
    else 
    {
        if([(ControlLayer *)parent getFastestSwipe] > [(NSNumber*)statObject floatValue])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:[(ControlLayer *)parent getFastestSwipe]] forKey:@"fastestSwipe"];
        }
    }
}

-(void)saveHighScore
{
    NSMutableArray* scores = [[NSMutableArray alloc] initWithCapacity:10];
    NSNumber* lastScore = [[NSNumber alloc] initWithFloat:[[(ControlLayer *)parent hl] getScore]];
    id scoreObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"score"];
    if(scoreObject == nil)
    {
        [scores addObject:lastScore];
        [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"score"];
        NSLog(@"new entry");
    }
    else
    {
        scores = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"score"]];
        BOOL didUpdate = false;
        NSInteger oldCount = [scores count];
        for(int i = 0; i < oldCount; i++)
        {
            if([lastScore floatValue]>[[scores objectAtIndex:i] floatValue])
            {
                didUpdate = true;
                [scores insertObject:lastScore atIndex:i];
                break;
            }
        }
        if(!didUpdate && ([scores count]<10))
        {
            //add to end
            [scores addObject:lastScore];
            didUpdate = true;
        }
        else if(didUpdate && ([scores count]>10))
        {
            //drop last value
            [scores removeLastObject];
        }
        NSLog(@"Number of objects in score list: %d", [scores count]);
        if(didUpdate)
        {
            [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"score"];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];   
}

-(void)CreateRandomObjects{
	b2Vec2 currPos = ragdoll->Head->GetPosition(); //Get Current Position
	//b2Vec2 headVel = ragdoll->Head->GetVelocity();
	if(currPos.y > 50) {
		currPos.y = 50;
	}
	int randnum = (rand()%10000)+1;
	if(randnum<randObjectPercentage/10*10000) {
		b2BodyDef collisionObjectDef;
        Actor* a = [[Actor alloc] init];
        a.type = 1;
        collisionObjectDef.userData = a;
		collisionObjectDef.position.Set(currPos.x+10.0f,3.2f);
		b2Body *collisionObject;
		collisionObject = world->CreateBody(&collisionObjectDef);
		b2PolygonDef collisionObjectShapeDef;
		collisionObjectShapeDef.SetAsBox(0.2f, 0.2f);
		collisionObject->CreateShape(&collisionObjectShapeDef);
	}
	
	randnum = (rand()%10000)+1;
	if(randnum<(randObjectPercentage/14)*10000) {
		b2BodyDef collisionObjectDef;
        Actor* a = [[Actor alloc] init];
        a.type = 2;
        collisionObjectDef.userData = a;
		collisionObjectDef.position.Set(currPos.x+10.0f, 8.0f);
		b2Body *collisionObject;
		collisionObject = world->CreateBody(&collisionObjectDef);
		b2PolygonDef collisionObjectShapeDef;
		collisionObjectShapeDef.SetAsBox(MB_WIDTH, 0.2f);
		collisionObject->CreateShape(&collisionObjectShapeDef);
	}
	
	randnum = (rand()%10000)+1;
	if(randnum<(randObjectPercentage/14)*10000) {
		b2BodyDef collisionObjectDef;
        Actor* a = [[Actor alloc] init];
        a.type = 3;
        collisionObjectDef.userData = a;
		collisionObjectDef.position.Set(currPos.x+10.0f, 3.6f);
		b2Body *collisionObject;
		collisionObject = world->CreateBody(&collisionObjectDef);
		b2PolygonDef collisionObjectShapeDef;
		collisionObjectShapeDef.SetAsBox(SS_WIDTH, 0.6f);
		collisionObject->CreateShape(&collisionObjectShapeDef);
	}
	
	randnum = (rand()%10000)+1;
	if(randnum<(randObjectPercentage/14)*10000) {
		b2BodyDef collisionObjectDef;
        Actor* a = [[Actor alloc] init];
        a.type = 4;
        collisionObjectDef.userData = a;
		collisionObjectDef.position.Set(currPos.x+10.0f, 4.0f);
		b2Body *collisionObject;
		collisionObject = world->CreateBody(&collisionObjectDef);
		b2PolygonDef collisionObjectShapeDef;
		collisionObjectShapeDef.SetAsBox(MGR_WIDTH, 1.0f);
		collisionObject->CreateShape(&collisionObjectShapeDef);
	}
}

-(void)RemovePastObjects {
	for(b2Body* b = world->GetBodyList();b;b=b->GetNext())
	{
		b2Vec2 pos = b->GetPosition();
		b2Vec2 cam = ragdoll->Head->GetPosition();
		if(pos.x<(cam.x-10.0f))
		{
			world->DestroyBody(b);
		}
	}
}

-(void)ResumeWithImpulse:(b2Vec2)impulse {
	ragdoll->ApplyImpulse(impulse,ragdoll->Chest->GetPosition());
	[self schedule:@selector(tick:)];
}

@end
