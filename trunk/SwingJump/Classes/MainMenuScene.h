//
//  MainMenuScene.h
//  SwingJump
//
//  Created by Patrick Smith on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface MainMenuScene  : CCScene {}
@end

@interface MenuLayer : CCLayer {}
-(void)startGame: (id)sender;
-(void)help: (id)sender;
@end