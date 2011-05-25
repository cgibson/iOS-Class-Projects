//
//  GradeData.h
//  GradeBookVI
//
//  Created by Gibson, Christopher on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GradeData : NSObject {
    
}

@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger depth;
@property (nonatomic, copy) NSString *auth;

@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *user;

- (void) load; 
- (BOOL) canGoDeeper;
//- (NSString*) urlFromIndex:(NSInteger)index;
- (NSString*) authenticationHeader: (NSString*)username password:(NSString*)password;
- (NSString*) valAtIndex:(NSInteger)index;
- (NSString*) detailAtIndex:(NSInteger)index;
- (NSString*) colorAtIndex:(NSInteger)index;

@end
