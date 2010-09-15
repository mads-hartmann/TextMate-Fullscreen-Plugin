#import "Fullscreen.h"
#import "TextMate.h"
#import "JRSwizzle.h"

@implementation Fullscreen

@synthesize lastWindowController;

static Fullscreen *sharedInstance = nil;

+ (Fullscreen*)instance
{
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init];
		}
	}
	return sharedInstance;
}

- (id)initWithPlugInController:(id <TMPlugInController>)aController
{
	NSApp = [NSApplication sharedApplication];
	if(self = [super init]) {
		
		[self installMenuItem];
		
		[OakWindow jr_swizzleMethod:@selector(becomeMainWindow) withMethod:@selector(Fullscreen_becomeMainWindow) error:NULL];
		[OakWindow jr_swizzleMethod:@selector(close) withMethod:@selector(Fullscreen_close) error:NULL];
	}
	
	iVars = [[NSMutableDictionary alloc] init];
	sharedInstance = self;
	
	return self;
	
}

- (void)dealloc
{
	[self uninstallMenuItem];
	[iVars release];
	[super dealloc];
}

- (void)installMenuItem
{
	if(windowMenu = [[[[NSApp mainMenu] itemWithTitle:@"Window"] submenu] retain])
	{
		unsigned index = 0;
		NSArray* items = [windowMenu itemArray];
		for(int separators = 0; index != [items count] && separators != 2; index++)
			separators += [[items objectAtIndex:index] isSeparatorItem] ? 1 : 0;

		toggleFullscreen = [[NSMenuItem alloc] initWithTitle:@"Fullscreen" 
													   action:@selector(toggleFullscreen:) 
												keyEquivalent:@""];
		
		[toggleFullscreen setKeyEquivalent:@"f"];
		[toggleFullscreen setKeyEquivalentModifierMask:NSCommandKeyMask|NSControlKeyMask|NSAlternateKeyMask];
		[toggleFullscreen setTarget:self];
		[windowMenu insertItem:toggleFullscreen atIndex:index ? index-1 : 0];
	}
}

- (void)setLastWindowController:(NSWindowController *)windowController
{
//	if (lastWindowController != nil) {
//		[lastWindowController release];
//	}
	lastWindowController = windowController;
	if ([self noFullsizeWindows])
		[NSMenu setMenuBarVisible:YES];
	
}

- (NSMutableDictionary*)getIVarsFor:(id)sender
{
	if (iVars == nil)
		return nil;
	id x = [iVars objectForKey:[NSNumber numberWithInt:[sender hash]]];
	if (x == nil) {
		NSMutableDictionary* iVarHolder = [NSMutableDictionary dictionaryWithCapacity:2];
		[iVars setObject:iVarHolder forKey:[NSNumber numberWithInt:[sender hash]]];
		return iVarHolder;
	}
	return (NSMutableDictionary*)x;
}

- (void)removeIvarFor:(id)sender
{
	[iVars removeObjectForKey:[NSNumber numberWithInt:[sender hash]]];
}

- (void)uninstallMenuItem
{
	[windowMenu removeItem:toggleFullscreen];

	[toggleFullscreen release];
	toggleFullscreen = nil;

	[windowMenu release];
	windowMenu = nil;
}

/*	This code is pretty much copied from 
	http://cocoawithlove.com/2009/08/animating-window-to-fullscreen-on-mac.html
*/
- (void)toggleFullscreen:(id)sender
{
	
	NSWindow *mainWindow = [lastWindowController window];
	NSMutableDictionary *controllerIVars = [self getIVarsFor:lastWindowController];
	[mainWindow retain];
		
	NSNumber *fullscreen = [controllerIVars objectForKey:@"fullscreen"];
	NSRect oldSize = [[controllerIVars objectForKey:@"oldSize"] rectValue];
	
	NSLog(@"%i",fullscreen);
	
	if ([fullscreen intValue] == 1)
	{
		NSRect newFrame = [mainWindow frame];
		newFrame.size.height = newFrame.size.height - 20;
		
		[mainWindow setFrame:oldSize display:YES animate:YES];

		[controllerIVars setObject:[NSNumber numberWithBool:false] forKey:@"fullscreen"];
		
		if ([self noFullsizeWindows])
			[NSMenu setMenuBarVisible:YES];
	}
	else {
		[controllerIVars setObject:[NSNumber numberWithBool:true] forKey:@"fullscreen"];
		[controllerIVars setObject:[NSValue valueWithRect:[mainWindow frame]] forKey:@"oldSize"];
		
		[NSMenu setMenuBarVisible:NO];
		
		[mainWindow setFrame:[mainWindow frameRectForContentRect:[[mainWindow screen] frame]]
					 display:YES
					 animate:YES];	
	}
	
	[mainWindow release];
}

- (BOOL)noFullsizeWindows
{
	BOOL b = YES;
	for (NSString *key in [iVars allKeys]) {
		NSMutableDictionary *ciVars = [iVars objectForKey:key];
		NSNumber *fullscreen = [ciVars objectForKey:@"fullscreen"];
		NSLog(@"loop");	
		if ([fullscreen intValue] == 1)
			b = NO;
	}
	return b;
}

@end
