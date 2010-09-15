//
//  NSWindowController+Fullscreen.m
//  Fullscreen
//
//  Created by Mads Hartmann Jensen on 9/13/10.
//  Copyright 2010 Sideways Coding. All rights reserved.
//

#import "NSWindow+Fullscreen.h"
#import "Fullscreen.h"

@implementation NSWindow (NSWindowFullscreen) 

- (void)Fullscreen_becomeMainWindow
{
	[self Fullscreen_becomeMainWindow];
	NSWindowController* controller = [self windowController];
	[[Fullscreen instance] setLastWindowController:controller];
}

- (void)Fullscreen_close
{
	[[Fullscreen instance] removeIvarFor:[self windowController]];
	[[Fullscreen instance] setLastWindowController:nil];
	[self Fullscreen_close];
}


@end
