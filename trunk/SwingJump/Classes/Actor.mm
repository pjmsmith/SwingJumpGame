//
//  Actor.mm
//  SwingJump
//
//  Created by Sean Stavropoulos on 2/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Actor.hh"

@implementation Actor
@synthesize type;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.type = -1;
    }
    return self;
}

- (void)dealloc {
	[super dealloc];
}



@end