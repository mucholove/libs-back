/* HLGState - Implements graphic state drawing for headless

   Copyright (C) 1998-2010 Free Software Foundation, Inc.

   Written by:  Adam Fedor <fedor@gnu.org>
   Date: Nov 1998
   
   This file is part of the GNU Objective C User Interface Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/

#import "config.h"
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSUserDefaults.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSDebug.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSException.h>
#import <AppKit/NSBezierPath.h>
#import <AppKit/NSFont.h>
#import <AppKit/NSGraphics.h>

#import "headless/HLGeometry.h"
#import "headless/HLContext.h"
#import "headless/HLGState.h"
#import "headless/HLContext.h"
#import "headless/HLPrivate.h"
#include "math.h"

#define XDPY (((RContext *)context)->dpy)

static BOOL shouldDrawAlpha = YES;

#define CHECK_GC \
  if (!xgcntxt) \
    [self createGraphicContext]

#define COPY_GC_ON_CHANGE \
  CHECK_GC; \
  if (sharedGC == YES) \
    [self copyGraphicContext]


@implementation HLGState


/*
+ (void) initialize
{
  static BOOL beenHere = NO;

  if (beenHere == NO)
    {
      XPoint pts[5];
      id obj = [[NSUserDefaults standardUserDefaults]
                 stringForKey: @"GraphicCompositing"];
      if (obj)
        shouldDrawAlpha = [obj boolValue];

      beenHere = YES;
      pts[0].x = 0; pts[0].y = 0;
      pts[1].x = 0; pts[1].y = 0;
      pts[2].x = 0; pts[2].y = 0;
      pts[3].x = 0; pts[3].y = 0;
      pts[4].x = 0; pts[4].y = 0;
      emptyRegion = XPolygonRegion(pts, 5, WindingRule);
      NSAssert(XEmptyRegion(emptyRegion), NSInternalInconsistencyException);
    }
}
*/

/* Designated initializer. */
- initWithDrawContext: (GSContext *)drawContext
{
  [super initWithDrawContext: drawContext];

  /*
  drawMechanism = -1;
  draw = 0;
  alpha_buffer = 0;
  xgcntxt = None;
  agcntxt = None;
#ifdef HAVE_XFT
  xft_draw = NULL;
  xft_alpha_draw = NULL;
  memset(&xft_color, 0, sizeof(XftColor));
#endif
*/
  return self;
}

- (void) dealloc
{
	/*
  if (sharedGC == NO && xgcntxt) 
    {
      XFreeGC(XDPY, xgcntxt);
    }
  if (agcntxt)
    XFreeGC(XDPY, agcntxt);
  if (clipregion)
    XDestroyRegion(clipregion);

#ifdef HAVE_XFT
  if (xft_draw != NULL)
    {
      XftDrawDestroy(xft_draw);
    }
  if (xft_alpha_draw != NULL)
    {
      XftDrawDestroy(xft_alpha_draw);
    }
#endif
*/
  [super dealloc];
}

- (id) 
    deepen
{
    [super deepen];
}

- (void) 
    setWindowDevice: (void *)device
{
    ;
}



/* Set the GC clipmask.  */
- (void) 
    setClipMask
{
    ;
}


- (void) 
    setColor: (device_color_t *)color 
    state: (color_state_t)cState
{
    ;
}

- (void) 
    setAlphaColor: (float)value
{
    ;
}

- (void) 
    copyGraphicContext
{
    ;
    return;
}

// Create a default graphics context.
- (void) 
    createGraphicContext
{
    /*
  if (draw == 0)
    {
      // This could happen with a defered window
      DPS_WARN(DPSinvalidid, @"Creating a GC with no Drawable defined");
      return;
    }
  gcv.function = GXcopy;
  gcv.background = ((RContext *)context)->white;
  gcv.foreground = ((RContext *)context)->black;
  gcv.plane_mask = AllPlanes;
  gcv.line_style = LineSolid;
  gcv.fill_style = FillSolid;
  gcv.fill_rule  = WindingRule;
  xgcntxt = XCreateGC(XDPY, draw,
                      GCFunction | GCForeground | GCBackground | GCPlaneMask 
                      | GCFillStyle | GCFillRule| GCLineStyle,
                      &gcv);
  [self setClipMask];
  sharedGC = NO;
  return;
    */
}

- (NSRect)
    clipRect
{
    return NSMakeRect(0, 0, 0, 0);
}

- (BOOL) hasGraphicContext
{
  return NO;
}

- (BOOL) hasDrawable
{
  return NO;
}



/*
- (void) 
    _alphaBuffer: (gswindow_device_t *)dest_win
{
    ;
}
*/

- (void) 
    _compositeGState: (HLGState *) source 
    fromRect: (NSRect) fromRect
    toPoint: (NSPoint) toPoint
    op: (NSCompositingOperation) op
    fraction: (CGFloat)delta
{
    ;
}

- (void) 
    compositeGState: (GSGState *)source 
    fromRect: (NSRect)aRect
    toPoint: (NSPoint)aPoint
    op: (NSCompositingOperation)op
    fraction: (CGFloat)delta
{
     ;
}

- (void) 
    compositerect: (NSRect)aRect
    op: (NSCompositingOperation)op
{
      ;
}

/* Paint the current path using headless calls. All coordinates should already
   have been transformed to device coordinates. */
