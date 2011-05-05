//
//  UglyTetrisViewController.m
//  UglyTetris
//
//  Created by Gibson, Christopher on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UglyTetrisViewController.h"

@implementation UglyTetrisViewController

@synthesize engine = engine_;
@synthesize newGridLabels = newGridLabels_;

- (void)dealloc
{
    [self.newGridLabels release];
    
    [engine_ removeObserver:self forKeyPath:@"score"];
    [engine_ removeObserver:self forKeyPath:@"timeStep"];
    [engine_ removeObserver:self forKeyPath:@"gridVersion"];
    [engine_ release];
    [super dealloc];
}

- (void)setupLabels
{
    if (![self isViewLoaded] || !self.engine || self.newGridLabels )
        return;
    
    self.newGridLabels = [NSMutableArray arrayWithCapacity:TetrisArrSize(self.engine.height)];
    for(int i = 0; i < TetrisArrSize(self.engine.height); i++) {
        [self.newGridLabels addObject: [UILabel alloc]];
    }
    
    for (int column = 0; column < [self.engine width]; column++) {
        for (int row = 0; row < self.engine.height; row++) {
            CGRect frame;
            frame.size.width = 16;
            frame.size.height = 26;
            frame.origin.x = 130 + frame.size.width * column;
            frame.origin.y = 300 - frame.size.height * row;
            
            //gridLabels[TetrisArrIdx(row, column)] =
            // [[UILabel alloc] initWithFrame:frame];
            //[self.view addSubview:
            //        gridLabels[TetrisArrIdx(row, column)]];
            UILabel *label = [self.newGridLabels objectAtIndex:TetrisArrIdx(row, column)];
            [label initWithFrame:frame];
            [self.newGridLabels replaceObjectAtIndex:TetrisArrIdx(row, column) 
                                           withObject:label];
            
            [self.view addSubview: label];

        }
    }
    [self.engine addObserver:self forKeyPath:@"score"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    
    [self.engine addObserver:self forKeyPath:@"gridVersion"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    
    [self.engine addObserver:self forKeyPath:@"timeStep"
                     options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                     context:nil];
    [self refreshView];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabels];
    [self refreshView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.newGridLabels release];
    [timeLabel release];
    [scoreLabel release];
    
    
    [engine_ removeObserver:self forKeyPath:@"score"];
    [engine_ removeObserver:self forKeyPath:@"timeStep"];
    [engine_ removeObserver:self forKeyPath:@"gridVersion"];
    [engine_ release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) buttonPressed:(UIButton*)sender
{
    if(sender.tag == 1) {
        [self.engine start];
    }else if(sender.tag == 2) {
        if ([self.engine running]) {
            [self.engine slideLeft];
            [self refreshView];
        }
    }else if(sender.tag == 3) {
        if ([self.engine running]) {
            [self.engine slideRight];
            [self refreshView];
        }
        }else if(sender.tag == 4) {
        if ([self.engine running]) {
            [self.engine rotateCW];
            [self refreshView];
        }
        }else if(sender.tag == 5) {
        if ([self.engine running]) {
            [self.engine rotateCCW];
            [self refreshView];
        }
    }else if(sender.tag == 6) {
        [self.engine stop];
        [self refreshView];
    }else if(sender.tag == 7) {
        [self.engine stop];
        [self.engine reset];
        [self refreshView];
    }else if(sender.tag == 8) {
        [self.engine pieceUp];
    }else if(sender.tag == 9) {
        [self.engine pieceDown];
    }
}

//- (TetrisEngine*)engine {
//    return engine_;
//}

- (void)setEngine:(TetrisEngine *)eng
{ 
    [engine_ removeObserver:self forKeyPath:@"score"];
    [engine_ removeObserver:self forKeyPath:@"timeStep"];
    [engine_ removeObserver:self forKeyPath:@"gridVersion"];
    [engine_ release];
    [self loadView];
    engine_ = eng;
    [self setupLabels];

    [self refreshView];
}

- (void) refreshView
{
    if (!self.engine || !self.newGridLabels)
        return;

}

- (void) refreshGrid
{
    for (int column = 0; column < [self.engine width]; column++) {
        for (int row = 0; row < self.engine.height; row++) {
            int piece = [self.engine pieceAtRow:row column:column];
            if (0 == piece)
                [[self.newGridLabels objectAtIndex:TetrisArrIdx(row, column)] setText:@"."];
            else
                [[self.newGridLabels objectAtIndex:TetrisArrIdx(row, column)] setText:@"X"];
        }
    }
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
