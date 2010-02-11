//
//  HighScoreScene.hh
//  SwingJump
//
//  Created by Patrick Smith on 1/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface HighScoreScene  : CCScene {}
-(void)mainMenuBtn: (id)sender; 
-(void)switchLayerBtn: (id)sender; 

@end

@interface ScoreboardLayer : CCLayer {}
@end

@interface StatisticsLayer : CCLayer {}
@end