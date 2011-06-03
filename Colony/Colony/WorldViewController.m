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
@synthesize active = active_;

- (void) addFakeWorld
{
    CGRect worldRect = CGRectMake(-200, -300, 400, 600);
    self.world = [[[World alloc] initWithRect:worldRect] autorelease];
    [self.world.camera useScreenSize:self.view.bounds];
    
    MovingEnemy *obj = nil;
    
    
    for (int i = 0; i < 35; i++) {
        int size = rand() % 20;
        float movX = ((float)rand() / RAND_MAX) * 20.0 - 10.0;
        float movY = ((float)rand() / RAND_MAX) * 20.0 - 10.0;
        obj = [[MovingEnemy alloc] initWithType:CELL_ENEMY 
                                  location:CGPointMake(rand() % 400 - 200, rand() % 600 - 300)
                                      size:size
                                      direction:CGPointMake(movX, movY) 
                                          world:self.world];
        obj.level = 1;
        [self addEnemy:obj];
        [obj release];
    }
    
    self.world.gameMode = PEACEFUL;
    
}

- (void)lose
{
    self.active = false;
    
    CGRect textFrame = CGRectMake(10, 100, 300, 150);
    UITextView *txt = [[UITextView alloc] initWithFrame:textFrame];
    
    txt.text = @"You Lose!";
    txt.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:txt];
    
    [txt release];
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
    self.active = true;
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
    /*
    Shape *subView = nil;
    
    if(self.world.objects)
    {
        for(Entity *obj in self.world.objects) {
            subView = [[CellView alloc] initWithFrame: [obj getTargetFrame] CellType:obj.cellType Level:obj.level];
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
    }
    
    if(self.world.player)
    {
        subView = [[CellView alloc] initWithFrame: [self.world.player getTargetFrame] CellType:self.world.player.cellType Level:0];
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
     */
    
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
        //enemy.alive = false;
        NSLog(@"Enemy %d Dead!", enemy.objId);
    }
    
    [obj refresh];
}

- (void) removeListener:(Entity*)entity
{

    [entity removeObserver:self forKeyPath:@"version"];
}

- (void) removeListeners
{
    // Release our ownership of the WorldObjects
    for (Entity *obj in self.world.objects) {
        [self removeListener:obj];
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
        if( [object isKindOfClass:[Entity class]] )
        {
            if(!((Entity*)object).alive) {
                NSLog(@"Identified dead enemy: %d", ((Entity*)object).objId);
                //[self.world removeEnemy:(Enemy*)object];
                [self removeListener:(Entity*)object];
                [(UIView*)context removeFromSuperview];
                [self.world removeEnemy:(Enemy*)object];
                
            }else {
                //NSLog(@"Camera: %f %f", self.world.camera.lookAt.x, self.world.camera.lookAt.y);
                //UIView *v = (UIView*)context;
                //v.frame = [self.world.camera applyToRect:[((Entity*)object) getFrame]];
            }
        }
    }
}

