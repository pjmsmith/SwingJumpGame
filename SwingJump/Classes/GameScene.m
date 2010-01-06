//
//  GameScene.m
//  SwingJump
//
//  Created by Sean Stavropoulos on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "GameScene.h"


@implementation GameScene
- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite * bg = [CCSprite spriteWithFile:@"mainmenu_bg.png"]; //change this to be the level background
        [bg setPosition:ccp(240, 165)];
        [self addChild:bg z:0];
        [self addChild:[GameLayer node] z:1];
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
        [self addChild:swingSet];
    }
    return self;
}

@end

@implementation HUDLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [CCMenuItemFont setFontSize:12];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        CCMenuItem *start = [CCMenuItemFont itemFromString:@"Main Menu"
													target:self
												  selector:@selector(gameSceneBtn:)];
		
        CCMenu *menu = [CCMenu menuWithItems:start, nil];
        [menu setPosition:ccp(450, 10)];
        [self addChild:menu];
    }

    return self;
}

-(void)gameSceneBtn: (id)sender {
    MainMenuScene * ms = [MainMenuScene node];
	[[CCDirector sharedDirector] replaceScene: [CCCrossFadeTransition transitionWithDuration:1.0 scene: ms]];
}

@end