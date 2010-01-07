//
//  GameScene.mm
//  SwingJump
//
//  Created by Sean Stavropoulos on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "GameScene.h"
#import "Box2D.h"

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
@synthesize swingChain;

- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite *swingSet = [CCSprite spriteWithFile:@"swingset_supports.png"];
        [swingSet setPosition:ccp(240,160)];
        [self addChild:swingSet];
        swingChain = [CCSprite spriteWithFile:@"swingchain.png"];
        [swingChain setAnchorPoint:ccp(0.5,1)];
        [swingChain setPosition:ccp((swingSet.contentSize.width/2), (swingSet.contentSize.height)-2)];
        [swingSet addChild:swingChain z:-1];
        
    }
    return self;
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
        [self.gl.swingChain runAction:[CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:5],
                                       [CCCallFunc actionWithTarget:self selector:@selector(rotateChainLeft)],nil]];
    }    
}

- (void)rotateChainRight
{
    if(isRightBeingTouched) 
    {
        [self.gl.swingChain runAction:[CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:-5],
                                       [CCCallFunc actionWithTarget:self selector:@selector(rotateChainRight)],nil]];
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