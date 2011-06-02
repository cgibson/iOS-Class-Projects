//
//  GameState.h
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameState : NSObject {
    
}

@property (readonly) bool running;

- (NSDictionary*) toDict;
- (id) initWithDict:(NSDictionary*)dict;
- (void) newGame;
@end
