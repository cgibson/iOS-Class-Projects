//
//  Entity.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "types.h"

#define GROW_SPEED 100.0f

@class World;
@class Enemy;

typedef enum CellType_t{CELL_PLAYER, CELL_ENEMY} CellType_t;

#define TYPE_CELL 1

@class World;

@interface Entity : NSObject {
}

@property (nonatomic, readonly) int objId;
@property (nonatomic, readonly) int version;
@property (nonatomic) CGPoint location;
@property (nonatomic) float size;
@property (nonatomic) float targetSize;
@property (nonatomic) CellType_t cellType;
@property (nonatomic) int level;
@property (nonatomic) bool alive;
@property (nonatomic, retain) World *world;
@property (nonatomic) bool firstDraw;

- (id) initWithType: (CellType_t) type location:(CGPoint)loc size:(float)size world:(World*)world;
- (void) refresh;
- (CGRect) getTargetFrame;
- (CGRect) getFrame;
- (void) moveDelta:(CGPoint)delta;
- (void) moveDelta:(CGPoint)delta refresh:(bool)refresh;
- (void) moveDirection:(CGPoint)dir Elapsed:(NSTimeInterval)elapsed;
- (void) think:(NSTimeInterval)elapsed;
- (bool) doesHit:(Entity*)entity;
- (void) registerHit:(Entity*)entity WithMode:(GameMode_t)mode;
- (void) fight:(Entity*)entity;

@end
