/* HLGState - Implements graphic state drawing for Xlib

   Copyright (C) 1995 Free Software Foundation, Inc.

   Written by: Adam Fedor <fedor@boulder.colorado.edu>
   Date: Nov 1995
   
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


#include <Foundation/NSArray.h>
#include <Foundation/NSObject.h>
#include "gsc/GSGState.h"

#ifndef _HLGState_h_INCLUDE
#define _HLGState_h_INCLUDE

@class NSBezierPath;
@class NSFont;

@interface HLGState : GSGState
@end

#endif /* _HLGState_h_INCLUDE */

