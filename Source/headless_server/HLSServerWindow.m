/* HLSServerWindows - methods for window/screen handling

   Copyright (C) 1999-2020 Free Software Foundation, Inc.

   Written by:  Adam Fedor <fedor@gnu.org>
   Date: Nov 1999

   This file is part of GNUstep

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

#include "config.h"
#include <math.h>
#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSValue.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSUserDefaults.h>
#include <Foundation/NSAutoreleasePool.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSException.h>
#include <Foundation/NSThread.h>
#include <AppKit/DPSOperators.h>
#include <AppKit/NSApplication.h>
#include <AppKit/NSCursor.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/NSWindow.h>
#include <AppKit/NSImage.h>
#include <AppKit/NSBitmapImageRep.h>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif


#include "headless_server/HLSDragView.h"
#include "headless_server/HLSInputServer.h"

#define	ROOT generic.appRootWindow


static BOOL handlesWindowDecorations = YES;

#define WINDOW_WITH_TAG(windowNumber) (gswindow_device_t *)NSMapGet(windowtags, (void *)(uintptr_t)windowNumber)

/* Current mouse grab window */
static gswindow_device_t *grab_window = NULL;

/* Keep track of windows */
static NSMapTable *windowmaps = NULL;
static NSMapTable *windowtags = NULL;

/* Track used window numbers */
static int		last_win_num = 0;

@interface NSCursor (BackendPrivate)
- (void *)_cid;
@end

@interface NSBitmapImageRep (GSPrivate)
- (NSBitmapImageRep *) _convertToFormatBitsPerSample: (NSInteger)bps
                                     samplesPerPixel: (NSInteger)spp
                                            hasAlpha: (BOOL)alpha
                                            isPlanar: (BOOL)isPlanar
                                      colorSpaceName: (NSString*)colorSpaceName
                                        bitmapFormat: (NSBitmapFormat)bitmapFormat
                                         bytesPerRow: (NSInteger)rowBytes
                                        bitsPerPixel: (NSInteger)pixelBits;
@end

static NSBitmapImageRep *getStandardBitmap(NSImage *image)
{
  NSBitmapImageRep *rep;

  if (image == nil)
    {
      return nil;
    }

/*
  We should rather convert the image to a bitmap representation here via
  the following code, but this is currently not supported by the libart backend

{
  NSSize size = [image size];

  [image lockFocus];
  rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:
            NSMakeRect(0, 0, size.width, size.height)];
  AUTORELEASE(rep);
  [image unlockFocus];
}
*/

  rep = (NSBitmapImageRep *)[image bestRepresentationForDevice: nil];
  if (!rep || ![rep respondsToSelector: @selector(samplesPerPixel)])
    {
      return nil;
    }
  else
    {
      // Convert into something usable by the backend
      return [rep _convertToFormatBitsPerSample: 8
                                samplesPerPixel: [rep hasAlpha] ? 4 : 3
                                       hasAlpha: [rep hasAlpha]
                                       isPlanar: NO
                                 colorSpaceName: NSCalibratedRGBColorSpace
                                   bitmapFormat: [rep bitmapFormat]
                                    bytesPerRow: 0
                                   bitsPerPixel: 0];
    }
}


void __objc_xgcontextwindow_linking (void)
{
}

/*
 * The next two functions derived from WindowMaker by Alfredo K. Kojima
 */

/*
 * Setting Motif Hints for Window Managers (Nicola Pero, July 2000)
 */

/*
 * Motif window hints to communicate to a window manager
 * that we want a window to have a titlebar/resize button/etc.
 */

/* Motif window hints struct */
typedef struct {
  unsigned long flags;
  unsigned long functions;
  unsigned long decorations;
  unsigned long input_mode;
  unsigned long status;
} MwmHints;

/* Number of entries in the struct */
#define PROP_MWM_HINTS_ELEMENTS 5

/* Now for each field in the struct, meaningful stuff to put in: */

/* flags */
#define MWM_HINTS_FUNCTIONS   (1L << 0)
#define MWM_HINTS_DECORATIONS (1L << 1)
#define MWM_HINTS_INPUT_MODE  (1L << 2)
#define MWM_HINTS_STATUS      (1L << 3)

