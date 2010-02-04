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
@synthesize lblMaxSpeed;
@synthesize lblMaxHeight;
@synthesize lblMaxMonkeyBars;
@synthesize lblnoType;

- (id) init {
    self = [super init];
    if (self != nil) {
		label = [CCLabel labelWithString:@"distance" fontName:@"Marker Felt" fontSize:50];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp( size.width /2 , size.height/2 );
		[self addChild:label z:0];
		
		lblMaxSpeed = [CCLabel labelWithString:@"maxSpeed" fontName:@"Marker Felt" fontSize:30];
		lblMaxSpeed.position =  ccp( size.width /2 , size.height/2 - 40.0f);
		[self addChild:lblMaxSpeed z:0];
		
		lblMaxHeight = [CCLabel labelWithString:@"maxHeight" fontName:@"Marker Felt" fontSize:30];
		lblMaxHeight.position =  ccp( size.width /2 , size.height/2 - 70.0f);
		[self addChild:lblMaxHeight z:0];
		
		lblMaxMonkeyBars = [CCLabel labelWithString:@"maxMonkeyBars" fontName:@"Marker Felt" fontSize:30];
		lblMaxMonkeyBars.position =  ccp( size.width /2 , size.height/2 - 100.0f);
		[self addChild:lblMaxMonkeyBars z:0];
		
		lblnoType = [CCLabel labelWithString:@"noType" fontName:@"Marker Felt" fontSize:20];
		lblnoType.position =  ccp( size.width /2 , size.height/2 + 50.0f);
		[self addChild:lblnoType z:0];
		
		
		
    }
    
    return self;
}

-(void) setDistance:(float)distance maxSpeed:(float)maxSpeed maxHeight:(float)maxHeight maxMonkeyBars:(int)maxMonkeyBars noType1:(int)t1 noType2:(int)t2 noType3:(int)t3{
	[label setString:[NSString stringWithFormat:@"Distance: %4.0fm", distance]];
	[lblMaxSpeed setString:[NSString stringWithFormat:@"Max Speed: %4.0fm/s", maxSpeed]];
	[lblMaxHeight setString:[NSString stringWithFormat:@"Max Height: %4.0fm", maxHeight]];
	[lblMaxMonkeyBars setString:[NSString stringWithFormat:@"Max Monkey Bars Hit: %i", maxMonkeyBars]];
	[lblnoType setString:[NSString stringWithFormat:@"Dynamite: %i     Monkey Bars: %i     Spring Seat: %i", t1, t2, t3]];
}

@end
