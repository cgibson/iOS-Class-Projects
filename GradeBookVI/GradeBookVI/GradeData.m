//
//  GradeData.m
//  GradeBookVI
//
//  Created by Gibson, Christopher on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GradeData.h"

#define SECTION_DEPTH 0
#define ENROLLMENT_DEPTH 1
#define ASSIGNMENT_DEPTH 2
#define SCORE_DEPTH 3
#define MAX_DEPTH 3


@implementation GradeData

@synthesize url=_url;
@synthesize depth=_depth;
@synthesize options=_options;
@synthesize optionUrls=_optionUrls;
@synthesize title=_title;

@synthesize term=_term;
@synthesize course=_course;
@synthesize user=_user;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.url = @"[INVALID]";
        self.depth = -1;
        NSLog(@"Loaded with url=\"%@\"", self.url );
        //[self load];
    }
    
    return self;
}

- (void) load
{
    if([self.url isEqualToString:@"[INVALID]"])
    {
        self.url = @"root";
        self.depth = 0;
    }
    NSLog(@"depth: %d", self.depth);
    
    [self.options release];
    [self.optionUrls release];
    if(self.depth == SECTION_DEPTH)
    {
        self.options = [NSArray arrayWithObjects:@"Section 1",@"Section 2",@"Section 3", nil];
        self.optionUrls = [NSArray arrayWithObjects:@"term=2108&course=1",@"term=2108&course=2",@"term=2108&course=3", nil];
    } else if(self.depth == ENROLLMENT_DEPTH)
    {
        self.options = [NSArray arrayWithObjects:@"Enrollment 1",@"Enrollment 2",@"Enrollment 3", nil];
        self.optionUrls = [NSArray arrayWithObjects:@"term=2108&course=1",@"term=2108&course=2",@"term=2108&course=3", nil];
    } else if(self.depth == ASSIGNMENT_DEPTH)
    {
        self.options = [NSArray arrayWithObjects:@"Assignment 1",@"Assignment 2",@"Assignment 3", nil];
        self.optionUrls = [NSArray arrayWithObjects:@"term=2108&course=1",@"term=2108&course=2",@"term=2108&course=3", nil];
    } else if(self.depth == SCORE_DEPTH)
    {
        self.options = [NSArray arrayWithObjects:@"Score 1",@"Score 2",@"Score 3", nil];
    }
}

- (NSString*) urlFromIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%@/%@", self.url, [self.optionUrls objectAtIndex:index]];
}

//BBWAAAAAAAAAMMMM..dun dun dun dun... BBWWAAAAAAAAAAAAMMM!!!!!
- (BOOL) canGoDeeper
{
    return self.depth < MAX_DEPTH;
}

- (void) dealloc
{
    NSLog(@"Dealloc'ing grade data");
    [_options release];
    [_optionUrls release];
    [_url release];
    [_title release];
    [super dealloc];
}

@end
