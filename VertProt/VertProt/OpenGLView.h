//
//  OpenGLView.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Cocoa/Cocoa.h>


@interface OpenGLView : NSView {
	NSOpenGLContext * m_context;
}

- (void)draw; // subclasses implement this to do drawing

@end