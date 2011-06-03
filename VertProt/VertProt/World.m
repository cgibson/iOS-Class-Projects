//
//  World.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "World.h"
#import "CGPointMath.h"


@interface World()
@property (nonatomic, retain) NSMutableArray *objects;
@property (nonatomic, retain) NSMutableArray *backgroundObjects;
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) Camera *camera;
@end

@implementation World

@synthesize objects = objects_;
@synthesize backgroundObjects = backgroundObjects_;
@synthesize player=_player;
@synthesize camera = camera_;
@synthesize objectsWrap=_objectsWrap;
@synthesize gameMode=_gameMode;
@synthesize spawnUpdateTime=_spawnUpdateTime;
@synthesize timeSinceLastSpawn=_timeSinceLastSpawn;
@synthesize maxEnemies=_maxEnemies;
@synthesize spawnNeeded=_spawnNeeded;
@synthesize loseCondition=_loseCondition;
@synthesize minEnemySize=_minEnemySize;
@synthesize maxEnemySize=_maxEnemySize;

- (void) dealloc
{

    // Release our ownership of the WorldObjects
    /*for (Entity *obj in self.objects) {
        [obj release];
    }*/
    
    NSLog(@"World dealloc'd");
    [_player release];
    [backgroundObjects_ release];
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
    NSLog(@"What are we? %d", self.gameMode);
    return self;
}

- (id) initWithRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray arrayWithCapacity:10];
        self.backgroundObjects = [NSMutableArray arrayWithCapacity:10];
        self->bounds = rect;
    
        self.loseCondition = false;
        self.gameMode = PEACEFUL;
    
        self.objectsWrap = true;
        
        self.minEnemySize = 10;
        self.maxEnemySize = 60;
        
        self.spawnUpdateTime = 1.0;
        self.timeSinceLastSpawn = 0.0;
    
        self.maxEnemies = 50;
    
        [self buildCamera:CGPointMake(0, 0)];
    }
    
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

- (bool) handleIntersectEnt1:(Entity*)ent Ent2:(Entity*)ent2
{
    CGPoint entLoc = [self.camera applyToPoint:ent.location];
    CGPoint ent2Loc = [self.camera applyToPoint:ent2.location];
    
    if(ent.level == ent2.level) {
        
        CGPoint distVec = [CGPointMath CGPointSubtractP1:entLoc P2:ent2Loc];
        
        float dist = [CGPointMath CGPointMagnitude:distVec];
        float invDist = 1.0f / dist;
        float totEntSize = (ent.size + ent2.size) / 2.0;
        
        if(dist < totEntSize) {
            CGPoint direction = [CGPointMath CGPointMult:distVec Amount:invDist];
            
            CGPoint midPoint = [CGPointMath CGPointMult:distVec Amount:0.5];
            
            CGPoint entMove = [CGPointMath CGPointSubtractP1:[CGPointMath CGPointMult:direction 
                                                                               Amount:0.5 * totEntSize]
                                                          P2:midPoint];
            
            ent.location = [CGPointMath CGPointAddP1:ent.location P2:entMove];
            ent2.location = [CGPointMath CGPointSubtractP1:ent2.location 
                                                        P2:entMove];
            
            return true;
            
        }
        
    }
    return false;
}

- (bool) handlePlayerIntersectEnt:(Entity*)ent
{
    CGPoint entLoc = [self.camera applyToPoint:ent.location];
    CGPoint playerLoc = self.camera.screenOffset;// = [self.camera applyToPoint:ent2.location];
    
    if(ent.level == self.player.level) {
        
        CGPoint distVec = [CGPointMath CGPointSubtractP1:entLoc P2:playerLoc];
        
        float dist = [CGPointMath CGPointMagnitude:distVec];
        float invDist = 1.0f / dist;
        float totEntSize = (ent.size + self.player.size) / 2.0;
        
        if(dist < totEntSize) {
            CGPoint direction = [CGPointMath CGPointMult:distVec Amount:invDist];
            
            CGPoint midPoint = [CGPointMath CGPointMult:distVec Amount:0.5];
            
            CGPoint entMove = [CGPointMath CGPointSubtractP1:[CGPointMath CGPointMult:direction 
                                                                               Amount:totEntSize] 
                                                          P2:midPoint];
            
            ent.location = [CGPointMath CGPointAddP1:ent.location P2:entMove];
            //self.player.location = CGPointSubtract(self.player.location, entMove);
            
            return true;
            
        }
        
    }
    return false;
}

