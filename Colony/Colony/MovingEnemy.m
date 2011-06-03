//
//  MovingEnemy.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MovingEnemy.h"
#import "CGPointMath.h"

#define ANIMATION_SPEED 1.0
#define MAX_SPEED 100.0

@implementation MovingEnemy

@synthesize direction=_direction;
@synthesize targetDirection=_targetDirection;
@synthesize animationAmt=_animationAmt;

- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(float)size direction:(CGPoint)dir world:(World*)world
{
    self = [self initWithType:type
                     location:loc 
                         size:size 
                        world:world];
    
    if(self) {
        self.direction = CGPointMake(0, 0);
        self.animationAmt = 1.0;
        self.targetDirection = dir;
    }
    
    return self;
}


- (void) think:(NSTimeInterval)elapsed
{    
    CGPoint finalDirection = CGPointMake(0, 0);
    
    if(self.animationAmt > 0.0) {
        self.animationAmt -= ANIMATION_SPEED * elapsed;
        finalDirection = [CGPointMath CGPointBlendP1:self.direction 
                                                  P2:self.targetDirection 
                                              Amount:self.animationAmt];
    }else if(self.animationAmt <= 0.0)
    {
        self.animationAmt = 0.0;
        finalDirection = self.targetDirection;
    }

    [self moveDirection: finalDirection
                Elapsed:elapsed * 5];
    
    
    [super think:elapsed];
}

- (void) changeDirection:(CGPoint)newDirection
{
    self.animationAmt = 1.0;
    float speed = [CGPointMath CGPointMagnitude:newDirection];
    if(speed > MAX_SPEED) {
        newDirection = [CGPointMath CGPointMult:newDirection Amount:(1.0 / speed) * MAX_SPEED];
    }
    self.direction = newDirection;
}

@end
