//
//  MainMenuScene.m
//  SwingJump
//
//  Created by Patrick Smith on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"
#import "GameScene.h"

@implementation MainMenuScene
- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite * bg = [CCSprite spriteWithFile:@"mainmenu_bg.png"];
        [bg setPosition:ccp(240, 165)]; //the positioning is weird...I made it so it matches with the Default.png's positioning (less noticeable on load)
        [self addChild:bg z:0];
        [self addChild:[MenuLayer node] z:1];
    }
    return self;
}
@end

@implementation MenuLayer
- (id) init {
    self = [super init];
    if (self != nil) {
        [CCMenuItemFont setFontSize:25];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        CCMenuItem *start = [CCMenuItemFont itemFromString:@"Start Game"
                                                target:self
                                              selector:@selector(startGame:)];
        CCMenuItem *help = [CCMenuItemFont itemFromString:@"Help"
                                               target:self
                                             selector:@selector(help:)];
        CCMenu *menu = [CCMenu menuWithItems:start, help, nil];
        [menu alignItemsVerticallyWithPadding:100];
        [self addChild:menu];
    }
    return self;
}
-(void)startGame: (id)sender {
	GameScene * gs = [GameScene node];
	//[[CCDirector sharedDirector] runWithScene: gs];
	[[CCDirector sharedDirector] replaceScene: [CCFlipXTransition transitionWithDuration:1.0 scene: gs]];
    NSLog(@"start game");
}
-(void)help: (id)sender {
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hz_t_menumusic.mp3"];
    }
    else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }

    NSLog(@"help");
}
@end