//
//  MenuController.m
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define NEW_GAME_BUTTON 101

#import "MenuController.h"
#import "WorldViewController.h"
#import "WorldView.h"

@implementation MenuController

@synthesize state=_state;
@synthesize GVController=_GVController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self buildWorld];
        // Custom initialization
        
        self.GVController = [[WorldViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        [self.GVController addFakeWorld];
        [self.view addSubview:self.GVController.view];
        [self.view sendSubviewToBack:self.GVController.view];
        
        self.GVController.world.spawnUpdateTime = 0.25;
        self.GVController.world.objectsWrap = true;
        [self.GVController start];
        
        
        //[worldView release];
        
        /*
        UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
        [myImage setImage:[UIImage imageNamed:@"Green_sphere.png"]];
        myImage.opaque = NO; // explicitly opaque for performance
        [self.view addSubview:myImage];
        [self.view sendSubviewToBack:myImage];
        [myImage release]; 
         */
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) exit
{
    exit(0);
}

- (void) newGame
{
    [self.state newGame];
    GameViewController *gameView = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    gameView.state = self.state;
    
    [self stop];
    [self.navigationController pushViewController:gameView animated:YES];
    [gameView release];
}

- (IBAction) buttonPressed:(UIButton *)sender
{
    switch(sender.tag) {
        case NEW_GAME_BUTTON:
            [self newGame];
            break;
        default:
            NSLog(@"Invalid button tag.");
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) start
{
    [self.GVController start];
}

- (void) stop
{
    [self.GVController stop];
}

- (void) pause
{
    [self.GVController stop];
}

- (void) unpause
{
    [self.GVController start];    
}

@end
