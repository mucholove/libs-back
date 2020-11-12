/* HLSInputServer - HLS Keyboard input handling

   Copyright (C) 2002 Free Software Foundation, Inc.

   Author: Christian Gillot <cgillot@neo-rousseaux.org>
   Date: Nov 2001
   Author: Adam Fedor <fedor@gnu.org>
   Date: Jan 2002

   This file is part of the GNUstep GUI Library.

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

#include <Foundation/NSUserDefaults.h>
#include <Foundation/NSData.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSException.h>
#include <GNUstepBase/Unicode.h>
#include <AppKit/NSWindow.h>
#include <AppKit/NSView.h>

#include "headless_server/HLSInputServer.h"
#include <X11/Xlocale.h>

#define NoneStyle           (HLSPreeditNone     | HLSStatusNone)
#define RootWindowStyle	    (HLSPreeditNothing	| HLSStatusNothing)
#define OffTheSpotStyle	    (HLSPreeditArea	| HLSStatusArea)
#define OverTheSpotStyle    (HLSPreeditPosition	| HLSStatusArea)
#define OnTheSpotStyle	    (HLSPreeditCallbacks| HLSStatusCallbacks)


@interface HLSInputServer (HLSPrivate)
@end

#define BUF_LEN 255

@implementation HLSInputServer

- (id) initWithDelegate: (id)aDelegate
		   name: (NSString *)name
{
	self = [super init];
	delegate = aDelegate;
        ASSIGN(server_name, name);
  	return self;
}

- (void) dealloc
{
  [super dealloc];
}


/* ----------------------------------------------------------------------
   NSInputServiceProvider protocol methods
*/
- (void) activeConversationChanged: (id)sender
		 toNewConversation: (long)newConversation
{
}

- (void) activeConversationWillChange: (id)sender
		  fromOldConversation: (long)oldConversation
{
  [super activeConversationWillChange: sender
	          fromOldConversation: oldConversation];
}


@end

@implementation HLSInputServer (InputMethod)
- (NSString *) inputMethodStyle
{
  return nil;
}

- (NSString *) fontSize: (int *)size
{
  NSString *str;

  str = [[NSUserDefaults standardUserDefaults] stringForKey: @"NSFontSize"];
  if (!str)
    str = @"12";
  *size = (int)strtol([str cString], NULL, 10);
  return str;
}

- (BOOL) clientWindowRect: (NSRect *)rect
{
  *rect = NSMakeRect(0, 0, 0, 0);
  return YES;
}

- (BOOL) statusArea: (NSRect *)rect
{
  return NO;
}

- (BOOL) preeditArea: (NSRect *)rect
{
  return NO;
}

- (BOOL) preeditSpot: (NSPoint *)p
{
  return NO;
}

- (BOOL) setStatusArea: (NSRect *)rect
{
  return NO;
}

- (BOOL) setPreeditArea: (NSRect *)rect
{
  return NO;
}

- (BOOL) setPreeditSpot: (NSPoint *)p
{
  return NO;
}

@end // HLSInputServer (InputMethod)
