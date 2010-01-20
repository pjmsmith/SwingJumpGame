//
//  GameScene.h
//  SwingJump
//
//  Created by Sean Stavropoulos on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Biped.h"
#import "BipedDef.h"

#define numLinks 40
#define handLink numLinks-6
#define headLinkLength 4.6f
#define randObjectPercentage 0.08f

@interface GameScene  : CCScene {}
@end
@interface GameLayer : CCLayer {

}
-(void) createSwingChain:(float)yPos;

@end

@interface HUDLayer : CCLayer {
    CCLabelAtlas *scoreDisplay;
	float launchX;
}
@property (nonatomic, retain) CCLabelAtlas *scoreDisplay;
@property (nonatomic) float launchX;
-(void)gameSceneBtn: (id)sender;
-(void)enableScore;
-(void)setLaunchX:(float)xpos;
@end

@interface ControlLayer : CCLayer {
    CCSprite *leftArrow;
    CCSprite *rightArrow;
	CCSprite *jumpButton;
    GameLayer *gl;
	HUDLayer *hl;
    BOOL isRightBeingTouched;
    BOOL isLeftBeingTouched;
	BOOL hasJumped;
}

@property (nonatomic, retain) CCSprite *leftArrow;
@property (nonatomic, retain) CCSprite *rightArrow;
@property (nonatomic, retain) CCSprite *jumpButton;
@property (nonatomic, retain) GameLayer *gl;
@property (nonatomic, retain) HUDLayer *hl;
@property (nonatomic) BOOL isRightBeingTouched;
@property (nonatomic) BOOL isLeftBeingTouched;
@property (nonatomic) BOOL hasJumped;

@end

