//
//  Clock.h
//  Clock
//
//  Created by Allan Odgaard on 2005-10-29.
//  Copyright 2005 MacroMates. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TMPlugInController
- (float)version;
@end

@interface Fullscreen : NSObject
{
	NSWindowController* lastWindowController;
	NSMenu* windowMenu;
	NSMenuItem* toggleFullscreen;
	BOOL fullscreen;
	NSRect oldSize;
}

@property(retain) NSWindowController* lastWindowController;

+ (Fullscreen*)instance;

- (id)initWithPlugInController:(id <TMPlugInController>)aController;
- (void)dealloc;
- (void)installMenuItem;
- (void)uninstallMenuItem;
- (void)toggleFullscreen:(id)sender;

@end
