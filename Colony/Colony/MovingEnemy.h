//
//  MovingEnemy.h
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"

@interface MovingEnemy : Enemy {
}

@property (nonatomic) CGPoint direction;

- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(CGPoint)size direction:(CGPoint)dir;

@end
