//
//  WorldViewController.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <stdlib.h>
#import "WorldViewController.h"
#import "WorldView.h"
#import "Shape.h"
#import "CellView.h"

@interface WorldViewController()
    @property (nonatomic, retain) World *world;
@end

@implementation WorldViewController

@synthesize world=_world;

- (void) addFakeWorld
{
    CGRect worldRect = CGRectMake(0, 0, 500, 500);
    World *newWorld = [[[World alloc] initWithRect:worldRect] autorelease];
    
    Entity *obj = nil;
    
    for (int i = 0; i < 35; i++) {
        int size = rand() % 20;
        int level = (50 - size) / 10;
        obj = [[Entity alloc] initWithType:CELL_ENEMY location:CGPointMake(rand() % 400 - 200, rand() % 550 - 275) size:CGPointMake(size, size) level:level];
        [newWorld addObject:obj];
        [obj release];
    }
    
    for (int i = 0; i < 15; i++) {
        int size = rand() % 40 + 20;
        int level = (50 - size) / 10;
        obj = [[Entity alloc] initWithType:CELL_ENEMY location:CGPointMake(rand() % 400 - 200, rand() % 550 - 275) size:CGPointMake(size, size) level:level];
        [newWorld addObject:obj];
        [obj release];
    }
    
    NSLog(@"built enemy");
    
    
    [newWorld.camera useScreenSize:self.view.bounds];
    
    self.world = newWorld;
    
    NSLog(@"set world");
}

- (void)dealloc
{
    NSLog(@"WorldViewController dealloc'd");
    [_world release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void) initWorldView
{
    
    CGRect myWorldRect = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    WorldView *wView = [[WorldView alloc] initWithFrame:myWorldRect];
    [wView setBackgroundColor:[UIColor blackColor]];
    
    //self.view = wView;
    //[self.view addSubview:wView];
    [wView release];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initWorldView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction) buttonPressed:(UIButton*)sender
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadViewObjects
{
    if(!self.world.objects)
    {
        NSLog(@"Error.. no objects");
    }
    Shape *subView = nil;
    for(Entity *obj in self.world.objects) {
        
        NSLog(@"Building view for ent %d", obj.objId);
        subView = [[CellView alloc] initWithFrame: [obj getFrame] CellType:obj.cellType Level:obj.level];
        subView.opaque = NO;
        subView.tag = obj.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        [self.view addSubview:subView];
        
        [obj addObserver:self forKeyPath:@"version" 
                 options:NSKeyValueObservingOptionInitial 
                 context:subView];
        [subView release];
    }
    
    NSLog(@"Done adding...");
    
    if(self.world.player)
    {
        subView = [[CellView alloc] initWithFrame: [self.world.player getFrame] CellType:self.world.player.cellType Level:0];
        subView.opaque = NO;
        subView.tag = self.world.player.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        [self.view addSubview:subView];
        [subView release];
    
        [self.world.player addObserver:self forKeyPath:@"version" 
                               options:NSKeyValueObservingOptionInitial 
                               context:subView];
    }
    
}

- (void) panShape: (Shape*) shape amount: (ShapePanData*)data
{
    Entity *obj = [self.world objectWithID: shape.tag];
    
    CGPoint newPoint = obj.location;
    newPoint.x += data.distance.x;
    newPoint.y += data.distance.y;
    
    obj.location = newPoint;
    
    [obj refresh];
}

- (void) removeListeners
{
    // Release our ownership of the WorldObjects
    for (Entity *obj in self.world.objects) {
        [obj removeObserver:self forKeyPath:@"version"];
    }
    
    [self.world.player removeObserver:self forKeyPath:@"version"];
}


- (void)setWorld:(World*) world
{
    NSLog(@"Setting world");
    _world = world;
    [_world retain];
    
    [self loadViewObjects];
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


@end
