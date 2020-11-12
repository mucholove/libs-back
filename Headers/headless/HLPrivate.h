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
}
@end


#endif