/*
- (void) 
    _doPath: (XPoint*)pts : (int)count 
    draw: (ctxt_object_t)type
{
    ;
}
*/

/* fill a complex path. All coordinates should already have been
   transformed to device coordinates. */
/*
- (void) 
    _doComplexPath: (XPoint*)pts 
    : (int*)types 
    : (int)count
    ll: (XPoint)ll 
    ur: (XPoint)ur 
    draw: (ctxt_object_t)type
{
    ;
}

- (void) 
    _paintPath: (ctxt_object_t) drawType
{
      ;
}

- (XPoint) 
    viewPointToX: (NSPoint)aPoint
{
  return XGViewPointToX(self, aPoint);
}

- (XRectangle) 
    viewRectToX: (NSRect)aRect
{
  return XGViewRectToX(self, aRect);
}

- (XPoint) 
    windowPointToX: (NSPoint)aPoint
{
  return XGWindowPointToX(self, aPoint);
}

- (XRectangle) 
    windowRectToX: (NSRect)aRect
{
  return XGWindowRectToX(self, aRect);
}
*/

@end

@implementation HLGState (Ops)

- (void) 
    DPSsetalpha: (CGFloat)a
{
    // [self _alphaBuffer: 0.0];
}

/* ----------------------------------------------------------------------- */
/* Text operations */
/* ----------------------------------------------------------------------- */

- (void)
    DPSshow: (const char *)s 
{
    ;
}


- (void) 
    GSShowGlyphsWithAdvances: (const NSGlyph *)glyphs : (const NSSize *)advances : (size_t) length
{
    ;
}

- (void)
    GSSetFont: (GSFontInfo *)newFont
{
  if (font == newFont) {
    return;
  }
  [super GSSetFont: newFont];
}

/* ----------------------------------------------------------------------- */
/* Gstate operations */
/* ----------------------------------------------------------------------- */
- (void)
    DPScurrentlinecap: (int *)linecap 
{
    *linecap = 0;
}

- (void)DPScurrentlinejoin: (int *)linejoin 
{
    *linejoin = 0;
}

- (void)
    DPScurrentlinewidth: (CGFloat *)width 
{
    *width = 0.0;
}

- (void)
    DPSinitgraphics 
{
    [super DPSinitgraphics];
}

- (void)
  DPSsetdash: (const CGFloat *)pat : (NSInteger)size : (CGFloat)pat_offset 
{
    ;
}

- (void)DPSsetlinecap: (int)linecap 
{
    ;
}

- (void)
    DPSsetlinejoin: (int)linejoin 
{
    ;
}

- (void)
    DPSsetlinewidth: (CGFloat)width 
{
    ;
}

- (void) 
    DPSsetmiterlimit: (CGFloat)limit
{
  /* Do nothing. X11 does its own thing and doesn't give us a choice */
}

/* ----------------------------------------------------------------------- */
/* Paint operations */
/* ----------------------------------------------------------------------- */
- (void)DPSclip 
{
    ;
}

- (void)
    DPSeoclip 
{
    ;
}

- (void)
    DPSeofill 
{
    ;
}

- (void)
    DPSfill 
{
    ;
}

- (void)
    DPSinitclip 
{
    ;
}

- (void)
    DPSrectclip: (CGFloat)x : (CGFloat)y : (CGFloat)w : (CGFloat)h 
{
    ;
}

- (void)
    DPSrectstroke: (CGFloat)x : (CGFloat)y : (CGFloat)w : (CGFloat)h 
{
    ;
}

- (void)
  DPSstroke 
{
}

/* ----------------------------------------------------------------------- */
/* NSGraphics Ops */
/* ----------------------------------------------------------------------- */
- (void)DPSimage: (NSAffineTransform*) matrix : (NSInteger) pixelsWide : (NSInteger) pixelsHigh
                : (NSInteger) bitsPerSample : (NSInteger) samplesPerPixel 
                : (NSInteger) bitsPerPixel : (NSInteger) bytesPerRow : (BOOL) isPlanar
                : (BOOL) hasAlpha : (NSString *) colorSpaceName
                : (const unsigned char *const [5]) data
{  
    ;  
}

- (NSDictionary *) GSReadRect: (NSRect)rect
{
  NSMutableDictionary *dict;
  dict = [NSMutableDictionary dictionary];
  // [dict setObject: [NSValue valueWithSize: ssize] 
  //       forKey: @"Size"];
  // [dict setObject: NSDeviceRGBColorSpace 
  //      forKey: @"ColorSpace"];
  // [dict setObject: [NSNumber numberWithUnsignedInt: 8] 
  //      forKey: @"BitsPerSample"];
  // [dict setObject: [NSNumber numberWithUnsignedInt: source_win->depth]
  //      forKey: @"Depth"];
  // [dict setObject: [NSNumber numberWithUnsignedInt: 3] 
  //       forKey: @"SamplesPerPixel"];
  // [dict setObject: [NSNumber numberWithUnsignedInt: 0]
  //      forKey: @"HasAlpha"];
  // [dict setObject: matrix 
  //      forKey: @"Matrix"];
  // [dict setObject: data   
  //      forKey: @"Data"];
  return dict;
}

@end

@implementation HLGState (PatternColor)

- (void *) 
    saveClip
{
    ;
}

- (void) 
    restoreClip: (void *)savedClip
{
    ;
}

@end
