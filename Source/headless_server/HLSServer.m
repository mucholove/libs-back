/* -*- mode:ObjC -*-
   XGServer - X11 Server Class

   Copyright (C) 1998-2015 Free Software Foundation, Inc.

   Written by:  Adam Fedor <fedor@gnu.org>
   Date: Mar 2002
   
   This file is part of the GNU Objective C User Interface Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/

#include "config.h"
#include <AppKit/AppKitExceptions.h>
#include <AppKit/NSApplication.h>
#include <AppKit/NSView.h>
#include <AppKit/NSWindow.h>
#include <Foundation/NSException.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSConnection.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSData.h>
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSValue.h>
#include <Foundation/NSString.h>
#include <Foundation/NSUserDefaults.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSDistributedNotificationCenter.h>

#include <signal.h>
/* Terminate cleanly if we get a signal to do so */
static void
terminate(int sig)
{
  if (nil != NSApp)
    {
      [NSApp terminate: NSApp];
    }
  else
    {
      exit(1);
    }
}

#include "headless_server/HLSServer.h"
#include "headless_server/HLSInputServer.h"

@interface HLSScreenContext : NSObject
@end

@implementation HLSScreenContext
@end


/**
   <unit>
   <heading>XGServer</heading>

   <p> XGServer is a concrete subclass of GSDisplayServer that handles
   X-Window client communications. The class is broken into four sections.
   The main class handles setting up and closing down the display, as well
   as providing wrapper methods to access display and screen pointers. The
   WindowOps category handles window creating, display, movement, and
   other functions detailed in the GSDisplayServer(WindowOps) category.
   The EventOps category handles events received from X-Windows and the
   window manager. It implements the methods defined in the
   GSDisplayServer(EventOps) category. The last section 
   </unit>
*/
@implementation HLSServer 

/* Initialize AppKit backend */
+ (void) initializeBackend
{
  //NSDebugLog(@"Initializing GNUstep Headless Server backend.\n");
  NSLog(@"Initializing GNUstep Headless Server backend.\n");
  [GSDisplayServer setDefaultServerClass: [HLSServer class]];
  signal(SIGTERM, terminate);
  signal(SIGINT, terminate);
}

/*
   Opens the X display (using a helper method) and sets up basic
   display mechanisms, such as visuals and colormaps.
*/
- (id) initWithAttributes: (NSDictionary *)info
{
  [super initWithAttributes: info];
  // [self setupRunLoopInputSourcesForMode: NSDefaultRunLoopMode]; 
  // [self setupRunLoopInputSourcesForMode: NSConnectionReplyMode]; 
  // [self setupRunLoopInputSourcesForMode: NSModalPanelRunLoopMode]; 
  // [self setupRunLoopInputSourcesForMode: NSEventTrackingRunLoopMode]; 
  return self;
}

/**
   Closes all X resources, the X display and dealloc other ivars.
*/
- (void) dealloc
{
  NSDebugLog(@"Destroying HLS Server");
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
  DESTROY(inputServer);
  // [self _destroyServerWindows];
  // NSFreeMapTable(screenList);
  // if (monitors != NULL)
  //   {
  //     NSZoneFree([self zone], monitors);
  //   }
  // XCloseDisplay(dpy);
  [super dealloc];
}


- (int) screenDepth
{
  return 0;
}


// Could use NSSwapInt() instead
static unsigned int flip_bytes32(unsigned int i)
{
  return ((i >> 24) & 0xff)
      |((i >>  8) & 0xff00)
      |((i <<  8) & 0xff0000)
      |((i << 24) & 0xff000000);
}

static unsigned int flip_bytes16(unsigned int i)
{
  return ((i >> 8) & 0xff)
      |((i <<  8) & 0xff00);
}

static int byte_order(void)
{
  union
  {
    unsigned int i;
    char c;
  } foo;
  foo.i = 1;
  return foo.c != 1;
}

/**
 * Used by the art backend to determine the drawing mechanism.
 */
- (void)
	getForScreen: (int)screen_id
	pixelFormat: (int *)bpp_number 
        masks: (int *)red_mask
	     : (int *)green_mask
	     : (int *)blue_mask
{
}


/**
  Wait for all contexts to finish processing. Only used with XDPS graphics.
*/
+ (void) waitAllContexts
{
  if ([[GSCurrentContext() class] 
        respondsToSelector: @selector(waitAllContexts)])
    [[GSCurrentContext() class] waitAllContexts];
}

- (void) beep
{
 puts("Beep.");  
}

- glContextClass
{
  return nil;
}

- glPixelFormatClass
{
  return nil;
}


@end

@implementation HLSServer (InputMethod)
- (NSString *) inputMethodStyle
{
  return inputServer ? [inputServer inputMethodStyle]
    : (NSString*)nil;
}

- (NSString *) fontSize: (int *)size
{
  return inputServer ? [inputServer fontSize: size]
    : (NSString*)nil;
}

- (BOOL) clientWindowRect: (NSRect *)rect
{
  return inputServer
    ? [inputServer clientWindowRect: rect] : NO;
}

- (BOOL) statusArea: (NSRect *)rect
{
  return inputServer ? [inputServer statusArea: rect] : NO;
}

- (BOOL) preeditArea: (NSRect *)rect
{
  return inputServer ? [inputServer preeditArea: rect] : NO;
}

- (BOOL) preeditSpot: (NSPoint *)p
{
  return inputServer ? [inputServer preeditSpot: p] : NO;
}

- (BOOL) setStatusArea: (NSRect *)rect
{
  return inputServer
    ? [inputServer setStatusArea: rect] : NO;
}

- (BOOL) setPreeditArea: (NSRect *)rect
{
  return inputServer
    ? [inputServer setPreeditArea: rect] : NO;
}

- (BOOL) setPreeditSpot: (NSPoint *)p
{
  return inputServer
    ? [inputServer setPreeditSpot: p] : NO;
}

@end // XGServer (InputMethod)


#if defined(__clang__)
#pragma clang diagnostic pop
#endif
//==== End: Additional Code for NSTextView ====================================
