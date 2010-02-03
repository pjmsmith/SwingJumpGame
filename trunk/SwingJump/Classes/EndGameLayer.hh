//
//  EndGameLayer.h
//  SwingJump
//
//  Created by Sean Stavropoulos on 2/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface EndGameLayer : CCLayer {
	CCLabel* label;
	CCLabel* lblMaxSpeed;
	CCLabel* lblMaxHeight;
	CCLabel* lblMaxMonkeyBars;
}

@property (nonatomic, retain) CCLabel *label;
@property (nonatomic, retain) CCLabel *lblMaxSpeed;
@property (nonatomic, retain) CCLabel *lblMaxHeight;
@property (nonatomic, retain) CCLabel *lblMaxMonkeyBars;

-(void) setDistance:(float)distance maxSpeed:(float)maxSpeed maxHeight:(float)maxHeight maxMonkeyBars:(int)maxMonkeyBars;
@end

