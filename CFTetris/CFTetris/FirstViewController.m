//
//  FirstViewController.m
//  CFTetris
//
//  Created by Gibson, Christopher on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize engine = engine_;

/**/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [tetrisView initWithRows:self.engine.height columns:10];
    [self.view addSubview:tetrisView];
    [tetrisView release];

}
/**/

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

- (void) setupGrid
{
    
    [self.engine addObserver:self forKeyPath:@"score"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    
    [self.engine addObserver:self forKeyPath:@"gridVersion"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    
    [self.engine addObserver:self forKeyPath:@"timeStep"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    tetrisView.rows = [self.engine height];
    tetrisView.columns = [self.engine width];
}

- (void) refreshGrid
{
    for(int i = 0; i < tetrisView.rows; i++)
    {
        for(int j = 0; j < tetrisView.columns; j++)
        {
            [tetrisView setColor:[UIColor colorWithRed:0.0 green:0.1 blue:0.0 alpha:0.0] 
                          forRow:i 
                          column:j];
        }
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)setEngine:(TetrisEngine *)eng
{ 
    NSLog(@"Setting engine");
    [engine_ removeObserver:self forKeyPath:@"score"];
    [engine_ removeObserver:self forKeyPath:@"timeStep"];
    [engine_ removeObserver:self forKeyPath:@"gridVersion"];
    [engine_ release];
    [self loadView];
    engine_ = eng;
    [self setupGrid];
    
    //[self refreshView];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"score"]) {
        scoreLabel.text = [NSString stringWithFormat:@"%d", self.engine.score];
    }else if ([keyPath isEqualToString:@"timeStep"]) {
        timeLabel.text = [NSString stringWithFormat:@"%d", self.engine.timeStep];
    }else if ([keyPath isEqualToString:@"gridVersion"]) {
        [self refreshGrid];
        
    }else{
        
    }
}

@end
