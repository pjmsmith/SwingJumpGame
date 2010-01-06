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
        CCSprite * bg = [CCSprite spriteWithFile:@"mainmenu_bg.png"];
        [bg setPosition:ccp(240, 165)]; //the positioning is weird...I made it so it matches with the Default.png's positioning (less noticeable on load)
        [self addChild:bg z:0];
        [self addChild:[GameLayer node] z:1];
    }
    return self;
}
@end

@implementation GameLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [CCMenuItemFont setFontSize:30];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        CCMenuItem *start = [CCMenuItemFont itemFromString:@"This is the Game Scene!"
													target:self
												  selector:@selector(gameSceneBtn:)];
        CCMenu *menu = [CCMenu menuWithItems:start, nil];
        [menu alignItemsVerticallyWithPadding:100];
        [self addChild:menu];
    }
    return self;
}
-(void)gameSceneBtn: (id)sender {
}

@end