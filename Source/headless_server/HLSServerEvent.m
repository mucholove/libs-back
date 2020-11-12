/*
   HLSServerEvent - Window/Event code for X11 backends.

   Copyright (C) 1998-2015 Free Software Foundation, Inc.

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
*/

#include "config.h"

#include <AppKit/AppKitExceptions.h>
#include <AppKit/NSApplication.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/NSMenu.h>
#include <AppKit/NSPasteboard.h>
#include <AppKit/NSWindow.h>
#include <AppKit/NSScreen.h>
#include <Foundation/NSException.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSData.h>
#include <Foundation/NSNotification.h>
#include <Foundation/NSValue.h>
#include <Foundation/NSString.h>
#include <Foundation/NSUserDefaults.h>
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSDistributedNotificationCenter.h>

#include "headless_server/HLSServerWindow.h"
#include "headless_server/HLSInputServer.h"
#include "headless_server/HLSDragView.h"
#include "headless_server/HLSGeneric.h"
// #include "headless_server/xdnd.h"


#if LIB_FOUNDATION_LIBRARY
# include <Foundation/NSPosixFileDescriptor.h>
#elif defined(NeXT_PDO)
# include <Foundation/NSFileHandle.h>
# include <Foundation/NSNotification.h>
#endif

#define cWin ((gswindow_device_t*)generic.cachedWindow)

// NumLock's mask (it depends on the keyboard mapping)
static unsigned int _num_lock_mask;
// Modifier state
static char _shift_pressed = 0;
static char _control_pressed = 0;
static char _command_pressed = 0;
static char _alt_pressed = 0;
static char _help_pressed = 0;
/*
Keys used for the modifiers (you may set them with user preferences).
Note that the first and second key sym for a modifier must be different.
Otherwise, the _*_pressed tracking will be confused.
*/

static BOOL _is_keyboard_initialized = YES;
static BOOL _mod_ignore_shift        = YES;

/*
  Mouse properties. In comments below specified defaults key and default value.
*/
static NSInteger   clickTime;             // "GSDoubleClickTime" - milisecond (250)
static NSInteger   clickMove;             // "GSMouseMoveThreshold" - in pixels (3)
static NSInteger   mouseScrollMultiplier; // "GSMouseScrollMultiplier" - times (1)
static NSEventType menuMouseButton;       // "GSMenuButtonEvent" - (NSRightMouseButon)
static BOOL        menuButtonEnabled;     // "GSMenuButtonEnabled" - BOOL
static BOOL        swapMouseButtons;      // YES if "GSMenuButtonEvent" == NSLeftMouseButton

@implementation HLSServerEvent
@end
