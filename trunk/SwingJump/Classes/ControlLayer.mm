//
//  ControlLayer.mm
//  SwingJump
//
//  Created by Patrick Smith on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlLayer.hh"

#define PTM_RATIO 32


@implementation ControlLayer
@synthesize leftArrow;
@synthesize rightArrow;
@synthesize jumpButton;
@synthesize gl;
@synthesize hl;
@synthesize isRightBeingTouched;
@synthesize isLeftBeingTouched;
@synthesize hasJumped;
@synthesize type2Enabled;
@synthesize arrowVisible;
@synthesize hitCounter;
@synthesize timeCounter;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.isTouchEnabled = YES;
        isRightBeingTouched = NO;
        isLeftBeingTouched = NO;
		hasJumped = NO;
		type2Enabled = NO;
		arrowVisible = NO;
		hitCounter = 0;
		timeCounter = 0.0f;
		
        leftArrow = [CCSprite spriteWithFile:@"circlearrow.png"];
        [leftArrow setPosition:ccp(50,160)];
        [leftArrow setOpacity:128];
        leftArrow.rotation = 180;
        [self addChild:leftArrow z:1];
        rightArrow = [CCSprite spriteWithFile:@"circlearrow.png"];
        [rightArrow setPosition:ccp(430,160)];
        [rightArrow setOpacity:128];
        [self addChild:rightArrow z:1];
        
		jumpButton = [CCSprite spriteWithFile:@"jumpBtn.png"];
		[jumpButton setPosition:ccp(240,270)];
        [jumpButton setOpacity:128];
        [self addChild:jumpButton z:1];
		
		
        
        gl = [GameLayer node];
        [self addChild:gl z:0]; //added as a child so touchesEnded can call a function contained in GameLayer
		hl = [HUDLayer node];
		[self addChild:hl z:2];
        //gl = [GameLayer node];
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
        if (!hasJumped) {
			if (CGRectContainsPoint([leftArrow boundingBox], location)) {
				//NSLog(@"Left touched");
				if(!isRightBeingTouched)
				{
					isLeftBeingTouched = YES;
					[leftArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:255]];
					[self rotateChainLeft];
					ragdoll->PumpBckwdLimits();
					
				}
			}
			if (CGRectContainsPoint([jumpButton boundingBox], location)) {
				//NSLog(@"Left touched");
					hasJumped = YES;
					[jumpButton runAction:[CCFadeTo actionWithDuration:0.2 opacity:0]];
					[leftArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:0]];
					[rightArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:0]];
					[self launch];
			}
			if (CGRectContainsPoint([rightArrow boundingBox], location)) {
				//NSLog(@"Right touched");
				if(!isLeftBeingTouched)
				{
					isRightBeingTouched = YES;
					[rightArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:255]];
					[self rotateChainRight];
					
					ragdoll->PumpFwdLimits();
				} 
			}
			
			for(int i = 0; i < numLinks; i++)
			{
				links[i]->m_linearDamping=0.0f;
				links[i]->m_angularDamping=0.0f;
			}
			ragdoll->SetLinearDamping(0.0f);
			ragdoll->SetAngularDamping(0.0f);
        }
		
		if (type2Enabled) {
			if (CGRectContainsPoint([leftArrow boundingBox], location) && !arrowVisible) {
				//NSLog(@"Left touched");
				hitCounter++;
				[leftArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
				[rightArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:255]];
				arrowVisible = YES;
			}
			if (CGRectContainsPoint([rightArrow boundingBox], location) && arrowVisible) {
				//NSLog(@"Left touched");
				hitCounter++;
				[leftArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:255]];
				[rightArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
				arrowVisible = NO;
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
		ragdoll->SetSittingLimits();
    }
    if(isRightBeingTouched)
    {
        [rightArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:128]];
        isRightBeingTouched = NO;
		ragdoll->SetSittingLimits();
    }
    
	return kEventHandled;
}

- (void)rotateChainLeft
{
	 [rightArrow runAction:[CCFadeTo actionWithDuration:0.2 opacity:128]];
    if(isLeftBeingTouched) 
    {
		//for(int i = 0; i < numLinks; i++)
		//{
		links[numLinks-1]->ApplyForce(b2Vec2(-20.0f, 5.0f),links[numLinks-1]->GetPosition());
		//}
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[self runAction:[CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:0],[CCCallFunc actionWithTarget:self selector:@selector(rotateChainLeft)], nil]];
        [pool release];
	}    
}

- (void)rotateChainRight
{
    if(isRightBeingTouched) 
    {
		//for(int i = 0; i < numLinks; i++)
		//{
		links[numLinks-1]->ApplyForce(b2Vec2(20.0f, 5.0f),links[numLinks-1]->GetPosition());
		//}
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[self runAction:[CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:0],[CCCallFunc actionWithTarget:self selector:@selector(rotateChainRight)], nil]];
        [pool release];
    }
}
-(void)launch{
	ragdoll->SetDefaultLimits();
	gl.world->DestroyJoint(headJoint);
	gl.world->DestroyJoint(handJoint1);
	gl.world->DestroyJoint(handJoint2);
	gl.world->DestroyJoint(assJoint1);
	gl.world->DestroyJoint(assJoint2);
	gl.world->DestroyJoint(assJoint3);
	b2Vec2 vel;
	vel = links[numLinks-1]->GetLinearVelocity();
	vel.x = 1.7*vel.x;
	vel.y = 1.7*vel.y;
	if (vel.x<0) {
		vel = b2Vec2(0.0f,0.0f);
	}
	ragdoll->SetLinearVelocity(vel);
	ragdoll->setLaunched(TRUE);
	ragdoll->SetBullet();
	[hl setLaunchX:ragdoll->Head->GetPosition().x];
	[hl enableScore];
}

- (void) handleType2 {
	CCSprite * monkeyBars = [CCSprite spriteWithFile:@"monkeybars.png"];
	[monkeyBars setPosition:ccp(240, 250)];
	[self addChild:monkeyBars z:3 tag:100];

	timeCounter = 0.0f;
	hitCounter = 0;
	type2Enabled = YES;
	arrowVisible = NO; // NO = left, YES = right
	[leftArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:255]];
	[self schedule:@selector(tictoc:)];
	
	
}
-(void)tictoc:(ccTime) dt{
	if (type2Enabled) {
		
		timeCounter = timeCounter+dt;
		[[self getChildByTag:100] setVisible:(bool)floor((int)(timeCounter*3)%2)];
		
		if (timeCounter > 5.0f) {
			type2Enabled = NO;
			[self unschedule:@selector(tictoc:)];
			[rightArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
			[leftArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
			[gl ResumeWithImpulse:b2Vec2((float)hitCounter/2.0f,(float)hitCounter/2.0f)];
			[self removeChildByTag:100 cleanup:YES];
		}
	}
}
@end
