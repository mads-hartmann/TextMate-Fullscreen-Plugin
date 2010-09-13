#import "Fullscreen.h"
#import "FullscreenWindow.h"
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
	
	fullscreen = false;
	
	sharedInstance = self;
	
	return self;
	
}

- (void)dealloc
{
	[self uninstallMenuItem];
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
		
		[toggleFullscreen setKeyEquivalent:@"."];
		[toggleFullscreen setKeyEquivalentModifierMask:NSCommandKeyMask|NSControlKeyMask|NSAlternateKeyMask];
		[toggleFullscreen setTarget:self];
		[windowMenu insertItem:toggleFullscreen atIndex:index ? index-1 : 0];
	}
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
	[mainWindow retain];
	
	if (fullscreen)
	{
		NSRect newFrame = [mainWindow frame];
		newFrame.size.height = newFrame.size.height - 20;
		
		[mainWindow setFrame:newFrame display:YES animate:YES];

		[NSMenu setMenuBarVisible:YES];
		
		fullscreen = false;
	}
	else {
		fullscreen = true;
		
		[NSMenu setMenuBarVisible:NO];
		
		[mainWindow setFrame:[mainWindow frameRectForContentRect:[[mainWindow screen] frame]]
					 display:YES
					 animate:YES];	
	}
	
	[mainWindow release];
	
}

@end