/* functions */
#define MWM_FUNC_ALL          (1L << 0)
#define MWM_FUNC_RESIZE       (1L << 1)
#define MWM_FUNC_MOVE         (1L << 2)
#define MWM_FUNC_MINIMIZE     (1L << 3)
#define MWM_FUNC_MAXIMIZE     (1L << 4)
#define MWM_FUNC_CLOSE        (1L << 5)

/* decorations */
#define MWM_DECOR_ALL         (1L << 0)
#define MWM_DECOR_BORDER      (1L << 1)
#define MWM_DECOR_RESIZEH     (1L << 2)
#define MWM_DECOR_TITLE       (1L << 3)
#define MWM_DECOR_MENU        (1L << 4)
#define MWM_DECOR_MINIMIZE    (1L << 5)
#define MWM_DECOR_MAXIMIZE    (1L << 6)



/* Now the code */

/* Set the style `styleMask' for the XWindow `window' using motif
 * window hints.  This makes an X call, please make sure you do it
 * only once.
 */

/*
 * End of motif hints for window manager code
 */

@interface HLSServer (WindowOps)
@end

@implementation HLSServer (WindowOps)

- (BOOL) handlesWindowDecorations
{
  return handlesWindowDecorations;
}



+ (gswindow_device_t *) _windowWithTag: (int)windowNumber
{
  return WINDOW_WITH_TAG(windowNumber);
}

/*
 * Convert a window frame in OpenStep absolute screen coordinates to
 * a frame in X absolute screen coordinates by flipping an applying
 * offsets to allow for the X window decorations.
 * The result is the rectangle of the window we can actually draw
 * to (in the X coordinate system).
 */
- (NSRect) _OSFrameToXFrame: (NSRect)o for: (void*)window
{
  gswindow_device_t	*win = (gswindow_device_t*)window;
  unsigned int		style = win->win_attrs.window_style;
  NSRect	x;
  float	t, b, l, r;

//   [self styleoffsets: &l : &r : &t : &b : style : win->ident];

  x.size.width = o.size.width - l - r;
  x.size.height = o.size.height - t - b;
  x.origin.x = o.origin.x + l;
  x.origin.y = o.origin.y + o.size.height - t;
  x.origin.y = xScreenSize.height - x.origin.y;
  NSDebugLLog(@"Frame", @"O2X %lu, %x, %@, %@", win->number, style,
    NSStringFromRect(o), NSStringFromRect(x));
  return x;
}

/*
 * Convert a window frame in OpenStep absolute screen coordinates to
 * a frame suitable for setting X hints for a window manager.
 * NB. Hints use the coordinates of the parent decoration window,
 * but the size of the actual window.
 */
- (NSRect) _OSFrameToXHints: (NSRect)o for: (void*)window
{
  gswindow_device_t	*win = (gswindow_device_t*)window;
  unsigned int		style = win->win_attrs.window_style;
  NSRect	x;
  float	t, b, l, r;

//   [self styleoffsets: &l : &r : &t : &b : style : win->ident];

  x.size.width = o.size.width - l - r;
  x.size.height = o.size.height - t - b;
  x.origin.x = o.origin.x;
  x.origin.y = o.origin.y + o.size.height;
  x.origin.y = xScreenSize.height - x.origin.y;
  NSDebugLLog(@"Frame", @"O2H %lu, %x, %@, %@", win->number, style,
    NSStringFromRect(o), NSStringFromRect(x));
  return x;
}

/*
 * Convert a rectangle in X  coordinates relative to the X-window
 * to a rectangle in OpenStep coordinates (base coordinates of the NSWindow).
 */
- (NSRect) _XWinRectToOSWinRect: (NSRect)x for: (void*)window
{
  gswindow_device_t	*win = (gswindow_device_t*)window;
  unsigned int		style = win->win_attrs.window_style;
  NSRect	o;
  float	t, b, l, r;

//   [self styleoffsets: &l : &r : &t : &b : style : win->ident];
  o.size.width = x.size.width;
  o.size.height = x.size.height;
  o.origin.x = x.origin.x + l;
  o.origin.y = NSHeight(win->xframe) - (x.origin.y + x.size.height);
  o.origin.y = o.origin.y + b;
  NSDebugLLog(@"Frame", @"XW2OW %@ %@",
    NSStringFromRect(x), NSStringFromRect(o));
  return o;
}

/*
 * Convert a window frame in X absolute screen coordinates to a frame
 * in OpenStep absolute screen coordinates by flipping an applying
 * offsets to allow for the X window decorations.
 */
