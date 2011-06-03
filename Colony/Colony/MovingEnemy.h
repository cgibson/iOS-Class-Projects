//
//  MovingEnemy.h
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
#import "World.h"

@interface MovingEnemy : Enemy {
}

@property (nonatomic) CGPoint direction;
@property (nonatomic) CGPoint targetDirection;
@property (nonatomic) float animationAmt;

- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(float)size direction:(CGPoint)dir world:(World*)world;

- (void) changeDirection:(CGPoint)newDirection;

@end
