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

@implementation FirstViewController

@synthesize world = world_;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!self.world)
        self.world = [[[World alloc] initWithRect:self.view.bounds] autorelease];
    
    Shape *subView;
    Entity *obj;
    
    // Main Cell
    CGRect frame1 = { 150, 150, 50, 50};
    obj = [[Entity alloc] initWithType:1 location:frame1];
    [self.world addObject:obj];
    subView = [[CellView alloc] initWithFrame:frame1];
    subView.opaque = NO;
    subView.tag = obj.objId;
    subView.target = self;
    [self.view addSubview:subView];
    [subView release];
    
    
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


- (void)dealloc
{
    [world_ release];
    [super dealloc];
}

@end
