//
//  GradeData.m
//  GradeBookVI
//
//  Created by Gibson, Christopher on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GradeData.h"
#import "NSString+Base64Encoding.h"
#import "JSONKit.h"

#define SECTION_DEPTH 0
#define ENROLLMENT_DEPTH 1
#define ASSIGNMENT_DEPTH 2
#define SCORE_DEPTH 3
#define MAX_DEPTH 2


@implementation GradeData

@synthesize url=_url;
@synthesize depth=_depth;
@synthesize options=_options;
@synthesize title=_title;
@synthesize auth=_auth;

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
        //[self load];
    }
    
    return self;
}

- (void) loadAuth
{
    // Load username and password
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString* username = [defaults stringForKey:@"username"];
    NSString* password = [defaults stringForKey:@"password"];
    self.url = [defaults stringForKey:@"url"];
    
    self.auth = [self authenticationHeader:username password:password];
}

- (NSString*) getRecordType
{
    switch (self.depth) {
        case SECTION_DEPTH:
            return @"sections";
            break;
        case ENROLLMENT_DEPTH:
            return @"enrollments";
            break;
        case ASSIGNMENT_DEPTH:
            return @"userscores";
            break;
        case SCORE_DEPTH:
            return @"scores";
            break;
        default:
            return @"INVALID";
            break;
    }
}

- (NSString*) getUrlOptions
{
    switch (self.depth) {
        case SECTION_DEPTH:
            return @"";
            break;
        case ENROLLMENT_DEPTH:
            return [NSString stringWithFormat:@"&term=%@&course=%@", self.term, self.course];
            break;
        case ASSIGNMENT_DEPTH:
            return [NSString stringWithFormat:@"&term=%@&course=%@&user=%@", self.term, self.course, self.user];
            break;
        default:
            return @"INVALID";
            break;
    }
}

- (NSString*) generateUrl
{
    return [NSString stringWithFormat:@"%@?record=%@%@", self.url, [self getRecordType], [self getUrlOptions]];
}

- (NSString*) valAtIndex:(NSInteger)index
{
    return [[self.options objectAtIndex:index] objectForKey:@"title"];
}

- (NSString*) detailAtIndex:(NSInteger)index
{
    return [[self.options objectAtIndex:index] objectForKey:@"detail"];
}

- (NSString*) colorAtIndex:(NSInteger)index
{
    return [[self.options objectAtIndex:index] objectForKey:@"color"];
}

- (void) parseSections:(NSArray*)root
{
    //if(self.options != nil)
    //    [self.options release];
    self.options = [[[NSMutableArray alloc] initWithCapacity:[root count]] autorelease];
    for (NSDictionary *dict in root) {
        NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init ];
        [dictOut setValue:[NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"dept"], [dict objectForKey:@"course"]] forKey:@"title"];
        [dictOut setValue:[dict objectForKey:@"title"] forKey:@"detail"];
        [dictOut setValue:[dict objectForKey:@"term"] forKey:@"term"];
        [dictOut setValue:[dict objectForKey:@"course"] forKey:@"course"];
        [dictOut setValue:[dict objectForKey:@"BLACK"] forKey:@"color"];
        [self.options addObject:dictOut];
    }
}

- (void) parseEnrollments:(NSArray*)root
{
    self.options = [[[NSMutableArray alloc] initWithCapacity:[root count]] autorelease];
    for (NSDictionary *dict in root) {
        NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init ];
        [dictOut setValue:[NSString stringWithFormat:@"%@, %@", [dict objectForKey:@"last_name"], [dict objectForKey:@"first_name"]] forKey:@"title"];
        [dictOut setValue:[dict objectForKey:@"username"] forKey:@"detail"];
        [dictOut setValue:[dict objectForKey:@"username"] forKey:@"user"];
        [dictOut setValue:[dict objectForKey:@"BLACK"] forKey:@"color"];
        [self.options addObject:dictOut];
    }
}

