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
@end

@implementation World

@synthesize objects = objects_;

- (void) dealloc
{
    [objects_ release];
    [super dealloc];
}

- (Entity*) objectwithID: (int) objId
{
    return [self.objects objectAtIndex:objId];
}

- (id) initWithRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray arrayWithCapacity:10];
        self->bounds = rect;
    }
    
    return self;
}

- (void) addObject:(Entity *)obj
{
    [self.objects addObject:obj];
}

@end