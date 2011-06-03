//
//  Enemy.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "types.h"
#import "Player.h"
@implementation Enemy


- (void) registerHit:(Entity *)entity WithMode:(GameMode_t)mode
{
    
    switch (mode) {
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
            break;
        default:
            break;
    }
}

@end