- (NSRect) _XFrameToOSFrame: (NSRect)x for: (void*)window
{
  gswindow_device_t	*win = (gswindow_device_t*)window;
  unsigned int		style = win->win_attrs.window_style;
  NSRect	o;
  float	t, b, l, r;

//   [self styleoffsets: &l : &r : &t : &b : style : win->ident];
  o = x;
  o.origin.y = xScreenSize.height - x.origin.y;
  o.origin.y = o.origin.y - x.size.height - b;
  o.origin.x -= l;
  o.size.width += l + r;
  o.size.height += t + b;

  NSDebugLLog(@"Frame", @"X2O %lu, %x, %@, %@", win->number, style,
    NSStringFromRect(x), NSStringFromRect(o));
  return o;
}

/*
 * Convert a window frame in X absolute screen coordinates to
 * a frame suitable for setting X hints for a window manager.
 */
- (NSRect) _XFrameToXHints: (NSRect)o for: (void*)window
{
  gswindow_device_t	*win = (gswindow_device_t*)window;
  unsigned int		style = win->win_attrs.window_style;
  NSRect	x;
  float	t, b, l, r;

//  [self styleoffsets: &l : &r : &t : &b : style : win->ident];

  /* WARNING: if we adjust the frame size we get problems,
   * but we do seem to need to adjust the position to allow for
   * decorations.
   */
  x.size.width = o.size.width;
  x.size.height = o.size.height;
  x.origin.x = o.origin.x - l;
  x.origin.y = o.origin.y - t;
  NSDebugLLog(@"Frame", @"X2H %lu, %x, %@, %@", win->number, style,
    NSStringFromRect(o), NSStringFromRect(x));
  return x;
}


/*
 * Check if the window manager supports a feature.
 */
// - (BOOL) _checkWMSupports: (Atom)feature
- (BOOL) _checkWMSupports: (int)feature
{
	return NO;
}


- (BOOL) _tryRequestFrameExtents: (gswindow_device_t *)window
{
  return NO;
}


- (BOOL) _checkStyle: (unsigned)style
{
  return YES;
}

- (NSString *) windowManagerName
{
      return @"HeadlessWindowManager";
}


- (gswindow_device_t *) _rootWindow
{
 /*
  int x, y;
  unsigned int width, height;
  gswindow_device_t *window;

  // Screen number is negative to avoid conflict with windows
  window = WINDOW_WITH_TAG(-defScreen);
  if (window)
    return window;

  window = NSAllocateCollectable(sizeof(gswindow_device_t), NSScannedOption);
  memset(window, '\0', sizeof(gswindow_device_t));

  window->display = dpy;
  window->screen_id = defScreen;
  window->ident  = RootWindow(dpy, defScreen);
  window->root   = window->ident;
  window->type   = NSBackingStoreNonretained;
  window->number = -defScreen;
  window->map_state = IsViewable;
  window->visibility = -1;
  window->wm_state = NormalState;
  window->monitor_id = 0;
  if (window->ident)
    {
      XGetGeometry(dpy, window->ident, &window->root,
                   &x, &y, &width, &height,
                   &window->border, &window->depth);
    }
  else
    {
      NSLog(@"Failed to get root window");
      x = 0;
      y = 0;
      width = 0;
      height = 0;
    }

  window->xframe = NSMakeRect(x, y, width, height);
  NSMapInsert (windowtags, (void*)(uintptr_t)window->number, window);
  NSMapInsert (windowmaps, (void*)(uintptr_t)window->ident,  window);
  return window;
  */
	return NULL;
}

/* Create the window and screen list if necessary, add the root window to
   the window list as window 0 */
- (void) _checkWindowlist
{
}

- (void) _setupMouse
{
}

- (void) _setSupportedWMProtocols: (gswindow_device_t *) window
{
}

- (void) _setupRootWindow
{
}

/* Destroys all the windows and other window resources that belong to
   this context */
- (void) _destroyServerWindows
{
}

/* Sets up a backing pixmap when a window is created or resized.  This is
   only done if the Window is buffered or retained. */
- (void) _createBuffer: (gswindow_device_t *)window
{
}

/*
 * Code to build up a NET WM icon from our application icon
 */

-(BOOL) _createNetIcon: (NSImage*)image
		result: (long**)pixeldata
		  size: (int*)size
{
  return YES;
}


