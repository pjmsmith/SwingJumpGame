//
//  ControlLayer.h
//  SwingJump
//
//  Created by Patrick Smith on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import "Box2D.h"
#import "HUDLayer.hh"

@interface ControlLayer : CCLayer {
    CCSprite *leftArrow;
    CCSprite *rightArrow;
	CCSprite *jumpButton;
	CCSprite * merryGoRound;
    GameLayer *gl;
	HUDLayer *hl;
    BOOL isRightBeingTouched;
    BOOL isLeftBeingTouched;
	BOOL hasJumped;
	BOOL type2Enabled;
	BOOL type3Enabled;
	BOOL arrowVisible; //left = 0, right = 1
	int hitCounter;
	float timeCounter;
	b2Vec2 locPrev;
}

@property (nonatomic, retain) CCSprite *leftArrow;
@property (nonatomic, retain) CCSprite *rightArrow;
@property (nonatomic, retain) CCSprite *jumpButton;
@property (nonatomic, retain) CCSprite * merryGoRound;
@property (nonatomic, retain) GameLayer *gl;
@property (nonatomic, retain) HUDLayer *hl;
@property (nonatomic) BOOL isRightBeingTouched;
@property (nonatomic) BOOL isLeftBeingTouched;
@property (nonatomic) BOOL hasJumped;
@property (nonatomic) BOOL type2Enabled;
@property (nonatomic) BOOL type3Enabled;
@property (nonatomic) BOOL arrowVisible;
@property (nonatomic) int hitCounter;
@property (nonatomic) float timeCounter;
@property (nonatomic) b2Vec2 locPrev;

- (void)rotateChainLeft;
- (void)rotateChainRight;
- (void)handleType2;
- (void)handleType3;
- (void)launch;

@end