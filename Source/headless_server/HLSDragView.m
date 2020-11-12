/*
   HLSDragView - Drag and Drop code for X11 backends.

   Copyright (C) 1998-2010 Free Software Foundation, Inc.

   Created by: Wim Oudshoorn <woudshoo@xs4all.nl>
   Date: Nov 2001

   Written by:  Adam Fedor <fedor@gnu.org>
   Date: Nov 1998
   
   This file is part of the GNU Objective C User Interface Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/

#include <Foundation/NSDebug.h>
#include <Foundation/NSThread.h>
#include <Foundation/NSSet.h>

#include <AppKit/NSApplication.h>
#include <AppKit/NSCursor.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/NSImage.h>
#include <AppKit/NSPasteboard.h>
#include <AppKit/NSView.h>
#include <AppKit/NSWindow.h>

#include "headless_server/HLSServer.h"
#include "headless_server/HLSServerWindow.h"
#include "headless_server/HLSDragView.h"

/* Size of the dragged window */
#define	DWZ	48

#define XDPY  [HLSServer xDisplay]

#define SLIDE_TIME_STEP   .02   /* in seconds */
#define SLIDE_NR_OF_STEPS 20  

#define	DRAGWINDEV [HLSServer _windowWithTag: [_window windowNumber]]
#define	XX(P)	(P.x)
#define	XY(P)	([(HLSServer *)GSCurrentServer() xScreenSize].height - P.y)

@interface HLSRawWindow : NSWindow
@end

@interface NSCursor (BackendPrivate)
- (void *)_cid;
- (void) _setCid: (void *)val;
@end

// The result of this function must be freed by the caller


@implementation HLSDragView

static	HLSDragView	*sharedDragView = nil;

+ (id) sharedDragView
{
  if (sharedDragView == nil)
    {
      GSEnsureDndIsInitialized ();
      sharedDragView = [HLSDragView new];
    }
  return sharedDragView;
}

+ (Class) windowClass
{
  return [HLSRawWindow class];
}

/*
 * External drag operation
 */
// - (void) setupDragInfoFromXEvent: (XEvent *)xEvent
// {
  // Start a dragging session from another application
// }

- (void) updateDragInfoFromEvent: (NSEvent*)event
{
  // Store the drag info, so that we can send status messages as response 
}

- (void) resetDragInfo
{
}

/*
 * Local drag operation
 */

- (void) dragImage: (NSImage*)anImage
		at: (NSPoint)screenLocation
	    offset: (NSSize)initialOffset
	     event: (NSEvent*)event
	pasteboard: (NSPasteboard*)pboard
	    source: (id)sourceObject
	 slideBack: (BOOL)slideFlag
{
}

- (void) postDragEvent: (NSEvent *)theEvent
{
}

- (void) sendExternalEvent: (GSAppKitSubtype)subtype
                    action: (NSDragOperation)action
                  position: (NSPoint)eventLocation
                 timestamp: (NSTimeInterval)time
                  toWindow: (int)dWindowNumber
{
}


- (NSWindow*) windowAcceptingDnDunder: (NSPoint)p
			    windowRef: (int*)mouseWindowRef
{
      return nil;
}
            



@end


@interface HLSServer (DragAndDrop)
- (void) _resetDragTypesForWindow: (NSWindow *)win;
@end


@implementation HLSServer (DragAndDrop)

- (void) _resetDragTypesForWindow: (NSWindow *)win
{
}

- (BOOL) addDragTypes: (NSArray*)types toWindow: (NSWindow *)win
{
	return YES;
}

- (BOOL) removeDragTypes: (NSArray*)types fromWindow: (NSWindow *)win
{
	return YES;
}

@end




@implementation HLSRawWindow

- (BOOL) canBecomeMainWindow
{
  return NO;
}

- (BOOL) canBecomeKeyWindow
{
  return NO;
}

- (void) _initDefaults
{
  [super _initDefaults];
  [self setReleasedWhenClosed: NO];
  [self setExcludedFromWindowsMenu: YES];
}

- (void) orderWindow: (NSWindowOrderingMode)place relativeTo: (NSInteger)otherWin
{
}

@end
