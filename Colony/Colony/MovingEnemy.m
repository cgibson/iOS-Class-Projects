//
//  MovingEnemy.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MovingEnemy.h"


@implementation MovingEnemy

@synthesize direction=_direction;

- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(CGPoint)size direction:(CGPoint)dir
{
    self = [self initWithType:type
                     location:loc 
                         size:size 
                        level:0];
    
    if(self) {
        self.direction = dir;
    }
    
    return self;
}


- (void) think:(NSTimeInterval)elapsed
{    
    [super think:elapsed];
    [self moveDirection: self.direction
                Elapsed:elapsed * 5];
}

@end
