/* <title>HLFontSetFontInfo</title>

   <abstract>NSFont helper for GNUstep X/GPS Backend</abstract>

   Copyright (C) 2003-2005 Free Software Foundation, Inc.

   Author: Kazunobu Kuriyama <kazunobu.kuriyama@nifty.com>
   Date: July 2003
   
   This file is part of the GNU Objective C User Interface library.

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

#include "headless/HLServer.h"
#include "headless/HLPrivate.h"
#include "headless/HLFontSetFontInfo.h"

#ifdef X_HAVE_UTF8_STRING

#define XSERVER [HLServer xDisplay]

typedef struct _UTF8Str {
    char    *data;
    int	    size;
} UTF8Str;

#define UTF8StrData(x)	((x)->data)
#define UTF8StrSize(x)	((x)->size)
#define UTF8StrFree(x) \
do { \
  if ((x)->data) \
    { \
      free((x)->data); \
      (x)->data = NULL; \
      (x)->size = 0; \
    } \
} while (0)
#define UTF8StrAlloc(x, length) \
do { (x)->data = malloc(6 * (length)); } while (0)
#define UTF8StrUsable(x) ((x)->data != NULL)


// Forward declarations
static BOOL load_font_set(Display *dpy, const char *given_font_name,
			  XFontSet *font_set,
			  XFontStruct ***fonts, int *num_fonts);
static BOOL glyphs2utf8(const NSGlyph* glyphs, int length, UTF8Str* ustr);
static BOOL char_struct_for_glyph(NSGlyph glyph, XFontSet font_set,
				  XFontStruct **fonts, int num_fonts,
				  XCharStruct *cs);


#if 0 // Commented out till the implementation completes.
// ----------------------------------------------------------------------------
//  HLFontSetEnumerator
// ----------------------------------------------------------------------------
@implementation HLFontSetEnumerator : GSFontEnumerator

- (void) enumerateFontsAndFamilies
{ }

@end // HLFontSetEnumerator : GSFontEnumerator
#endif // #if 0


// ----------------------------------------------------------------------------
//  HLFontSetFontInfo
// ----------------------------------------------------------------------------
@implementation HLFontSetFontInfo : GSFontInfo

- (id) 
    initWithFontName: (NSString *)name
    matrix: (const CGFloat*)fmatrix
    screenFont: (BOOL)screenFont
{
  [super init];
  return self;
}

- (void) 
    dealloc
{
    [super dealloc];
}

- (NSSize) 
    advancementForGlyph: (NSGlyph)glyph
{
    return NSMakeSize(0,0);
}

- (NSRect) 
    boundingRectForGlyph: (NSGlyph)glyph
{
    return NSMakeRect(0,0,0,0);
}

- (BOOL) 
    glyphIsEncoded: (NSGlyph)glyph
{
    return YES;
}

- (NSGlyph) 
    glyphWithName: (NSString *)glyphName
{
    return 1;
}

- (void) 
    drawGlyphs: (const NSGlyph *)glyphs
    length: (int)len
    onDisplay: (Display *)dpy
    drawable: (Drawable)win
    with: (GC)gc
    at: (XPoint)xp
{
    ;
}

- (CGFloat) 
    widthOfGlyphs: (const NSGlyph *)glyphs
    length: (int)len
{
    return 0.0;
}

- (void) setActiveFor: (Display *)dpy
                   gc: (GC)gc
{
  // Do nothing.
}

@end // HLFontSetFontInfo : GSFontInfo


// ----------------------------------------------------------------------------
//  Static Functions
// ----------------------------------------------------------------------------
static BOOL
    load_font_set(
        Display *dpy, 
        const char *given_font_name,
	      XFontSet *font_set, 
        XFontStruct ***fonts, 
        int *num_fonts)
{
    return YES;
}

// N.B. Use UTF8StrFree() to release the space pointed to by 'ustr'.
static BOOL
  glyphs2utf8(
      const NSGlyph* glyphs, 
      int length, 
      UTF8Str* ustr)
{
  return YES;
}

static BOOL
    char_struct_for_glyph(
          NSGlyph glyph, 
          XFontSet font_set,
		      XFontStruct **fonts, 
          int num_fonts,
		      XCharStruct *cs)
{
  return YES;
}

#endif // X_HAVE_UTF8_STRING defined
