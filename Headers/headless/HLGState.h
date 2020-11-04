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

#ifndef _HLGState_h_INCLUDE
#define _HLGState_h_INCLUDE

#include <Foundation/NSArray.h>
#include <Foundation/NSObject.h>
#include "gsc/GSGState.h"
#endif

@class NSBezierPath;
@class NSFont;

@interface HLGState : GSGState
{
@public
  void      *context;
  void      *windevice;
  HLDrawMechanism drawMechanism;
  GC	    HLcntxt;
  GC	    agcntxt;
  HLCValues gcv;
  Drawable  draw;
  Drawable  alpha_buffer;
  Region clipregion;
#ifdef HAVE_XFT
  XftDraw   *xft_draw;
  XftDraw   *xft_alpha_draw;
  XftColor  xft_color;
#endif

  BOOL drawingAlpha;
  BOOL sharedGC;  /* Do we own the GC or share it? */
}

- (void) 
   setWindowDevice: (void *)device;
   
- (void) 
   setGraphicContext: (GC)HLraphicContext;
   
- (void) 
   setGCValues: (HLCValues)values 
   withMask: (int)mask;
   
- (void) 
   setClipMask;
   
- (Region) 
   xClipRegion;

- (BOOL) hasDrawable;
- (BOOL) hasGraphicContext;
- (void *) windevice;
- (Drawable) drawable;
- (GC) graphicContext;
- (NSRect) clipRect;


- (XPoint) viewPointToX: (NSPoint)aPoint;
- (XRectangle) viewRectToX: (NSRect)aRect;
- (XPoint) windowPointToX: (NSPoint)aPoint;
- (XRectangle) windowRectToX: (NSRect)aRect;

@end

@interface HLGState (Ops)
- (NSDictionary *) GSReadRect: (NSRect)rect;
@end

#endif /* _HLGState_h_INCLUDE */

