//
//  FirstViewController.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "Entity.h"
#import "Shape.h"
#import "CellView.h"
#import "Camera.h"



@interface GameViewController()
@property (nonatomic, retain) CMMotionManager *motionManager;
@end

@implementation FirstViewController

@synthesize motionManager = motionManager_;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Shape *subView;
    Entity *obj;
    
    // Main Cell
    obj = [[Entity alloc] initWithType:1 location:CGPointMake(0,0) size:CGPointMake(60, 60)];
    [self.world addObject:obj];
    subView = [[CellView alloc] initWithFrame: [obj getFrame]];
    subView.opaque = NO;
    subView.tag = obj.objId;
    subView.target = self;
    subView.panAction = @selector(panShape:amount:);
    [self.view addSubview:subView];
    [subView release];
    
    // Monitor with KVO
    [obj addObserver:self forKeyPath:@"version" 
             options:NSKeyValueObservingOptionInitial 
             context:subView];
    

    
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void) panShape: (Shape*) shape amount: (ShapePanData*)data
{

}

- (void)dealloc
{
    [motionManager_ release];
    [super dealloc];
}

@end
