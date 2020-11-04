 /*
   GSHLFontInfo

   NSFont helper for GNUstep GUI X/GPS Backend

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Fred Kiefer <fredkiefer@gmx.de>
   Date: July 2001

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

#include "config.h"
#include "headless/HLContext.h"
#include "headless/HLPrivate.h"
#include "headless/HLGState.h"
#include "headless/HLServer.h"
#include <Foundation/NSByteOrder.h>
#include <Foundation/NSCharacterSet.h>
#include <Foundation/NSData.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSDictionary.h>
#include <Foundation/NSValue.h>
// For the encoding functions
#include <GNUstepBase/Unicode.h>

#include <AppKit/NSBezierPath.h>
#include "headless/HLFontInfo.h"

#define id _gs_avoid_id_collision
#include <fontconfig/fontconfig.h>
#undef id

#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_GLYPH_H
#include FT_OUTLINE_H

@implementation GSHLFaceInfo
@end

@implementation GSXftFontEnumerator
+ (Class) 
    faceInfoClass
{
  return [GSXftFaceInfo class];
}
+ (GSXftFaceInfo *) 
    fontWithName: (NSString *) name
{
  return (GSXftFaceInfo *) [super fontWithName: name];
}
@end

@interface GSHLFontInfo (Private)

- (BOOL) setupAttributes;
- (HLlyphInfo *)HLlyphInfo: (NSGlyph) glyph;

@end

@implementation GSHLFontInfo

-(instancetype)
  initWithFontName:(NSString*)nfontName
  matrix:(const CGFloat *)fmatrix
  screenFont:(BOOL)screenFont
{
  self = [super init];
  
  if (self) {
  
  }
  
  return self;
}

-(void)
   set
{
  NSLog(@"Calling `-set` on GTKFontInfo. Does nothing.");
}


 -(void)
   appendBezierPathWithGlyphs: (NSGlyph *)glyphs
   count: (int)count
   toBezierPath: (NSBezierPath *)path
 {
  NSLog(@"Calling `-appendBezierPathWithGlyphs:count:toBezierPath` on GTKFontInfo. Does nothing.");
 }


- (void) 
  dealloc
{
  [super dealloc];
}

- (CGFloat) 
    widthOfString: (NSString*)string
{
    return 0.0;
}

- (CGFloat) 
    widthOfGlyphs: (const NSGlyph *) glyphs 
    length: (int) len
{
    return 0.0;
}

- (NSMultibyteGlyphPacking)
  glyphPacking
{
  return NSTwoByteGlyphPacking;
}

- (NSSize) 
    advancementForGlyph: (NSGlyph)glyph
{
    return NSMakeSize(0.0, 0.0);
}

- (NSRect) 
    boundingRectForGlyph: (NSGlyph)glyph
{
    return NSMakeRect(0.0, 0.0, 0.0, 0.0);
}

- (BOOL) 
    glyphIsEncoded: (NSGlyph)glyph
{
    return NO;
}

- (NSGlyph) glyphWithName: (NSString*)glyphName
{
    return 0;
}

- (NSPoint) 
    positionOfGlyph: (NSGlyph)curGlyph
    precededByGlyph: (NSGlyph)prevGlyph
    isNominal: (BOOL*)nominal
{
    return NSZeroPoint;
}

/*
- (CGFloat) pointSize
{
  Display	*xdpy = [HLServer xDisplay];

  return HLFontPointSize(xdpy, font_info);
}
*/

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
    drawGlyphs: (const NSGlyph *) glyphs 
    length: (int) len
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

- (CGFloat) 
    widthOf: (const char*) s 
    length: (int) len
{
    return 0.0;
}


- (void) 
    setActiveFor: (Display*) xdpy 
    gc: (GC) HLcntxt
{
}

static int 
    bezierpath_move_to(const FT_Vector *to, void *user)
{
  return 0;
}

static int 
    bezierpath_line_to(const FT_Vector *to, void *user)
{
  return 0;
}

static int 
    bezierpath_conic_to(const FT_Vector *c1, const FT_Vector *to, void *user)
{
  return 0;
}

static int 
    bezierpath_cubic_to(
        const FT_Vector *c1, 
        const FT_Vector *c2, 
        const FT_Vector *to, 
        void *user)
{  
  return 0;
}

static FT_Outline_Funcs bezierpath_funcs = {
  move_to: bezierpath_move_to,
  line_to: bezierpath_line_to,
  conic_to: bezierpath_conic_to,
  cubic_to: bezierpath_cubic_to,
  shift: 10,
//  delta: 0,
};

- (void) 
    appendBezierPathWithGlyphs: (NSGlyph *)glyphs
    count: (int)count
    toBezierPath: (NSBezierPath *)path
{
    ;
}

@end

@implementation GSHLFontInfo (Private)

- (BOOL) 
    setupAttributes
{
    return YES;
}

- (HLlyphInfo *)
    HLlyphInfo: (NSGlyph) glyph
{
  static HLlyphInfo glyphInfo;

  XftTextExtents32 ([HLServer xDisplay],
                    (XftFont *)font_info,
                    &glyph,
                    1,
                    &glyphInfo);

  return &glyphInfo;
}

@end
