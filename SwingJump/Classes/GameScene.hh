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

#define numLinks 20
#define handLink numLinks-3
#define headLinkLength 4.6f

@interface GameScene  : CCScene {}
@end
@interface GameLayer : CCLayer {

}
-(void) createSwingChain:(float)yPos;

@end

@interface ControlLayer : CCLayer {
    CCSprite *leftArrow;
    CCSprite *rightArrow;
	CCSprite *jumpButton;
    GameLayer *gl;
    BOOL isRightBeingTouched;
    BOOL isLeftBeingTouched;
	BOOL hasJumped;
}
@property (nonatomic, retain) CCSprite *leftArrow;
@property (nonatomic, retain) CCSprite *rightArrow;
@property (nonatomic, retain) CCSprite *jumpButton;
@property (nonatomic, retain) GameLayer *gl;
@property (nonatomic) BOOL isRightBeingTouched;
@property (nonatomic) BOOL isLeftBeingTouched;
@property (nonatomic) BOOL hasJumped;

@end

@interface HUDLayer : CCLayer {
    CCLabelAtlas *scoreDisplay;
}
@property (nonatomic, retain) CCLabelAtlas *scoreDisplay;

-(void)gameSceneBtn: (id)sender;
@end