/* <title>HLServer</title>

   <abstract>Backend server using the X11.</abstract>

   Copyright (C) 2002-2015 Free Software Foundation, Inc.

   Author: Adam Fedor <fedor@gnu.org>
   Date: Mar 2002
   
   This file is part of the GNUstep Backend.

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

#ifndef _HLServer_h_INCLUDE
#define _HLServer_h_INCLUDE

#include "config.h"
#include <GNUstepGUI/GSDisplayServer.h>


/*
 * Enumerated type to say how we should draw pixels to the X display - used
 * to select different drawing mechanisms to try to optimise.
 */
typedef enum {
  HLDM_FAST15,
  HLDM_FAST16,
  HLDM_FAST32,
  HLDM_FAST32_BGR,
  HLDM_FAST8,
  HLDM_PORTABLE
} HLDrawMechanism;

typedef struct MonitorDevice {
  int screen_id;
  NSWindowDepth depth;
  NSSize resolution;
  NSRect frame;
} MonitorDevice;

@interface HLServer : GSDisplayServer
{
  // // Display           *dpy;
  // int               defScreen;
  // NSSize            xScreenSize;
  // NSMapTable        *screenList;
  // // Window	    grabWindow;
  // struct HLGeneric  generic;
  // id                inputServer;
  // int               randrEventBase;
  // int               randrErrorBase;
  // // MonitorDevice     *monitors;
  // unsigned          monitorsCount;
}

// + (Display *) xDisplay;
// - (Display *) xDisplay;
// - (Window) xDisplayRootWindow;
// - (Window) xAppRootWindow;
// - (NSSize) xScreenSize;
// 
// - (void *) screenRContext;
// - (Visual *) screenVisual;
// - (int) screenDepth;
// - (HLDrawMechanism) screenDrawMechanism;
// 
// - (void)
//     getForScreen: (int)screen_number
//     pixelFormat: (int *)bpp_number
//     masks: (int *)red_mask
//     : (int *)green_mask
//     : (int *)blue_mask;
//     
// // - (XColor) xColorFromColor: (XColor)color;
// 
// + (void) waitAllContexts;
@end

/*
 * Synchronize with X event queue - soak up events.
 * Waits for up to 1 second for event.
 */
@interface HLServer (XSync)
- (BOOL) xSyncMap: (void*)window;
@end

@interface HLServer (HLGeneric)

- (NSRect)
    _OSFrameToXFrame: (NSRect)o
    for: (void*)window;
- (NSRect)
    _OSFrameToXHints: (NSRect)o
    for: (void*)window;
    
- (NSRect)
    _XFrameToOSFrame: (NSRect)x
    for: (void*)window;
    
- (NSRect)
    _XFrameToXHints: (NSRect)o
    for: (void*)window;

- (NSString *) windowManagerName;
@end

// Public interface for the input methods.  
@interface HLServer (InputMethod)
- (NSString *) inputMethodStyle;
- (NSString *) fontSize: (int *)size;
- (BOOL) clientWindowRect: (NSRect *)rect;

- (BOOL) statusArea: (NSRect *)rect;
- (BOOL) preeditArea: (NSRect *)rect;
- (BOOL) preeditSpot: (NSPoint *)p;

- (BOOL) setStatusArea: (NSRect *)rect;
- (BOOL) setPreeditArea: (NSRect *)rect;
- (BOOL) setPreeditSpot: (NSPoint *)p;
@end

/*
@interface HLServer (TimeKeeping)
- (void) setLastTime: (Time)last;
- (Time) lastTime;
@end
*/

#endif /* _HLServer_h_INCLUDE */
