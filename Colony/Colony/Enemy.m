//
//  Enemy.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "World.h"

@implementation Enemy


- (void) registerHit:(Entity *)entity
{
    switch (self.world.gameMode) {
        case SURVIVAL:
            if([entity isKindOfClass:[Player class]])
            {
                [self fight:entity];
            }
            break;
        case THUNDERDOME:
            [self fight:entity];
            break;
        case PEACEFUL:
        default:
            break;
    }
}

@end
