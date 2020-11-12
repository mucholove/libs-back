/*
   Copyright (C) 2002, 2003, 2004, 2005 Free Software Foundation, Inc.

   Author:  Alexander Malmberg <alexander@malmberg.org>

   This file is part of GNUstep.

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

#include <config.h>

#include <Foundation/NSUserDefaults.h>

#include "headless_server/HLSServer.h"
#include "headless_server/HLSServerWindow.h"
#include "headless_server/HLSWindowBuffer.h"

#include <math.h>
#include <sys/ipc.h>
#include <sys/shm.h>


static HLSWindowBuffer **window_buffers;
static int num_window_buffers;


@implementation HLSWindowBuffer

/*
+ (void) initialize
{
}
*/

+ windowBufferForWindow: (gswindow_device_t *)awindow
              depthInfo: (struct HLSWindowBuffer_depth_info_s *)aDI
{
	return [[self alloc] init];
}


- (void) _gotShmCompletion
{
}

- (void) _exposeRect: (NSRect)rect
{
}

- (void) needsAlpha
{
}

- (void) dealloc
{
  [super dealloc];
}



@end

