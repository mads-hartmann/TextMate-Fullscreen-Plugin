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
	
	// hacky way to provide the controllers 
	// with instance variables.
	NSMutableDictionary* iVars;
}

@property(retain) NSWindowController* lastWindowController;

+ (Fullscreen*)instance;

- (id)initWithPlugInController:(id <TMPlugInController>)aController;
- (void)dealloc;
- (void)installMenuItem;
- (void)uninstallMenuItem;
- (void)toggleFullscreen:(id)sender;
- (BOOL)noFullsizeWindows;
- (void)removeIvarFor:(id)sender;
- (NSMutableDictionary*)getIVarsFor:(id)sender;

@end
