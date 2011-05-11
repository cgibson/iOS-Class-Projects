//
//  OpenGLView.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenGLView.h"


#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLUT/glut.h>

@implementation DSOpenGLView

- (id)initWithFrame:(NSRect)frame {
	NSOpenGLPixelFormatAttribute attrs[] = {
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 32,
		0
	};
	
    NSOpenGLPixelFormat * format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	
	self = [super initWithFrame:frame];
    if (self) {
        m_context = [[NSOpenGLContext alloc] initWithFormat:format shareContext:nil];
	}
    return self;
}

- (void)dealloc {
	[m_context release];
}

- (void)drawRect:(NSRect)rect {
	[m_context clearDrawable];
	[m_context setView:self];
	
    [m_context makeCurrentContext];
	
	glClearColor(0,0,0,0);  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
    glViewport( 0,0,[self frame].size.width,[self frame].size.height );  
    glMatrixMode(GL_PROJECTION);   glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);    glLoadIdentity();
    
	[self draw];
	
	[m_context flushBuffer];
	[NSOpenGLContext clearCurrentContext];
}

- (void)draw {
	glMatrixMode(GL_PROJECTION);
	gluPerspective(25,[self frame].size.width / [self frame].size.height,1,100);
	glTranslatef(0,0,-10);
    
	glColor3f(1,1,1);
	glutWireTeapot(1);
}

@end