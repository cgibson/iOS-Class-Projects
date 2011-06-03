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
@synthesize gameMode=_gameMode;

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

- (id) initWithOptions:(NSDictionary*)dict
{
    CGRect worldBounds = [(NSValue*) [dict objectForKey:@"bounds"] CGRectValue];
    self = [self initWithRect:worldBounds];
    
    if(self)
    {
        NSValue *screenSize = (NSValue*) [dict objectForKey:@"screen"];
        if(screenSize) {
            [self.camera useScreenSize:[screenSize CGRectValue]];
        }
        
        NSNumber *gameMode = (NSNumber*) [dict objectForKey:@"mode"];
        if(gameMode) {
            self.gameMode = [gameMode intValue];
        }else{
            self.gameMode = PEACEFUL;
        }
    }
    
    return self;
}

- (id) initWithRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray arrayWithCapacity:10];
        self->bounds = rect;
    }
    
    self.gameMode = PEACEFUL;
    
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
    NSLog(@"Refresh all");
    for(Entity* ent in self.objects) {
        [ent refresh];
    }
}

- (void) frame:(CFTimeInterval)elapsed
{
    int count = [self.objects count];
    for (int i = 0; i < count; i++) {
        Entity* ent = [self.objects objectAtIndex:i];

        [ent think:elapsed];
        
        CGPoint entLoc = ent.location;
        
        if(!ent) {
            continue;
        }
        
        for (int j = i+1; j < count; j++) {
            Entity* ent2 = [self.objects objectAtIndex:j];
            
            if(!ent2) {
                continue;
            }
            
            CGPoint ent2Loc = ent2.location;
            if(ent.level == ent2.level) {

                CGPoint distVec = CGPointMake(entLoc.x - ent2Loc.x, entLoc.y - ent2Loc.y);
            
                float dist = sqrt(pow(distVec.x, 2) + pow(distVec.y, 2));
                float totEntSize = (ent.size + ent2.size) / 2.0;
            
                if(dist < totEntSize) {
                    distVec.x /= dist;
                    distVec.y /= dist;
                
                    distVec.x *= totEntSize;
                    distVec.y *= totEntSize;
                    
                    CGPoint midpoint = CGPointMake((entLoc.x + ent2Loc.x) * 0.5, (entLoc.y + ent2Loc.y) * 0.5);
                    
                    // Move first object
                    entLoc.x = midpoint.x + (distVec.x / 2.);
                    entLoc.y = midpoint.y + (distVec.y / 2.);
                    
                    // Move other object
                    ent2Loc.x = midpoint.x - (distVec.x / 2.);
                    ent2Loc.y = midpoint.y - (distVec.y / 2.);
                    
                    ent2.location = ent2Loc;
                    
                    [ent registerHit:ent2];
                    [ent2 registerHit:ent];
                    
                }
                
            }
             
        }
        

        ent.location = entLoc;
        
        CGRect camBounds = CGRectMake(bounds.origin.x - self.camera.lookAt.x, 
                                      bounds.origin.y -
                                      self.camera.lookAt.y, 
                                      bounds.size.width, bounds.size.height);
        
        if(self.objectsWrap) {
            CGPoint loc = ent.location;
            if (loc.x < camBounds.origin.x) {
                loc.x = camBounds.origin.x + camBounds.size.width;
                ent.location = loc;
            }else if (loc.x > camBounds.origin.x + camBounds.size.width) {
                loc.x = camBounds.origin.x;
                ent.location = loc;
            }
            if (loc.y < camBounds.origin.y) {
                loc.y = camBounds.origin.y + camBounds.size.height;
                ent.location = loc;
            }else if (loc.y > camBounds.origin.y + camBounds.size.height) {
                loc.y = camBounds.origin.y;
                ent.location = loc;
            }
        }
        
        //[ent refresh];
         
    }
    //[self.player think:elapsed];
}


- (void) addEnemy:(Enemy*)enemy
{
    [self.objects addObject:enemy];
}

- (void) removeEnemy:(Enemy*)enemy
{
    [self.objects removeObject:enemy];
}

@end