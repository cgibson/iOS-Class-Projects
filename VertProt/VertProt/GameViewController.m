//
//  GameViewController.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "World.h"
#import "Shape.h"

@implementation Vec3

@synthesize x=x_;
@synthesize y=y_;
@synthesize z=z_;

- (id) initWithVals:(float)x y:(float)y z:(float) z
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    return self;
}

@end


@interface GameViewController()
@property (nonatomic, retain) World *world;
@property (nonatomic, retain) CADisplayLink *dispLink;
@property (nonatomic, retain) CMMotionManager *motionManager;
@end

@implementation GameViewController

@synthesize motionManager = motionManager_;
@synthesize world = world_;
@synthesize dispLink = dispLink_;
@synthesize gyroVec = gyroVec_;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self start];
    
}

- (void) initializeGyro
{
    
    // Motion Manager Code
    self.motionManager = [[CMMotionManager alloc] init];
    
    if(self.motionManager.gyroAvailable) {
        self.motionManager.gyroUpdateInterval = 1.0 / 60.0;
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler: ^(CMGyroData *gyroData, NSError *error)
         {
             
             CMRotationRate rotate = gyroData.rotationRate;
             
             [self.world.camera moveLookAt:CGPointMake(rotate.y * 2, rotate.x * 2)];
             [self.world refreshAll];
         }];
        
        
    } else {
        NSLog(@"No gyroscope on device.");
        [self.motionManager release];
    }
    
}



- (void) panShape: (Shape*) shape amount: (ShapePanData*)data
{
    Entity *obj = [self.world objectWithID: shape.tag];
    
    CGPoint newPoint = obj.location;
    newPoint.x += data.distance.x;
    newPoint.y += data.distance.y;
    
    obj.location = newPoint;
}

- (void) start
{
    
}

- (void) stop
{
    
}

- (void) dealloc
{
    [world_ release];
    [super dealloc];
}


- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(!self.world)
    {
        NSLog(@"World not loaded yet");
        return;
    }
    
    if ([keyPath isEqualToString:@"version"]) {
        ((UIView*)context).frame = [self.world.camera applyToRect:[((Entity*)object) getFrame]];
    }
}

- (void) frame: (CADisplayLink*) link
{
    if(!self.world) {
        NSLog(@"Error: world not initialized");
    }
    
    [self.world frame:link.duration];
}

@end
