//
//  Entity.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "World.h"

@interface Entity()
    @property (nonatomic) int objId;
    @property (nonatomic) int version;
@end

@implementation Entity

@synthesize objId = objId_;
@synthesize location = location_;
@synthesize size = size_;
@synthesize targetSize = targetSize_;
@synthesize version = version_;
@synthesize cellType=_cellType;
@synthesize level=_level;
@synthesize alive=_alive;
@synthesize world=_world;
@synthesize firstDraw=_firstDraw;
- (void)dealloc
{
    NSLog(@"Entity %d dealloc'd", objId_);
    [super dealloc];
}

- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(float)size world:(World*)world {
    static int nextId = 100;
    self = [super init];
    
    self.firstDraw = true;
    self.objId = nextId++;
    self.cellType = type;
    self.location = loc;
    self.size = 10;
    self.targetSize = size;
    self.version = 0;
    self.level = 0;
    self.alive = true;
    self.world = world;
    
    return self;
}

- (void) refresh
{
    if(!self)
    {
        NSLog(@"Error, modifying object that doesn't exist");
    }
    self.version++;
}

- (CGRect) getFrame
{
    return CGRectMake(self.location.x - self.size/ 2., self.location.y - self.size / 2., self.size, self.size);
}

- (CGRect) getTargetFrame
{
    return CGRectMake(self.location.x - self.targetSize/ 2., self.location.y - self.targetSize / 2., self.targetSize, self.targetSize);
}


- (void) think:(NSTimeInterval)elapsed
{
    if(fabs(self.size - self.targetSize) > (GROW_SPEED * elapsed)){
        float dir = (self.size < self.targetSize) ? 1 : -1;
        self.size += GROW_SPEED * elapsed * dir;

    }else{
        self.size = self.targetSize;
    }
    //NSLog(@"Entity %d is thinking...", self.objId);
}

- (void) moveDelta:(CGPoint)delta
{
    CGPoint loc = self.location;
    loc.x += delta.x;
    loc.y += delta.y;
    self.location = loc;
    //[self refresh];
}

- (void) moveDelta:(CGPoint)delta refresh:(bool)refresh
{
    CGPoint loc = self.location;
    loc.x += delta.x;
    loc.y += delta.y;
    self.location = loc;
    //if(refresh)
    //[self refresh];
}

- (void) moveDirection:(CGPoint)dir Elapsed:(NSTimeInterval)elapsed
{
    CGPoint loc = self.location;
    loc.x += dir.x * elapsed;
    loc.y += dir.y * elapsed;
    self.location = loc;
    //[self refresh];
}


- (bool) doesHit:(Entity*)entity
{
    return false;
}

- (void) registerHit:(Entity*)entity WithMode:(GameMode_t)mode
{
    if(self.size > entity.size)
    {
        
    }
}

- (void) fight:(Entity*)entity
{
    if(self.size < entity.size) {
        self.alive = false;
    }
}

@end
