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
#import "ControlLayer.hh"

#define PTM_RATIO 32


GFFParallaxNode *parallaxNode;


@implementation GameScene
- (id) init {
    self = [super init];
    if (self != nil) {
		parallaxNode = [GFFParallaxNode node];
        //CCSprite * bg = [CCSprite spriteWithFile:@"mainmenu_bg.png"]; //change this to be the level background
        //[bg setPosition:ccp(240, 165)];
		
        //[self addChild:bg z:0];
        //[self addChild:[GameLayer node] z:1];
		RepeatableLayer *bg01 = [RepeatableLayer layerWithFile:@"bg01.png"];
		[bg01 setScale:2.3f];
		[bg01 setPosition:ccp(0,-50)];
		[parallaxNode addChild:bg01 z:0 parallaxRatio:0.15f];
		
		RepeatableLayer *bg02 = [RepeatableLayer layerWithFile:@"bg02.png"];
		[bg02 setScale:1.5f];
		[parallaxNode addChild:bg02 z:1 parallaxRatio:0.6f];
		
		RepeatableLayer *fg = [RepeatableLayer layerWithFile:@"fg.png"];
		[fg setPosition:ccp(0,-100)];
		[parallaxNode addChild:fg z:2 parallaxRatio:1.0f];
		
		RepeatableLayer *clouds = [RepeatableLayer layerWithFile:@"cloud.png"];
		[clouds setPosition:ccp(0,0)];
		[clouds setScale:2.0f];
		[parallaxNode addChild:clouds z:3 parallaxRatio:0.5f];
		
		
		[self addChild:parallaxNode z:0];
		
        [self addChild:[ControlLayer node] z:1];
    }
    return self;
}
@end