- (void) frame:(CFTimeInterval)elapsed
{
    self.timeSinceLastSpawn += elapsed;
    if(self.timeSinceLastSpawn > self.spawnUpdateTime && [self.objects count] < self.maxEnemies) {
        self.spawnNeeded = true;
        self.timeSinceLastSpawn = 0.0;
    }
    
    bool hit;
    int count = [self.objects count];
    
    for (Entity* ent in self.backgroundObjects) {
        [ent think:elapsed];
        
        
        // Get camera bounding box
        CGRect camBounds = CGRectMake(bounds.origin.x - self.camera.lookAt.x, 
                                      bounds.origin.y -
                                      self.camera.lookAt.y, 
                                      bounds.size.width, bounds.size.height);
        
        // Handle world wrapping
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
    }
    
    for (int i = 0; i < count; i++) {
        Entity* ent = [self.objects objectAtIndex:i];

        [ent think:elapsed];
        
        if(!ent) {
            continue;
        }
        
        // Handle intersections with other entities
        for (int j = i+1; j < count; j++) {
            Entity* ent2 = [self.objects objectAtIndex:j];
            
            if(!ent2) {
                continue;
            }
            hit = [self handleIntersectEnt1:ent Ent2:ent2];
            
            if(hit) {
                [ent registerHit:ent2 WithMode:self.gameMode];
                [ent2 registerHit:ent WithMode:self.gameMode];
            }
             
        }
        
        // Get camera bounding box
        CGRect camBounds = CGRectMake(bounds.origin.x - self.camera.lookAt.x, 
                                      bounds.origin.y -
                                      self.camera.lookAt.y, 
                                      bounds.size.width, bounds.size.height);
        
        // Handle world wrapping
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
    
    if(self.player) {
        [self.player think:elapsed];
        
        for(Entity* ent in self.objects) {
        
            // Handle intersections with the player
            hit = [self handlePlayerIntersectEnt:ent];
        
            if(hit) {
                if(ent.size < self.player.size) {
                    ent.alive = false;
                    [self addToPlayer:ent.size];
                }else{
                    self.loseCondition = true;
                    NSLog(@"LOSING NAUGH!");
                }
            }
        }
    }
    //
}

- (void) addEnemy:(Enemy*)enemy
{
    enemy.world = self;
    [self.objects addObject:enemy];
}

- (void) removeEnemy:(Enemy*)enemy
{
    [self.objects removeObject:enemy];
}


- (void) backgroundEnemy:(Enemy*)enemy
{
    [self.backgroundObjects addObject:enemy];
    [self.objects removeObject:enemy];

}

- (void) updateEnemySizes
{
    if(self.player.score < 150) {
        NSLog(@"LEVEL 1");
        self.minEnemySize = 10;
        self.maxEnemySize = 80;
    } else if(self.player.score < 300) {
        NSLog(@"LEVEL 2");
        self.minEnemySize = 20;
        self.maxEnemySize = 100;
        self.spawnNeeded = 0.8;
    } else if(self.player.score < 500) {
        NSLog(@"LEVEL 3");
        self.minEnemySize = 30;
        self.maxEnemySize = 120;
        self.spawnNeeded = 0.5;
    }
}

- (void) addToPlayer:(float)mass
{
    self.player.score += mass;
    NSLog(@"Score: %f", self.player.score);
    [self updateEnemySizes];
}

@end