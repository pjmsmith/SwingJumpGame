//
//  GameLayer.h
//  SwingJump
//
//  Created by Patrick Smith on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Biped.h"
#import "GLES-Render.h"

#define numLinks 40
#define handLink numLinks-6
#define headLinkLength 4.5f
#define randObjectPercentage 0.5f
#define timeStationaryToStop 1.0f //seconds
#define speedStationaryToStop 1.0f //m/s

@interface Actor : CCLayer {
    NSInteger type;
}
@property (nonatomic, readwrite) NSInteger type;

@end

class ContactListener : public b2ContactListener
{
public:        
	void Add(const b2ContactPoint* point);
	void Persist(const b2ContactPoint* point);    
	void Remove(const b2ContactPoint* point);    
	void Result(const b2ContactResult* point);
};

@interface GameLayer : CCLayer {
    b2World *world;
}
@property (nonatomic, readwrite) b2World *world;

-(void) createSwingChain:(float)yPos;
-(void)DetectStopped:(float)dt;
-(void)CreateRandomObjects;
-(void)RemovePastObjects;

-(void)CollisionHandler;

@end

extern b2Body* links[numLinks];
extern float camX;
extern float camY;
extern Biped* ragdoll;
extern b2Body *chainBody;
extern b2Body* groundBody;
extern b2DistanceJointDef jointDef;
extern b2Joint *assJoint1;
extern b2Joint *assJoint2;
extern b2Joint *assJoint3;
extern b2Joint *handJoint1;
extern b2Joint *handJoint2;
extern b2Joint *headJoint;
extern b2Vec2 lastCamPos;
extern b2Vec2 camPos;
extern float timeStationary;
extern ContactListener *contactListener;


