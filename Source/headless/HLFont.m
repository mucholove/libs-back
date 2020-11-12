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


@implementation HLFontInfo


- (id)
    initWithFontName: (NSString*)name
    matrix: (const CGFloat*)fmatrix
	  screenFont: (BOOL)screenFont
{
  self = [super init];

  return self;
}

- (void) 
    dealloc
{
  [super dealloc];
}

- (NSMultibyteGlyphPacking)
    glyphPacking
{
    return NSOneByteGlyphPacking;
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
    return 0;
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


@end

@implementation HLFontInfo (Private)

- (BOOL) 
    setupAttributes
{
    return YES;
}

@end
