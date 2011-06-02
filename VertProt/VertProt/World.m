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
@property (nonatomic, retain) Camera *camera;
@end

@implementation World

@synthesize objects = objects_;
@synthesize player=_player;
@synthesize camera = camera_;

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
    
}

@end