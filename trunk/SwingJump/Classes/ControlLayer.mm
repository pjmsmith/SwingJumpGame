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
@synthesize jumpRect;
@synthesize gl;
@synthesize hl;
@synthesize isRightBeingTouched;
@synthesize isLeftBeingTouched;
@synthesize hasJumped;
@synthesize type2Enabled;
@synthesize type3Enabled;
@synthesize type4Enabled;
@synthesize arrowVisible;
@synthesize hitCounter;
@synthesize timeCounter;
@synthesize merryGoRound;
@synthesize locPrev;
@synthesize customSlider;
@synthesize uiView;
@synthesize sliderBackground;
@synthesize maxMonkeyBars;
@synthesize displayTime;
@synthesize monkeyBarCounter;
@synthesize lblDisplayStat;
@synthesize fastestSwipe;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.isTouchEnabled = YES;
        isRightBeingTouched = NO;
        isLeftBeingTouched = NO;
		hasJumped = NO;
		type2Enabled = NO;
		type3Enabled = NO;
		arrowVisible = NO;
		displayTime = 0.0f;
		fastestSwipe = 1000.0f;
		monkeyBarCounter = NO;
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		lblDisplayStat = [CCLabel labelWithString:@"" fontName:@"Marker Felt" fontSize:45];
		lblDisplayStat.position =  ccp( size.width /2 , size.height/2 + 60);
		[lblDisplayStat setOpacity:0.0];
		[self addChild:lblDisplayStat z:0];
		
		
		
		hitCounter = 0;
		timeCounter = 0.0f;
		locPrev = b2Vec2(0.0f,1.0f);
		
        leftArrow = [CCSprite spriteWithFile:@"circlearrow.png"];
        [leftArrow setPosition:ccp(50,160)];
        [leftArrow setOpacity:128];
        leftArrow.rotation = 180;
        [self addChild:leftArrow z:1];
        rightArrow = [CCSprite spriteWithFile:@"circlearrow.png"];
        [rightArrow setPosition:ccp(430,160)];
        [rightArrow setOpacity:128];
        [self addChild:rightArrow z:1];
        
		/*jumpButton = [CCSprite spriteWithFile:@"jumpBtn.png"];
		[jumpButton setPosition:ccp(240,270)];
        [jumpButton setOpacity:128];
        [self addChild:jumpButton z:1];*/
		
		jumpRect = CGRectMake(160.0f, 0.0f, 160.0f, 320.0f);
        
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
            
			if (CGRectContainsPoint(jumpRect, location)) {
				//NSLog(@"Left touched");
					hasJumped = YES;
					//[jumpButton runAction:[CCFadeTo actionWithDuration:0.2 opacity:0]];
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
		
		if (type3Enabled) {
		//start position
		}
	}

	return kEventHandled;
}
-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	if (type3Enabled) {
		//nothing to do
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

- (void) handleType3 {
	[self create_Custom_UISlider];
	uiView = [[CCDirector sharedDirector] openGLView];
	//CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(3.14159267f/2.0f);
	UIImage *track = [UIImage imageNamed:@"sliderTrack.png"];
	sliderBackground = [[UIImageView alloc] initWithImage:track];
	[sliderBackground setFrame:CGRectMake(0.0, 170.0, 320.0, 105.0)];
	[sliderBackground setAlpha:0.7f];
	//[sliderBackground setTransform:landscapeTransform];
	[uiView addSubview:sliderBackground];
	//[customSlider setTransform:landscapeTransform];
	[customSlider setAlpha:0.7f];
	[uiView addSubview:customSlider];
	timeCounter = 0.0f;
	hitCounter = 0;
	type3Enabled = YES;

	[self schedule:@selector(tictoc:)];
}

- (void) handleType4 {
	[self create_Custom_UISlider];
	uiView = [[CCDirector sharedDirector] openGLView];
	CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(3.14159267f/2.0f);
	UIImage *track = [UIImage imageNamed:@"sliderTrack.png"];
	sliderBackground = [[UIImageView alloc] initWithImage:track];
	[sliderBackground setFrame:CGRectMake(0.0, 170.0, 320.0, 105.0)];
	[sliderBackground setAlpha:0.7f];
	[sliderBackground setTransform:landscapeTransform];
	[uiView addSubview:sliderBackground];
	[customSlider setTransform:landscapeTransform];
	[customSlider setAlpha:0.7f];
	[uiView addSubview:customSlider];
	timeCounter = 0.0f;
	hitCounter = 0;
	type4Enabled = YES;
	[self schedule:@selector(tictoc:)];
}



-(void)tictoc:(ccTime) dt{
	if (type2Enabled) {
		timeCounter = timeCounter+dt;
		[[self getChildByTag:100] setVisible:(bool)floor((int)(timeCounter*3)%2)];
		
		if (timeCounter > 3.0f) {
			type2Enabled = NO;
			monkeyBarCounter = YES;
			[lblDisplayStat setString:[NSString stringWithFormat:@"%i", hitCounter]];
			displayTime = 0.0f;
			[self unschedule:@selector(tictoc:)];
			[self schedule:@selector(tickDisplay:)];
			[rightArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
			[leftArrow runAction:[CCFadeTo actionWithDuration:0.05 opacity:0]];
			[gl ResumeWithImpulse:b2Vec2((float)hitCounter/12.0f,(float)hitCounter/12.0f)];
			[self removeChildByTag:100 cleanup:YES];
			if (hitCounter > maxMonkeyBars) {
				maxMonkeyBars = hitCounter;
			}
		}
	}
	else if (type3Enabled) {
		timeCounter = timeCounter+dt;
		if (timeCounter> 3.0f) {
			type3Enabled = NO;
			[self unschedule:@selector(tictoc:)];
			[gl ResumeWithImpulse:b2Vec2(0.0f,0.0f)];
			[customSlider removeFromSuperview];
			[sliderBackground removeFromSuperview];
		}
	}
	else if (type4Enabled) {
		timeCounter = timeCounter+dt;
		if (timeCounter> 3.0f) {
			type4Enabled = NO;
			[self unschedule:@selector(tictoc:)];
			[gl ResumeWithImpulse:b2Vec2(hitCounter/2,hitCounter/2)];
			[customSlider removeFromSuperview];
			[sliderBackground removeFromSuperview];
		}
	}
}

-(void)tickDisplay:(ccTime) dt{
	displayTime = displayTime+dt;
	float opacity = 255.0*(1 - displayTime/3.0);
	if (opacity < 0.0f) {
		opacity = 0.0f;
	}
	[lblDisplayStat setOpacity:opacity];
	if (displayTime > 3.0f) {
		monkeyBarCounter = NO;
		[self unschedule:@selector(tickDisplay:)];
	}
}
	
	
- (void)create_Custom_UISlider
{
	CGRect frame = CGRectMake(10.0, 200.0, 300.0, 44.0);
	CGRect thumb = CGRectMake(10.0, 200.0, 44.0, 90.0);
	customSlider = [[UISlider alloc] initWithFrame:frame];
	[customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
	// in case the parent view draws with a custom color or gradient, use a transparent color
	customSlider.backgroundColor = [UIColor clearColor];	
	[customSlider setThumbImage: [UIImage imageNamed:@"customThumb.png"] forState:UIControlStateNormal];
	[customSlider thumbRectForBounds: thumb trackRect: frame value: customSlider.value];
	customSlider.minimumValue = 0.0;
	customSlider.maximumValue = 1.0;
	customSlider.continuous = YES;
	customSlider.value = 0.0;
}

- (void) sliderAction: (id)sender
{
	if (customSlider.value != 1.0)  //if the value is not the max, slide this bad boy back to zero
	{
		[sender setValue: 0 animated: YES];
	}
	else if (type3Enabled) {	
		if (fastestSwipe > timeCounter) {
			fastestSwipe = timeCounter;
		}
		[lblDisplayStat setString:[NSString stringWithFormat:@"%4.2fs", timeCounter]];
		displayTime = 0.0f;
		[self schedule:@selector(tickDisplay:)];
		type3Enabled = NO;
		[self unschedule:@selector(tictoc:)];
		float bonus = (2.5f-timeCounter);
		if (bonus < 0.0f) {
			bonus = 0.0f;
		}
		[gl ResumeWithImpulse:b2Vec2(bonus,bonus)];
		[customSlider removeFromSuperview];
		[sliderBackground removeFromSuperview];
	}
	else if (type4Enabled) {
		[sender setValue: 0 animated: YES];
		hitCounter++;
		[lblDisplayStat setString:[NSString stringWithFormat:@"%i", hitCounter]];
		displayTime = 0.0f;
		[self schedule:@selector(tickDisplay:)];
	}
	
}

- (int)getMaxMonkeyBars {
	return maxMonkeyBars;
}

- (float)getFastestSwipe {
	return fastestSwipe;
}

@end
