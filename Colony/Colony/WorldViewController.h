//
//  WorldViewController.h
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "Running.h"
#import "Enemy.h"

@interface WorldViewController : UIViewController <Running>{
    
}

@property (nonatomic, retain, readonly) CADisplayLink *dispLink;
@property (nonatomic, retain, readonly) World *world;

- (void) loadViewObjects;
- (void) removeListeners;
- (void) setWorld: (World*) world;
- (void) addFakeWorld;
- (void) start;
- (void) stop;
- (void) frame:(CADisplayLink*)link;

- (void) setPlayer:(Player*)player;
- (void) createPlayerDefault;
- (void) spawnEnemy;
- (void) addEnemy:(Enemy*)enemy;
- (void) removeEnemy:(Enemy*)enemy;
- (void) spawnEnemyWithLevel:(int)level;
@end
