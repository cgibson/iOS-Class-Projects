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
@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSArray *optionUrls;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger depth;

@property (nonatomic) NSInteger term;
@property (nonatomic) NSInteger course;
@property (nonatomic) NSInteger user;

- (void) load; 
- (BOOL) canGoDeeper;
- (NSString*) urlFromIndex:(NSInteger)index;

@end
