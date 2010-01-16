//
// RepeatableLayer.h
//
// Created by Rolando Abarca on 12/13/09.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RepeatableLayer : CCSprite {
	CGPoint texOffset;
	CGPoint firstOffset;
}
+ (id)layerWithFile:(NSString *)file;
- (void)scrollX:(float)offsetX scrollY:(float)offsetY;
//- (void)scrollY:(float)offset;
@end