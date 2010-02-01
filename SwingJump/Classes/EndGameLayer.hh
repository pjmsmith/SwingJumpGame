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
}

@property (nonatomic, retain) CCLabel *label;
-(void) setDistance:(float)distance;
@end

