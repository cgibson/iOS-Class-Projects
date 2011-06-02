//
//  World.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "World.h"


@interface World()
@property (nonatomic, retain) NSMutableArray *objects;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) Camera *camera;
@end

@implementation World

@synthesize objects = objects_;
@synthesize player=_player;
@synthesize camera = camera_;
@synthesize objectsWrap=_objectsWrap;

- (void) dealloc
{

    // Release our ownership of the WorldObjects
    /*for (Entity *obj in self.objects) {
        [obj release];
    }*/
    
    NSLog(@"World dealloc'd");
    [_player release];
    [objects_ release];
    [camera_ release];
    [super dealloc];
}

- (Entity*) objectWithID: (int) objId
{
    for (Entity* ent in self.objects) {
        if(ent.objId == objId)
            return ent;
    }
    return nil;//[self.objects objectAtIndex:objId];
}

- (id) initWithRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray arrayWithCapacity:10];
        self->bounds = rect;
    }
    
    self.objectsWrap = true;
    
    [self buildCamera:CGPointMake(0, 0)];
    
    return self;
}

- (void) buildCamera:(CGPoint)point
{
    [self.camera release];
    self.camera = [[[Camera alloc] initWithLook:point] autorelease];
}

- (void) addObject:(Entity *)obj
{
    [self.objects addObject:obj];
    [obj refresh];
}

- (void) setCamera:(Camera *)cam
{
    [camera_ release];
    camera_ = cam;
    [self.camera retain];
    [self refreshAll];
}

- (void) refreshAll
{
    for(Entity* ent in self.objects) {
        [ent refresh];
    }
}

- (void) frame:(CFTimeInterval)elapsed
{
    for (Entity* ent in self.objects) {
        [ent think:elapsed];
        
        CGPoint entLoc = ent.location;
        
        for (Entity* ent2 in self.objects) {
            if(ent.objId != ent2.objId && ent.level == ent2.level) {

                CGPoint distVec = CGPointMake(entLoc.x - ent2.location.x, entLoc.y - ent2.location.y);
            
                float dist = sqrt(pow(distVec.x, 2) + pow(distVec.y, 2));
                float totEntSize = (ent.size.x + ent2.size.x) / 2.0;
            
                if(dist < totEntSize) {
                    distVec.x /= dist;
                    distVec.y /= dist;
                
                    distVec.x *= totEntSize;
                    distVec.y *= totEntSize;
                
                    entLoc.x = ent2.location.x + distVec.x;
                    entLoc.y = ent2.location.y + distVec.y;
                }
                
            }
             
        }

        ent.location = entLoc;
        
        if(self.objectsWrap) {
            CGPoint loc = ent.location;
            if (loc.x < bounds.origin.x) {
                loc.x = bounds.origin.x + bounds.size.width;
                ent.location = loc;
            }else if (loc.x > bounds.origin.x + bounds.size.width) {
                loc.x = bounds.origin.x;
                ent.location = loc;
            }
            if (loc.y < bounds.origin.y) {
                loc.y = bounds.origin.y + bounds.size.height;
                ent.location = loc;
            }else if (loc.y > bounds.origin.y + bounds.size.height) {
                loc.y = bounds.origin.y;
                ent.location = loc;
            }
        }
         
    }
    //[self.player think:elapsed];
}

@end