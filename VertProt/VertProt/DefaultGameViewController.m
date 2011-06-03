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


@interface DefaultGameViewController()
    @property (nonatomic) BOOL active;
    @property (nonatomic) BOOL gyroEnabled;
    @property (nonatomic) BOOL gyroCalibrated;
    @property (nonatomic) CGPoint gyroOffset;
@end

@implementation DefaultGameViewController

@synthesize gyroVec = gyroVec_;
@synthesize active = active_;
@synthesize gyroEnabled = gyroEnabled_;
@synthesize gyroCalibrated=gyroCalibrated_;
@synthesize gyroOffset=gyroOffset_;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self initializeGyro];
    
    [self start];
    
    self.gyroEnabled = false;
    self.gyroCalibrated = false;
    
}

- (void) initializeGyro
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
                
                if(!self.gyroCalibrated) {
                    self.gyroOffset = CGPointMake(accel.x * -10.0f, accel.y * 10.0f);
                    self.gyroCalibrated = true;
                    NSLog(@"GYRO: callibrated to %.2f, %.2f", self.gyroOffset.x, self.gyroOffset.y);
                }else{
                    [self.world.camera moveLookAt:CGPointMake(accel.x * -10.0f - self.gyroOffset.x, 
                                                              accel.y * 10.0f - self.gyroOffset.y)];
                }
                //[self.world refreshAll];
            }
        }];
    }
    /*
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
     */
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

- (void) dealloc
{
    NSLog(@"DefaultGameView dealloc'd");
    active_ = false;
    
    if(self.gyroEnabled)
        [motionManager release];
    
    [super dealloc];
}

- (void) start
{
    [super start];
    self.active = true;
}

- (void) stop
{
    [super stop];
    //self.active = false;
}

- (void) pause
{
    [super pause];
}

- (void) unpause
{
    [super unpause];
}

- (void) callibrateGyro
{
    self.gyroCalibrated = false;
}

@end
