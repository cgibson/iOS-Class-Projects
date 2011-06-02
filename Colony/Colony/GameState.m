//
//  GameState.m
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@interface GameState()

@property bool running;

@end


@implementation GameState


@synthesize running=_running;

- (NSDictionary*) toDict
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: 
                         [[NSNumber alloc] initWithBool:self.running], @"running", 
                         nil];
    
    return dict;
    
}

- (void) newGame
{
    self.running = true;
}

- (void) useDefaults
{
    NSLog(@"Using defaults...");
    self.running = false;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    NSLog(@"Initializing state");
    
    if(self) {
        if(dict) {
            NSLog(@"Initializing with dictionary");
            self.running = [[dict objectForKey:@"running"] boolValue];
        }else{
            [self useDefaults];
        }
    }
    
    return self;
}

- (void) dealloc
{
    
    NSLog(@"GameState dealloc'd");
    [super dealloc];
}
@end
