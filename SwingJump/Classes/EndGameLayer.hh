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
	CCLabel* lblnoType;
	CCLabel* lblfastestSwipe;
}

@property (nonatomic, retain) CCLabel *label;
@property (nonatomic, retain) CCLabel *lblMaxSpeed;
@property (nonatomic, retain) CCLabel *lblMaxHeight;
@property (nonatomic, retain) CCLabel *lblMaxMonkeyBars;
@property (nonatomic, retain) CCLabel *lblnoType;
@property (nonatomic, retain) CCLabel *lblfastestSwipe;

-(void) setDistance:(float)distance maxSpeed:(float)maxSpeed maxHeight:(float)maxHeight maxMonkeyBars:(int)maxMonkeyBars fastestSwipe:(float)fastestSwipe noType1:(int)t1 noType2:(int)t2 noType3:(int)t3;
@end

