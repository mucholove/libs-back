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

#include "headless/HLContext.h"
#include "headless/HLPrivate.h"
#include "headless/HLGState.h"
#include "headless/HLServer.h"
#include <Foundation/NSDebug.h>
#include <Foundation/NSData.h>
#include <Foundation/NSValue.h>
// For the encoding functions
#include <GNUstepBase/GSMime.h>
#include <GNUstepBase/Unicode.h>

static Atom XA_SLANT = (Atom)0;
static Atom XA_SETWIDTH_NAME = (Atom)0;
static Atom XA_CHARSET_REGISTRY = (Atom)0;
static Atom XA_CHARSET_ENCODING = (Atom)0;
static Atom XA_SPACING = (Atom)0;
static Atom XA_PIXEL_SIZE = (Atom)0;
static Atom XA_WEIGHT_NAME = (Atom)0;

/*
 * Initialise the X atoms we are going to use
 */
static BOOL HLInitAtoms(Display *dpy)
{
  // X atoms used to query a font

  if (!dpy)
    {
      NSDebugLog(@"No Display opened in HLInitAtoms");      
      return NO;
    }

  XA_PIXEL_SIZE = XInternAtom(dpy, "PIXEL_SIZE", False);
  XA_SPACING = XInternAtom(dpy, "SPACING", False);
  XA_WEIGHT_NAME = XInternAtom(dpy, "WEIGHT_NAME", False);
  XA_SLANT = XInternAtom(dpy, "SLANT", False);
  XA_SETWIDTH_NAME = XInternAtom(dpy, "SETWIDTH_NAME", False);
  XA_CHARSET_REGISTRY = XInternAtom(dpy, "CHARSET_REGISTRY", False);
  XA_CHARSET_ENCODING = XInternAtom(dpy, "CHARSET_ENCODING", False);

/*
  XA_ADD_STYLE_NAME = XInternAtom(dpy, "ADD_STYLE_NAME", False);
  XA_RESOLUTION_X = XInternAtom(dpy, "RESOLUTION_X", False);
  XA_RESOLUTION_Y = XInternAtom(dpy, "RESOLUTION_Y", False);
  XA_AVERAGE_WIDTH = XInternAtom(dpy, "AVERAGE_WIDTH", False);
  XA_FACE_NAME = XInternAtom(dpy, "FACE_NAME", False);
*/

  return YES;
}


@interface HLFontInfo (Private)

- (BOOL) setupAttributes;
- (XCharStruct *)xCharStructForGlyph: (NSGlyph) glyph;

@end

@implementation HLFontInfo

- (XFontStruct*) xFontStruct
{
  return font_info;
}

- (id)
    initWithFontName: (NSString*)name
    matrix: (const CGFloat*)fmatrix
	  screenFont: (BOOL)screenFont
{
  if (screenFont)
    {
      RELEASE(self);
      return nil;
    }

  [super init];
  ASSIGN(fontName, name);
  memcpy(matrix, fmatrix, sizeof(matrix));

  if (![self setupAttributes])
    {
      RELEASE(self);
      return nil;
    }

  return self;
}

- (void) 
    dealloc
{
  if (font_info != NULL)
    {
      XFreeFont([HLServer xDisplay], font_info);
    }
  [super dealloc];
}

- (NSMultibyteGlyphPacking)
    glyphPacking
{
  if (font_info->min_byte1 == 0 && 
      font_info->max_byte1 == 0)
    return NSOneByteGlyphPacking;
  else 
    return NSTwoByteGlyphPacking;
}

- (NSSize) 
  advancementForGlyph: (NSGlyph)glyph
{
    return NSMakeSize(0,0);
}

- (NSRect) 
  boundingRectForGlyph: (NSGlyph)glyph
{
    return NSMakeRect(0, 0, 0, 0);
}

- (BOOL) glyphIsEncoded: (NSGlyph)glyph
{
    return YES;
}

- (NSGlyph) 
  glyphWithName: (NSString*)glyphName
{
  // FIXME: There is a mismatch between PS names and X names, that we should 
  // try to correct here
  KeySym k = XStringToKeysym([glyphName cString]);

  if (k == NoSymbol)
    return 0;
  else
    return (NSGlyph)k;
}

- (void) 
    drawString:  (NSString*)string
	  onDisplay: (Display*) xdpy 
    drawable: (Drawable) draw
    with: (GC) HLcntxt 
    at: (XPoint) xp
{
  ;
}

- (void) 
    draw: (const char*) s 
    length: (int) len 
    onDisplay: (Display*) xdpy 
    drawable: (Drawable) draw
	  with: (GC) HLcntxt 
    at: (XPoint) xp
{
  ;
}

- (void) 
    drawGlyphs: (const NSGlyph *) glyphs 
    length: (int) len
	  onDisplay: (Display*) xdpy 
    drawable: (Drawable) draw
    with: (GC) HLcntxt 
    at: (XPoint) xp
{
    ;
}

- (CGFloat) 
  widthOfString: (NSString*)string
{
    return 0.0;
}

- (CGFloat) 
  widthOf: (const char*) s 
  length: (int) len
{
  return 0.0;
}

- (CGFloat) 
    widthOfGlyphs: (const NSGlyph *) glyphs 
    length: (int) len
{
  return 0.0; // XTextWidth(font_info, buf, len);
}

- (void) 
    setActiveFor: (Display*) xdpy 
    gc: (GC) HLcntxt
{
    ;
}

@end

@implementation HLFontInfo (Private)

- (BOOL) 
    setupAttributes
{
    return YES;
}

@end