- (int) window: (NSRect)frame : (NSBackingStoreType)type : (unsigned int)style
	      : (int)screen
{
	return 1;
}

- (int)
	nativeWindow: (void *)winref
		    : (NSRect*)frame
		    : (NSBackingStoreType*)type
		    : (unsigned int*)style
		    : (int*)screen
{
	return 1;
}

- (void) termwindow: (int)win
{
}

/*
 * Return the offsets between the window content-view and it's frame
 * depending on the window style.
 */
- (void) styleoffsets: (float *) l : (float *) r : (float *) t : (float *) b
		     : (unsigned int) style
{
}


- (void) stylewindow: (unsigned int)style : (int) win
{
}

- (void) setbackgroundcolor: (NSColor *)color : (int)win
{
}

- (void) windowbacking: (NSBackingStoreType)type : (int) win
{
}

- (void) titlewindow: (NSString *)window_title : (int) win
{
}

- (void) docedited: (int)edited : (int) win
{
}

- (BOOL) appOwnsMiniwindow
{
 return NO;
}

- (void) miniwindow: (int) win
{
}

/* Actually this is "hide application" action.
   However, key press may be received by particular window. */
- (BOOL) hideApplication: (int)win
{
  return YES;
}

/**
   Make sure we have the most up-to-date window information and then
   make sure the context has our new information
*/
- (void) setWindowdevice: (int)win forContext: (NSGraphicsContext *)ctxt
{
}

/*
Build a Pixmap of our icon so the windowmaker dock will remember our
icon when we quit.

ICCCM really only allows 1-bit pixmaps for IconPixmapHint, but this code is
only used if windowmaker is the window manager, and windowmaker can handle
real color pixmaps.
*/
static BOOL didCreatePixmaps;

// Convert RGBA unpacked to ARGB packed.
// Packed ARGB values are layed out as ARGB on big endian systems
// and as BGRA on little endian systems
void
swapColors(unsigned char *image_data, NSBitmapImageRep *rep)
{
}

- (int) _createAppIconPixmaps
{
  return 0;
}

- (void) orderwindow: (int)op : (int)otherWin : (int)winNum
{
}

#define ALPHA_THRESHOLD 158

/* Restrict the displayed part of the window to the given image.
   This only yields usefull results if the window is borderless and
   displays the image itself */
- (void) restrictWindow: (int)win toImage: (NSImage*)image
{
}

/* This method is a fast implementation of move that only works
   correctly for borderless windows. Use with caution. */
- (void) movewindow: (NSPoint)loc : (int)win
{
}

- (void) placewindow: (NSRect)rect : (int)win
{
}

- (BOOL) findwindow: (NSPoint)loc : (int) op : (int) otherWin : (NSPoint *)floc
: (int*) winFound
{
  return NO;
}

- (NSRect) windowbounds: (int)win
{
    return NSZeroRect;
}

- (void) setwindowlevel: (int)level : (int)win
{
}

- (int) windowlevel: (int)win
{
  return 0;
}

- (NSArray *) windowlist
{
	return @[];
}

- (int) windowdepth: (int)win
{
    return 0;
}

- (void) setmaxsize: (NSSize)size : (int)win
{
}

- (void) setminsize: (NSSize)size : (int)win
{
}

- (void) setresizeincrements: (NSSize)size : (int)win
{
}


- (void) flushwindowrect: (NSRect)rect : (int)win
{
}

// handle X expose events
- (void) _processExposedRectangles: (int)win
{
}

- (BOOL) capturemouse: (int)win
{
	return NO;
}

- (void) releasemouse
{
}

- (void) setMouseLocation: (NSPoint)mouseLocation onScreen: (int)aScreen
{
}

- (void) setinputfocus: (int)win
{
}

/*
 * Instruct window manager that the specified window is 'key', 'main', or
 * just a normal window.
 */
- (void) setinputstate: (int)st : (int)win
{
}

/** Sets the transparancy value for the whole window */
- (void) setalpha: (float)alpha : (int) win
{
}

- (float) getAlpha: (int)win
{
	return 1.0;
}

- (void *) serverDevice
{
	return NULL;
}

- (void *) windowDevice: (int)win
{
	return NULL;
}


/*
  set the cursor for a newly created window.
*/



/*
  set cursor on all XWindows we own.  if `set' is NO
  the cursor is unset on all windows.
  Normally the cursor `c' correspond to the [NSCursor currentCursor]
  The only exception should be when the cursor is hidden.
  In that case `c' will be a blank cursor.
*/



