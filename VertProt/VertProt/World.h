//
//  World.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Camera.h"
#import "Player.h"
#import "Enemy.h"
#import "types.h"

@interface World : NSObject {
    @private
    CGRect bounds;
}

@property (nonatomic, retain, readonly) NSMutableArray *objects;
@property (nonatomic, retain, readonly) NSMutableArray *backgroundObjects;
@property (nonatomic, retain, readonly) Player *player;
@property (nonatomic, retain, readonly) Camera *camera;
@property (nonatomic) bool objectsWrap;
@property (nonatomic) GameMode_t gameMode;
@property (nonatomic) float spawnUpdateTime;
@property (nonatomic) float timeSinceLastSpawn;
@property (nonatomic) int maxEnemies;
@property (nonatomic) int minEnemySize;
@property (nonatomic) int maxEnemySize;
@property (nonatomic) bool spawnNeeded;
@property (nonatomic) bool loseCondition;

- (Entity*) objectWithID: (int) objId;
- (id) initWithRect: (CGRect) rect;
- (id) initWithOptions:(NSDictionary*)dict;
- (void) setCamera: (Camera*) cam;
- (void) addObject: (Entity*) obj;
- (void) refreshAll;
- (void) frame: (CFTimeInterval)elapsed;
- (void) buildCamera:(CGPoint)point;
- (void) addEnemy:(Enemy*)enemy;
- (void) removeEnemy:(Enemy*)enemy;
- (void) backgroundEnemy:(Enemy*)enemy;

@end
