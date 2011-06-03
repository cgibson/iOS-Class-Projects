//
//  Player.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player


- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(float)size world:(World *)world
{
    self = [super initWithType:type location:loc size:size world:world];
    
    self.location = CGPointMake(160, 240);
    
    return self;
}
 
 
 

- (void) think:(NSTimeInterval)elapsed
{
    [super think:elapsed];
}

@end
