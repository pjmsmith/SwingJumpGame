//
//  EndGameLayer.mm
//  SwingJump
//
//  Created by Sean Stavropoulos on 2/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EndGameLayer.hh"


@implementation EndGameLayer
@synthesize label;
- (id) init {
    self = [super init];
    if (self != nil) {
		label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:50];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/2 );
		[self addChild:label z:0];
		
    }
    
    return self;
}

-(void)setDistance:(float)distance {
	[label setString:[NSString stringWithFormat:@"Distance: %4.0fm", distance]];
}

@end