- (void) start
{
    NSLog(@"STARTING TIMER");
    self.active = true;
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

- (void) updateObjectList:(NSMutableArray*)array background:(bool)background
{
    int j = 0;
    for(int i = 0; i < [array count]; i++) {
        Entity *entity = [array objectAtIndex:i];
        UIView *subview = [self.view.subviews objectAtIndex:j];
        while(subview.tag < entity.objId) {
            j++;
            subview = [self.view.subviews objectAtIndex:j];
        }
        if(subview.tag > entity.objId) {
            NSLog(@"No Match for Object!");
            continue;
        }
        
        if(entity.firstDraw) {
            entity.firstDraw = false;
        }else{
            subview.frame = [self.world.camera applyToRect:[entity getFrame]];
        }
        
        subview.alpha = (entity.level == 0) ? (entity.size / (float)entity.targetSize) : 0.3;

        
        if(!entity.alive || abs(entity.level - self.world.player.level) > 1) {
            [self removeListener:entity];
            [subview removeFromSuperview];
            [self.world removeEnemy:(Enemy*)entity];
            j--;
            i--;
        }else if(entity.level == self.world.player.level+1 && background) {
            [self.world backgroundEnemy:(Enemy*)entity];
            j--;
            i--;
        }else if(entity.level > self.world.player.level+1) {
            entity.alive = false;
        }
        
        
        j++;
    }
    
}

- (void) frame:(CADisplayLink*)link
{
    [self.world frame:link.duration];
    
    if(self.world.spawnNeeded) {
        [self spawnEnemy];
        self.world.spawnNeeded = false;
    }
    
    [self updateObjectList:self.world.objects background:true];
    [self updateObjectList:self.world.backgroundObjects background:false];

    if(self.world.loseCondition) {
        [self lose];
    }
}


- (void) setPlayer:(Player*)player
{
    if(player)
    {
        [self.world setPlayer:player];
        
        Shape *subView = [[CellView alloc] initWithFrame: [self.world.player getTargetFrame] CellType:player.cellType Level:0];
        subView.opaque = NO;
        subView.tag = player.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        
        [self.view addSubview:subView];
        [subView release];
        
        [player addObserver:self forKeyPath:@"version" 
                               options:NSKeyValueObservingOptionInitial 
                               context:subView];
    }
}

- (void) createPlayerDefault
{
    Player *player = [[Player alloc] initWithType:CELL_PLAYER 
                                         location:CGPointMake(0, 0) 
                                             size:60 
                                            world:self.world];
    [self setPlayer:player];
}

- (void) addEnemy:(Enemy*)enemy
{
    if(enemy) {
        [self.world addEnemy:enemy];
        
        CGRect frame = [enemy getTargetFrame];
        Shape *subView = [[CellView alloc] initWithFrame:frame CellType:enemy.cellType Level:0];
        subView.opaque = NO;
        subView.alpha = 0.0;
        subView.tag = enemy.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        [self.view addSubview:subView];
        [subView release];
        [subView setNeedsDisplay];
        
        [enemy addObserver:self forKeyPath:@"version" 
                   options:NSKeyValueObservingOptionInitial 
                   context:subView];
    }
}

- (void) addEnemyInBackground:(Enemy*)enemy
{
    if(enemy) {
        [self.world addEnemy:enemy];
        
        CGRect frame = [enemy getTargetFrame];
        Shape *subView = [[CellView alloc] initWithFrame:frame CellType:enemy.cellType Level:0];
        subView.opaque = NO;
        subView.alpha = 0.0;
        subView.tag = enemy.objId;
        subView.target = self;
        subView.panAction = @selector(panShape:amount:);
        [self.view addSubview:subView];
        [subView release];
        [subView setNeedsDisplay];
        
        [self.view sendSubviewToBack:subView];
        
        [enemy addObserver:self forKeyPath:@"version" 
                   options:NSKeyValueObservingOptionInitial 
                   context:subView];
    }
}

- (Enemy*) spawnEnemyMin
{
    Enemy *obj;
    int min = self.world.minEnemySize;
    int max = self.world.maxEnemySize;
    int size = rand() % (max-min) + min;
    float movX = ((float)rand() / RAND_MAX) * 20.0;
    float movY = ((float)rand() / RAND_MAX) * 20.0;
    
    movX *= (rand() % 2 == 1) ? 1 : -1;
    movY *= (rand() % 2 == 1) ? 1 : -1;
    
    obj = [[MovingEnemy alloc] initWithType:CELL_ENEMY 
                                   location:CGPointMake(rand() % 400 - 200, rand() % 600 - 300)
                                       size:size
                                  direction:CGPointMake(movX, movY) 
                                      world:self.world];
    obj.level = 0;
    [self addEnemy:obj];
    [obj release];
    return obj;
}


- (void) spawnEnemyWithLevel:(int)level
{
    Enemy *obj;
    int size = rand() % 30;
    float movX = ((float)rand() / RAND_MAX) * 40.0 - 20.0;
    float movY = ((float)rand() / RAND_MAX) * 40.0 - 20.0;
    obj = [[MovingEnemy alloc] initWithType:CELL_ENEMY 
                                   location:CGPointMake(rand() % 400 - 200, rand() % 600 - 300)
                                       size:size
                                  direction:CGPointMake(movX, movY) 
                                      world:self.world];
    obj.level = 0;
    [self addEnemy:obj];
    obj.level = 1;
    [obj release];
}

- (void) removeEnemy:(Enemy*)enemy
{
    if(enemy) {
        for (Entity* ent in self.world.objects) {
            if(ent.objId == enemy.objId) {
                [self removeListener:ent];
                
                [self.world removeEnemy:(Enemy*)ent];
            }
        }
    }
}



@end
