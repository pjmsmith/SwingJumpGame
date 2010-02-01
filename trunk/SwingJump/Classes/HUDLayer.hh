//
//  HUDLayer.h
//  SwingJump
//
//  Created by Patrick Smith on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import "Box2D.h"
#import "GameLayer.hh"

@interface HUDLayer : CCLayer {
    CCLabelAtlas *scoreDisplay;
	float launchX;
}

@property (nonatomic, retain) CCLabelAtlas *scoreDisplay;
@property (nonatomic) float launchX;

-(void)gameSceneBtn: (id)sender;
-(void)enableScore;
-(void)disableScore;
-(float)getScore;
-(void)setLaunchX:(float)xpos;

@end
