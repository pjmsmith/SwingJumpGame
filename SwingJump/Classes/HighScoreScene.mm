//
//  HighScoreScene.m
//  SwingJump
//
//  Created by Patrick Smith on 1/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HighScoreScene.hh"
#import "MainMenuScene.hh"
#import "SimpleAudioEngine.h"
#import "Box2D.h"
#import "GLES-Render.h"

#define PTM_RATIO 32

@implementation HighScoreScene
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
        CCMenuItem *clearScores = [CCMenuItemFont itemFromString:@"Clear Scores"
                                                       target:self
                                                     selector:@selector(clearScoresBtn:)];
        
        CCMenu *menu = [CCMenu menuWithItems:mainmenu, clearScores, nil];
        [menu setPosition:ccp(440, 20)];
        [menu alignItemsVerticallyWithPadding:10];
        [self addChild:menu z:6];
        
		[self addChild:[ScoreboardLayer node] z:4 tag:123];
		
    }
    return self;
}

-(void)mainMenuBtn: (id)sender 
{
    MainMenuScene * ms = [MainMenuScene node];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.0 scene: ms]];
}

-(void)clearScoresBtn: (id)sender 
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"score"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeChildByTag:123 cleanup:YES];
    [self addChild:[ScoreboardLayer node] z:4 tag:123];
    NSLog(@"Cleared high scores");
}
@end

@implementation ScoreboardLayer

- (id) init {
    self = [super init];
    if (self != nil) {
        CCLabel* label;
        NSString* scoreboard = [[NSString alloc] initWithString:@"High Scores\n"];
        
        label = [CCLabel labelWithString:scoreboard fontName:@"Marker Felt" fontSize:32];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height-25);
		[self addChild:label z:0];
        
        id scoreObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"score"];
        if (scoreObject == nil) {
            //populate with default scores
            int i = 1;
            for(; i < 11; i++)
            {
                NSString* scoreString = [[NSString alloc] initWithFormat:@"%d.", i];
                label = [CCLabel labelWithString:scoreString fontName:@"Marker Felt" fontSize:28];
                CGSize size = [[CCDirector sharedDirector] winSize];
                [label setAnchorPoint:ccp(0,0.5)];
                label.position =  ccp( size.width /2 - 125,size.height-50-(25*(i-1)));
                [self addChild:label z:0]; 
                
                scoreString = [[NSString alloc] initWithFormat:@"%0.1f", 0.0];
                label = [CCLabel labelWithString:scoreString fontName:@"Marker Felt" fontSize:28];
                size = [[CCDirector sharedDirector] winSize];
                [label setAnchorPoint:ccp(1,0.5)];
                label.position =  ccp( size.width /2 + 125,size.height-50-(25*(i-1)));
                [self addChild:label z:0];               
            }
        }
        else {
            //add scores to string
            int numScores = [(NSMutableArray*)scoreObject count];
            int i = 0;
            for(; i < numScores; i++)
            {
                NSString* scoreString = [[NSString alloc] initWithFormat:@"%d.", i+1];
                label = [CCLabel labelWithString:scoreString fontName:@"Marker Felt" fontSize:28];
                CGSize size = [[CCDirector sharedDirector] winSize];
                [label setAnchorPoint:ccp(0,0.5)];
                label.position =  ccp( size.width /2 - 125,size.height-50-(25*i));
                [self addChild:label z:0]; 
                
                scoreString = [[NSString alloc] initWithFormat:@"%0.1f", [[(NSMutableArray*)scoreObject objectAtIndex:i] floatValue]];
                label = [CCLabel labelWithString:scoreString fontName:@"Marker Felt" fontSize:28];
                size = [[CCDirector sharedDirector] winSize];
                [label setAnchorPoint:ccp(1,0.5)];
                label.position =  ccp( size.width /2 + 125,size.height-50-(25*i));
                [self addChild:label z:0];                
            }
            //pad with 0's
            for(;i <10;i++)
            {
                NSString* scoreString = [[NSString alloc] initWithFormat:@"%d.", i+1];
                label = [CCLabel labelWithString:scoreString fontName:@"Marker Felt" fontSize:28];
                CGSize size = [[CCDirector sharedDirector] winSize];
                [label setAnchorPoint:ccp(0,0.5)];
                label.position =  ccp( size.width /2 - 125,size.height-50-(25*i));
                [self addChild:label z:0]; 
                
                scoreString = [[NSString alloc] initWithFormat:@"%0.1f", 0.0];
                label = [CCLabel labelWithString:scoreString fontName:@"Marker Felt" fontSize:28];
                size = [[CCDirector sharedDirector] winSize];
                [label setAnchorPoint:ccp(1,0.5)];
                label.position =  ccp( size.width /2 + 125,size.height-50-(25*i));
                [self addChild:label z:0]; 
            }
        }

                

    }
    return self;
}

@end