- (void) parseAssignments:(NSArray*)root
{
    self.options = [[[NSMutableArray alloc] initWithCapacity:[root count]] autorelease];
    for (NSDictionary *dict in root) {
        NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init ];
        [dictOut setValue:[dict objectForKey:@"name"] forKey:@"title"];
        
        NSArray *scores = [dict objectForKey:@"scores"];
        NSDictionary *score = [scores objectAtIndex:0];
        
        int scoreInt = [[score objectForKey:@"score"] intValue];
        if(scoreInt == 0)
            [dictOut setValue:@"RED" forKey:@"color"];
        else if(scoreInt < 0)
            [dictOut setValue:@"GRAY" forKey:@"color"];
        
        //scoreInt = (scoreInt > 0) ? scoreInt : 0;
        
        [dictOut setValue:[NSString stringWithFormat:@"%d/%@", scoreInt, [dict objectForKey:@"max_points"]] forKey:@"detail"];
        [self.options addObject:dictOut];
    }
}

- (void) parseJSON:(NSData*)data
{
    //self.options = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    JSONDecoder *decoder = [JSONDecoder decoder];

    if(data == nil)
        NSLog(@"ERROR: data nil!");
    NSError *JSONError = nil;
    NSDictionary *root = [decoder objectWithData:data error:&JSONError];
    if(root == nil)
        NSLog(@"Empty root");
    if(JSONError != nil)
        NSLog(@"ERROR OMG: %@", [JSONError description]);
    

    switch (self.depth) {
        case SECTION_DEPTH:
            [self parseSections:[root objectForKey:@"sections"]];
            break;
        case ENROLLMENT_DEPTH:
            [self parseEnrollments:[root objectForKey:@"enrollments"]];
            break;
        case ASSIGNMENT_DEPTH:
            [self parseAssignments:[root objectForKey:@"userscores"]];
        default:
            break;
    }
 
}

- (void) sendAndParse:(NSString*)requestUrl
{
    
    NSURL *finalUrl= [NSURL URLWithString:requestUrl];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:finalUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1000];
    
    [req addValue:self.auth forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    if(response == nil)
    {
        NSLog(@"Response is nil");
        if(error != nil)
        {
            NSLog(@"Error: %@", [error description]);
        }
    }
    
    //if(response != nil)
    //    [response release];
    //if(error != nil)
    //    [error release];
    
    [self parseJSON:data];
}

- (void) load
{
    switch (self.depth) {
        case SECTION_DEPTH:
            self.title = @"Sections";
            break;
        case ENROLLMENT_DEPTH:
            self.title = @"Students";
            break;
        case ASSIGNMENT_DEPTH:
            self.title = @"Assignments";
            break;
        default:
            self.title = @"Sections";
            break;
    }
    if([self.url isEqualToString:@"[INVALID]"])
    {
        self.url = @"root";
        self.depth = 0;
    }
    
    if(self.auth == nil)
    {
        [self loadAuth];
    }
    
    NSString *genUrl = [self generateUrl];
    
    NSLog(@"Generated URL: %@", genUrl);
    
    [self sendAndParse:genUrl];
    
    //[genUrl release];

}

- (NSString*) authenticationHeader: (NSString*)username password:(NSString*)password
{
    NSString *loginString = [NSString stringWithFormat:@"%@:%@", username, password];

    return [NSString stringWithFormat:@"Basic %@", [loginString base64Encode]];
}

//BBWAAAAAAAAAMMMM..dun dun dun dun... BBWWAAAAAAAAAAAAMMM!!!!!
- (BOOL) canGoDeeper
{
    return self.depth < MAX_DEPTH;
}

- (void) dealloc
{
    for (NSMutableDictionary *dic in _options) {
        [dic release];
    }
    NSLog(@"Dealloc'ing grade data");
    [_auth release];
    [_term release];
    [_course release];
    [_user release];
    [_options release];
    [_url release];
    [_title release];
    [super dealloc];
}

@end
