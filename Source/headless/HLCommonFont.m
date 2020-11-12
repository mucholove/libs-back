/*
   HLFontInfo

   NSFont helper for GNUstep GUI X/GPS Backend

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author: Scott Christley
   Author: Ovidiu Predescu <ovidiu@bx.logicnet.ro>
   Date: February 1997
   Author:  Felipe A. Rodriguez <far@ix.netcom.com>
   Date: May, October 1998
   Author:  Michael Hanni <mhanni@sprintmail.com>
   Date: August 1998
   Author:  Fred Kiefer <fredkiefer@gmx.de>
   Date: September 2000

   This file is part of the GNUstep GUI X/GPS Backend.

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

#include <config.h>

// #include <X11/Xatom.h>
// #include <X11/Xlib.h>
// #include <X11/Xutil.h>
#include "headless/HLContext.h"
#include "headless/HLPrivate.h"
#include <Foundation/NSDebug.h>
// For the encoding functions
#include <GNUstepBase/Unicode.h>

