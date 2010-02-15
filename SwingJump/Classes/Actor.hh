//
//  Actor.h
//  SwingJump
//
//  Created by Sean Stavropoulos on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Actor : CCSprite {
    NSInteger type;
}
@property (nonatomic, readwrite) NSInteger type;

@end
