//
//  GameViewController.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DefaultGameViewController.h"
#import "World.h"
#import "Shape.h"
#import "CellView.h"

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


@interface DefaultGameViewController()
    @property (nonatomic, retain) CADisplayLink *dispLink;
    @property (nonatomic) BOOL active;
    @property (nonatomic) BOOL gyroEnabled;
@end

@implementation DefaultGameViewController

@synthesize dispLink = dispLink_;
@synthesize gyroVec = gyroVec_;
@synthesize active = active_;
@synthesize gyroEnabled = gyroEnabled_;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self start];
    
    self.gyroEnabled = false;
    
}

- (void) enableGyro
{
    // Motion Manager Code
    motionManager = [[CMMotionManager alloc] init];
    
    if(motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 1.0 / 60.0;
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMAccelerometerData *accelerometerData, NSError *error)
        {
            if(self.active && self.gyroEnabled)
            {
                CMAcceleration accel = accelerometerData.acceleration;
                [self.world.camera moveLookAt:CGPointMake(accel.x * 10, -accel.y * 10)];
                [self.world refreshAll];
            }
        }];
    }
    
    if(motionManager.gyroAvailable) {
        motionManager.gyroUpdateInterval = 1.0 / 60.0;
        [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler: ^(CMGyroData *gyroData, NSError *error)
         {
             
             if(self.active && self.gyroEnabled && false)
             {
                 CMRotationRate rotate = gyroData.rotationRate;
                 [self.world.camera moveLookAt:CGPointMake(rotate.y, rotate.x)];
                 [self.world refreshAll];
             }
         }];
        
        
        self.gyroEnabled = true;
    } else {
        NSLog(@"No gyroscope on device.");
        [motionManager release];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.active = true;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.active = false;
}

- (void) start
{
    
}

- (void) stop
{
    if (self.dispLink) {
        // Stop the animation timer
        [self.dispLink invalidate];
        self.dispLink = nil;
    }
    [self removeListeners];
}

- (void) dealloc
{
    NSLog(@"DefaultGameView dealloc'd");
    active_ = false;
    [self stop];
    
    if(self.gyroEnabled)
        [motionManager release];
    
    [dispLink_ release];
    [super dealloc];
}

- (void) frame: (CADisplayLink*) link
{
    if(!self.world) {
        NSLog(@"Error: world not initialized");
    }
    
    [self.world frame:link.duration];
}

@end
