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
#define numLinks 25

@interface GameScene  : CCScene {}
@end
@interface GameLayer : CCLayer {

}
-(void) createSwingChain:(float)yPos;

@end

@interface ControlLayer : CCLayer {
    CCSprite *leftArrow;
    CCSprite *rightArrow;
    GameLayer *gl;
    BOOL isRightBeingTouched;
    BOOL isLeftBeingTouched;
}
@property (nonatomic, retain) CCSprite *leftArrow;
@property (nonatomic, retain) CCSprite *rightArrow;
@property (nonatomic, retain) GameLayer *gl;
@property (nonatomic) BOOL isRightBeingTouched;
@property (nonatomic) BOOL isLeftBeingTouched;

@end

@interface HUDLayer : CCLayer {}
-(void)gameSceneBtn: (id)sender;
@end