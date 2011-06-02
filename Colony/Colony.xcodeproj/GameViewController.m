//
//  GameViewController.m
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "WorldView.h"
#import "Running.h"

@interface DefaultGameViewController()
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL gyroEnabled;
@end

@interface WorldViewController()

@property (nonatomic, retain) World *world;

@end

@implementation GameViewController

@synthesize state=_state;
//@synthesize world = world_;

- (void) buildWorld
{
    //CGRect worldRect = CGRectMake(-500, -500, 1000, 1000);
    //World *newWorld = [[[World alloc] initWithRect:worldRect] autorelease];
    
    //[newWorld.camera useScreenSize:self.view.bounds];
    
    //self.world = newWorld;
    
    [self addFakeWorld];
    
    Player *player = [[Player alloc] initWithType:CELL_PLAYER location:CGPointMake(0, 0) size:CGPointMake(60, 60) level:0];
    [self setPlayer:player];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self buildWorld];
    }
    
    
    return self;
}

- (void)dealloc
{
    NSLog(@"GameViewController dealloc'd");
    [_state release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) initMenuButton
{
    CGRect buttonRect = CGRectMake(320.0f - (18.0f + 5.0f), 5.0f, 18.0f, 18.0f);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.frame = buttonRect;
    button.tag = 101;
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // add to a view
    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMenuButton];
    
    [self start];
    self.world.objectsWrap = true;
    /*if(self.state && self.state.running) {
        CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 109.0f);
        UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
        [myImage setImage:[UIImage imageNamed:@"Green_sphere.png"]];
        myImage.opaque = NO; // explicitly opaque for performance
        [self.view addSubview:myImage];
        [myImage release]; 
    }*/
    
    self.gyroEnabled = true;
    
    self.active = true;
    
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
    // TERRIBLE TERRIBLE CODE
    int topControllerIndex = [self.navigationController.viewControllers count] - 1;
    UIViewController *controller = [self.navigationController.viewControllers objectAtIndex: topControllerIndex-1];
    if([controller conformsToProtocol:@protocol(Running)]) {
        [(UIViewController<Running>*) controller start];
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) start
{
    NSLog(@"Started");
    [super start];
}

- (void) stop
{
    [super stop];
}


- (void) pause
{
    [super pause];
}

- (void) unpause
{
    [super unpause];
}

@end
