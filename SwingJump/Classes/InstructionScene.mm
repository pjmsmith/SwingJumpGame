//
//  InstructionScene.mm
//  SwingJump
//
//  Created by Patrick Smith on 1/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InstructionScene.hh"
#import "MainMenuScene.hh"
#import "SimpleAudioEngine.h"
#import "Box2D.h"
#import "GLES-Render.h"

#define PTM_RATIO 32

@implementation InstructionScene
- (id) init {
    self = [super init];
    if (self != nil) {
        CCSprite * bg01 = [CCSprite spriteWithFile:@"bg01.png"];
		[bg01 setScale:2.3f];
		//[bg01 setPosition:ccp(0,-50)];
        [bg01 setPosition:ccp(440, 240)]; //the positioning is weird...I made it so it matches with the Default.png's positioning (less noticeable on load)
        [self addChild:bg01 z:0];
		
		CCSprite * bg02 = [CCSprite spriteWithFile:@"bg02.png"];
        [bg02 setPosition:ccp(240, 240)];
		[bg02 setScale:1.5f];
		[self addChild:bg02 z:1];
		
		CCSprite * fg = [CCSprite spriteWithFile:@"fg.png"];
		//[fg setPosition:ccp(0,-50)];
		[fg setPosition:ccp(240, 240)];
		[self addChild:fg z:2];
        [CCMenuItemFont setFontSize:14];
        [CCMenuItemFont setFontName:@"Marker Felt"];
		CCMenuItem *mainmenu = [CCMenuItemFont itemFromString:@"Main Menu"
                                                       target:self
                                                     selector:@selector(mainMenuBtn:)];
        
        CCMenu *menu = [CCMenu menuWithItems:mainmenu, nil];
        [menu setPosition:ccp(440, 20)];
        [menu alignItemsVerticallyWithPadding:10];
        [self addChild:menu z:6];
        
		[self addChild:[InstructionLayer node] z:4];

    }
    return self;
}

-(void)mainMenuBtn: (id)sender 
{
    MainMenuScene * ms = [MainMenuScene node];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.0 scene: ms]];
}
@end

@implementation InstructionLayer

- (id) init {
    self = [super init];
    if (self != nil) {
        CCLabel* label = [CCLabel labelWithString:@"1. Swing." fontName:@"Marker Felt" fontSize:30];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/2 + 75);
		[self addChild:label z:1];
		
		CCLabel* label2 = [CCLabel labelWithString:@"2. Jump." fontName:@"Marker Felt" fontSize:30];
		label2.position =  ccp( size.width /2 , size.height/2 + 25);
		[self addChild:label2 z:1];
		
		CCLabel* label3 = [CCLabel labelWithString:@"3. Do the thing." fontName:@"Marker Felt" fontSize:30];
		label3.position =  ccp( size.width /2  , size.height/2 - 25);
		[self addChild:label3 z:1];
		
		CCLabel* label4 = [CCLabel labelWithString:@"...and thats the way you do it!" fontName:@"Marker Felt" fontSize:30];
		label4.position =  ccp( size.width /2  , size.height/2 - 75 );
		[self addChild:label4 z:1];
		
    }
    return self;
}

@end