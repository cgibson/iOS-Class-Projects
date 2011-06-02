//
//  Running.h
//  Colony
//
//  Created by Gibson, Christopher on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Running <NSObject>

- (void) start;
- (void) stop;
- (void) pause;
- (void) unpause;
@end
