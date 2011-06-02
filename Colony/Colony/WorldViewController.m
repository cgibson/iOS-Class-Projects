//
//  WorldViewController.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "WorldViewController.h"
#import "WorldView.h"
#import "Shape.h"
#import "CellView.h"
#import "MovingEnemy.h"
@interface WorldViewController()
    @property (nonatomic, retain) CADisplayLink *dispLink;
    @property (nonatomic, retain) World *world;
@end

@interface World()
@property (nonatomic, retain) Player *player;
@end

@implementation WorldViewController

@synthesize world=_world;
@synthesize dispLink = dispLink_;

- (void) addFakeWorld
{
    CGRect worldRect = CGRectMake(-200, -300, 400, 600);
    World *newWorld = [[[World alloc] initWithRect:worldRect] autorelease];
    
    MovingEnemy *obj = nil;
    
    for (int i = 0; i < 35; i++) {
        int size = rand() % 20;
        int level = (50 - size) / 10;
        float movX = ((float)rand() / RAND_MAX) * 20.0 - 10.0;
        float movY = ((float)rand() / RAND_MAX) * 20.0 - 10.0;
        obj = [[MovingEnemy alloc] initWithType:CELL_ENEMY 
                                  location:CGPointMake(rand() % 400 - 200, rand() % 600 - 300)
                                      size:CGPointMake(size, size)
                                      direction:CGPointMake(movX, movY)];
        obj.level = level;
        [newWorld addObject:obj];
        [obj release];
    }
    
    for (int i = 0; i < 15; i++) {
        int size = rand() % 40 + 20;
        int level = (50 - size) / 10;
        float movX = ((float)rand() / RAND_MAX) * 40.0 - 20.0;
        float movY = ((float)rand() / RAND_MAX) * 40.0 - 20.0;
        obj = [[MovingEnemy alloc] initWithType:CELL_ENEMY 
                                       location:CGPointMake(rand() % 400 - 200, rand() % 600 - 300)
                                           size:CGPointMake(size, size)
                                      direction:CGPointMake(movX, movY)];
        obj.level = level;
        [newWorld addObject:obj];
        [obj release];
    }
    
    
    [newWorld.camera useScreenSize:self.view.bounds];
    
    self.world = newWorld;
}

- (void)dealloc
{
    [self removeListeners];
    [self stop];
    NSLog(@"WorldViewController dealloc'd");
    [dispLink_ release];
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
    
    if([obj isKindOfClass:[MovingEnemy class]]) {
        MovingEnemy *enemy = (MovingEnemy*)obj;
        CGPoint velPoint;
        velPoint.x = data.velocity.x * (1.0 / 6.0);
        velPoint.y = data.velocity.y * (1.0 / 6.0);
        enemy.direction = velPoint;
    }
    
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
        //NSLog(@"Camera: %f %f", self.world.camera.lookAt.x, self.world.camera.lookAt.y);
        ((UIView*)context).frame = [self.world.camera applyToRect:[((Entity*)object) getFrame]];
    }
}

- (void) start
{
    NSLog(@"STARTING TIMER");
    
    if(self.dispLink) {
        [self.dispLink invalidate];
    }
    
    self.dispLink = [CADisplayLink displayLinkWithTarget:self
                                                selector:@selector(frame:)];
    self.dispLink.frameInterval = 1;
    
    [self.dispLink addToRunLoop:[NSRunLoop mainRunLoop] 
                        forMode:NSDefaultRunLoopMode];
}

- (void) stop
{
    NSLog(@"STOPPING TIMER");
    if (self.dispLink) {
        // Stop the animation timer
        [self.dispLink invalidate];
        self.dispLink = nil;
    }
}

- (void) pause
{
    [self stop];
}

- (void) unpause
{
    [self start];
}

- (void) frame:(CADisplayLink*)link
{
    [self.world frame:link.duration];
}


- (void) setPlayer:(Player*)player
{
    if(player)
    {
        [self.world setPlayer:player];
        
        Shape *subView = [[CellView alloc] initWithFrame: [self.world.player getFrame] CellType:self.world.player.cellType Level:0];
        subView.opaque = NO;
        subView.tag = self.world.player.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        [self.view addSubview:subView];
        [subView release];
        
        [self.world.player addObserver:self forKeyPath:@"version" 
                               options:NSKeyValueObservingOptionInitial 
                               context:subView];
    }}

- (void) addEnemy:(Enemy*)enemy
{
    if(enemy) {
        Shape *subView = [[CellView alloc] initWithFrame: [self.world.player getFrame] CellType:self.world.player.cellType Level:0];
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



@end