//
//  HUDLayer.mm
//  SwingJump
//
//  Created by Patrick Smith on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.hh"
#import "MainMenuScene.hh"
#import "GameScene.hh"

#define PTM_RATIO 32


@implementation HUDLayer
@synthesize scoreDisplay;
@synthesize launchX;

- (id) init {
    self = [super init];
    if (self != nil) {
        [CCMenuItemFont setFontSize:14];
        [CCMenuItemFont setFontName:@"Marker Felt"];
        CCMenuItem *mainmenu = [CCMenuItemFont itemFromString:@"Main Menu"
                                                       target:self
                                                     selector:@selector(gameSceneBtn:)];
        CCMenuItem *reset = [CCMenuItemFont itemFromString:@"Reset"
                                                    target:self
                                                  selector:@selector(resetBtn:)];
		
        CCMenu *menu = [CCMenu menuWithItems:mainmenu, reset, nil];
        [menu setPosition:ccp(440, 20)];
        [menu alignItemsVerticallyWithPadding:10];
        [self addChild:menu];
		
		scoreDisplay = [[CCLabelAtlas labelAtlasWithString:@"0" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];
		[scoreDisplay setPosition:ccp(320, 290)];
		[scoreDisplay setVisible:false];
		[self addChild:scoreDisplay z:2 tag:100];
		[self schedule:@selector(tick:)];
        
		launchX = 0.0f;
    }
    
    return self;
}

-(void)gameSceneBtn: (id)sender {
    MainMenuScene * ms = [MainMenuScene node];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.0 scene: ms]];
}

-(void)resetBtn: (id)sender {
    GameScene *gs = [GameScene node];
	[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:0.0 scene: gs]];
}

-(void)enableScore {
	[[self getChildByTag:100] setVisible:true];
}

-(void)setLaunchX:(float)xpos {
	launchX = xpos;
}


-(void)tick:(ccTime) dt{
	b2Vec2 headPos = ragdoll->Head->GetPosition();
	NSString *strHeadPos = [NSString stringWithFormat:@"%8.0f",headPos.x-launchX];
	//scoreDisplay = [[CCLabelAtlas labelAtlasWithString:strHeadPos charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];
	[scoreDisplay setString:strHeadPos];
	//[scoreDisplay updateAtlasValues];
}
@end