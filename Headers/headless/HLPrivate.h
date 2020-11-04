/* 
   HLPrivate.h

   Copyright (C) 2002 Free Software Foundation, Inc.

   Author:  Adam Fedor <fedor@gnu.org>
   Date: Mar 2002
   
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

#ifndef _HLPrivate_h_INCLUDE
#define _HLPrivate_h_INCLUDE

/*
#ifdef HAVE_WRASTER_H
#include "wraster.h"
#else
#include "x11/wraster.h"
#endif
*/

#include "headless/HLServer.h"
#include "headless/HLContext.h"

#include <GNUstepGUI/GSFontInfo.h>

/* Font function (defined in HLFontManager) */
extern NSString	*HLFontName(NSString *fontName, float size);

/* Font functions (defined in HLCommonFont) */
/*
extern NSString        *HLFontCacheName(Display *dpy);
extern NSString        *HLFontName(Display *dpy, XFontStruct *font_struct);
extern NSString	     *HLFontFamily(Display *dpy, XFontStruct *font_struct);
extern float            HLFontPointSize(Display *dpy, XFontStruct *font_struct);
extern int              HLWeightOfFont(Display *dpy, XFontStruct *info);
extern NSFontTraitMask  HLTraitsOfFont(Display *dpy, XFontStruct *info);
extern BOOL             HLFontIsFixedPitch(Display *dpy, XFontStruct *font_struct);
extern NSString        *HLFontPropString(Display *dpy, XFontStruct *font_struct, Atom atom);
extern unsigned long    HLFontPropULong(Display *dpy, XFontStruct *font_struct,  Atom atom);
*/

@interface HLFontEnumerator : GSFontEnumerator
{
}
@end

@interface HLFontInfo : GSFontInfo
{
  // XFontStruct *font_info;
}
@end

/*
@interface GSFontInfo (XBackend)

- (void) 
   drawString:  (NSString*)string
   onDisplay: (Display*) xdpy 
   drawable: (Drawable) draw
   with: (GC) HLcntxt 
   at: (XPoint) xp;
   
- (void) 
   draw: (const char*) s 
   length: (int) len 
   onDisplay: (Display*) xdpy 
   drawable: (Drawable) draw
   with: (GC) HLcntxt 
   at: (XPoint) xp;
   
- (float) 
   widthOf: (const char*) s 
   length: (int) len;
   
- (void) 
   setActiveFor: (Display*) xdpy 
   gc: (GC) HLcntxt;

- (void) 
   drawGlyphs: (const NSGlyph *) glyphs 
   length: (int) len
   onDisplay: (Display*) xdpy 
   drawable: (Drawable) draw
   with: (GC) HLcntxt 
   at: (XPoint) xp;
   
- (float) 
   widthOfGlyphs: (const NSGlyph *) glyphs 
   length: (int) len;

@end

// In HLBitmap.m
extern int _pixmap_combine_alpha(RContext *context,
                      RXImage *source_im, RXImage *source_alpha,
                      RXImage *dest_im, RXImage *dest_alpha,
                      XRectangle srect,
                      NSCompositingOperation op,
                      HLDrawMechanism drawMechanism,
				 float fraction);

extern int _bitmap_combine_alpha(RContext *context,
		unsigned char * data_planes[5],
		int width, int height,
		int bits_per_sample, int samples_per_pixel,
		int bits_per_pixel, int bytes_per_row,
		int colour_space, BOOL one_is_black,
		BOOL is_planar, BOOL has_alpha, BOOL fast_min,
		RXImage *dest_im, RXImage *dest_alpha,
		XRectangle srect, XRectangle drect,
		NSCompositingOperation op,
		HLDrawMechanism drawMechanism);

extern NSData *_pixmap_read_alpha(RContext *context,
				  RXImage *source_im, RXImage *source_alpha,
				  XRectangle srect,
				  HLDrawMechanism drawMechanism);

#endif

*/