- (void) hidecursor
{
}

- (void) showcursor
{
}

- (void) standardcursor: (int)style : (void **)cid
{
}

- (void) imagecursor: (NSPoint)hotp : (NSImage *)image : (void **)cid
{
}

- (void) recolorcursor: (NSColor *)fg : (NSColor *)bg : (void*) cid
{
}

- (void) setcursor: (void*) cid
{
}

- (void) freecursor: (void*) cid
{
}

/*******************************************************************************
 * Screens, monitors
 *******************************************************************************/

static NSWindowDepth
_computeDepth(int class, int bpp)
{
  NSWindowDepth	depth = 0;
  return depth;
}

  

/* This method assumes that we deal with one X11 screen - `defScreen`.
   Basically it means that we have DISPLAY variable set to `:0.0`.
   Where both digits have artbitrary values, but it defines once on
   every application run.
   AppKit and X11 use the same term "screen" with different meaning:
   AppKit Screen - single monitor/display device.
   X11 Screen - it's a plane where X Server can draw on.
   XRandR - Xorg extension that helps to manipulate monitor layout providing
   X11 Screen. 
   We map XRandR monitors (outputs) to NSScreen. */
- (NSArray *)screenList
{
  return [NSArray arrayWithObject: [NSNumber numberWithInt:1]];
}

// `screen` is a monitor index not X11 screen
- (NSWindowDepth) windowDepthForScreen: (int)screen
{
	return 0;
}

// `screen` is a monitor index not X11 screen
- (const NSWindowDepth *) availableDepthsForScreen: (int)screen
{
	return NULL;
}

// `screen_num` is a Xlib screen number.
- (NSSize) resolutionForScreen: (int)screen_num
{
  // NOTE:
  // -gui now trusts the return value of resolutionForScreen:,
  // so if it is not {72, 72} then the entire UI will be scaled.
  //
  // I commented out the implementation below because it may not
  // be safe to use the DPI value we get from the X server.
  // (i.e. I don't know if it will be a "fake" DPI like 72 or 96,
  //  or a real measurement reported from the monitor's firmware
  //  (possibly incorrect?))
  // More research needs to be done.

  return NSMakeSize(72, 72);

  /*
  int res_x, res_y;

  if (screen < 0 || screen_num >= ScreenCount(dpy))
    {
      NSLog(@"Invalidparam: no screen %d", screen);
      return NSMakeSize(0,0);
    }
  // This does not take virtual displays into account!!
  res_x = DisplayWidth(dpy, screen) /
      (DisplayWidthMM(dpy, screen) / 25.4);
  res_y = DisplayHeight(dpy, screen) /
      (DisplayHeightMM(dpy, screen) / 25.4);

  return NSMakeSize(res_x, res_y);
  */
}

// `screen` is a monitor index not X11 screen
- (NSRect) boundsForScreen: (int)screen
{
  NSRect boundsRect = NSZeroRect;
  return boundsRect;
}

- (NSImage *) iconTileImage
{
	return nil;
}

- (NSSize) iconSize
{
	return NSMakeSize(0,0);
}

- (unsigned int) numberOfDesktops: (int)screen
{
	return 0;
}

- (NSArray *) namesOfDesktops: (int)screen
{
  return nil;
}

- (unsigned int) desktopNumberForScreen: (int)screen
{
	return 0;
}

- (void) setDesktopNumber: (unsigned int)workspace forScreen: (int)screen
{
}

- (unsigned int) desktopNumberForWindow: (int)win
{
	return 0;
}

- (void) setDesktopNumber: (unsigned int)workspace forWindow: (int)win
{
}

- (void) setShadow: (BOOL)hasShadow : (int)win
{
}

- (BOOL) hasShadow: (int)win
{
	return 0;
}

/*
 * Check whether the window is miniaturized according to the ICCCM window
 * state property.
 */

/*
 * Check whether the EWMH window state includes the _NET_WM_STATE_HIDDEN
 * state. On EWMH, a window is iconified if it is iconic state and the
 * _NET_WM_STATE_HIDDEN is present.
 */

- (void) setParentWindow: (int)parentWin
          forChildWindow: (int)childWin
{
}

- (void) setIgnoreMouse: (BOOL)ignoreMouse : (int)win
{
}

@end

