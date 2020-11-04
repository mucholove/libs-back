/* -*- mode:ObjC -*-
   HLContext - Drawing context using the Xlib Library.

   Copyright (C) 1998,1999,2002 Free Software Foundation, Inc.

   Written by:  Adam Fedor <fedor@boulder.colorado.edu>
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

#include "config.h"
#include <AppKit/AppKitExceptions.h>
#include <AppKit/NSAffineTransform.h>
#include <AppKit/NSBitmapImageRep.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/NSColor.h>
#include <AppKit/NSView.h>
#include <AppKit/NSWindow.h>
#include <Foundation/NSException.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSData.h>
#include <Foundation/NSValue.h>
#include <Foundation/NSString.h>
#include <Foundation/NSUserDefaults.h>
#include <Foundation/NSDebug.h>

#include "x11/HLServer.h"
#include "xlib/HLContext.h"
#include "xlib/HLPrivate.h"
#include "xlib/HLGState.h"

#ifdef HAVE_XFT
#include "xlib/GSXftFontInfo.h"
#endif

#include "xlib/HLFontSetFontInfo.h"

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>

/**
   <unit>
   <heading>HLContext</heading>
   <p>
   The documentation below mostly describes methods that are specific to 
   this backend and wouldn't necessarily be used in other backends. The methods
   that this class does implement that would need to be in every backend are
   the methods of its NSGraphicContext superclass. See the documentation
   for NSGraphicContext for more information.
   </p>
   </unit>
*/
@implementation HLContext 

/* Initialize AppKit backend */
+ (void)initializeBackend
{
    Class fontClass = Nil;
    Class fontEnumerator = Nil;
    BOOL  enableFontSet;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    NSDebugLog(@"Initializing GNUstep xlib backend.\n");

    [NSGraphicsContext setDefaultContextClass: [HLContext class]];
    
    fontClass = [HLFontInfo class];
    fontEnumerator = [HLFontEnumerator class];
    
    [GSFontInfo setDefaultClass: fontClass];
    [GSFontEnumerator setDefaultClass: fontEnumerator];
}

+ (Class) 
    GStateClass
{
  return [HLGState class];
}

- (void) flushGraphics
{
    ;
}

// Try to match the restrictions in HLBitmap
- (BOOL) 
  isCompatibleBitmap: (NSBitmapImageRep*)bitmap
{
  return NO;
}

@end

@implementation HLContext (Ops)

/* ----------------------------------------------------------------------- */
/* Window system ops */
/* ----------------------------------------------------------------------- */
- (void) 
  GSCurrentDevice: (void **)device 
  : (int *)x 
  : (int *)y
{
  
    *x = 0;
    *y = 0;
    /*
    void *windevice = [(HLGState *)gstate windevice];
    if (device) {
        *device =  windevice;
    }
    if (x && y) {
      NSPoint offset = [gstate offset];
      *x = offset.x;
      *y = offset.y;
    }
    */
}

- (void) 
    GSSetDevice: (void *)device 
    : (int)x 
    : (int)y
{
  [(HLGState *)gstate setWindowDevice: device];
  [gstate setOffset: NSMakePoint(x, y)];
}

@end
