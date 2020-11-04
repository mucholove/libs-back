/*
   HLFontManager.m

   NSFontManager helper for GNUstep GUI X/GPS Backend

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author: Ovidiu Predescu <ovidiu@bx.logicnet.ro>
   Date: February 1997
   A completely rewritten version of the original source of Scott Christley.
   Modified:  Fred Kiefer <FredKiefer@gmx.de>
   Date: Febuary 2000
   Added some X calls and changed the overall structure
 
   This file is part of the GNUstep GUI X/GPS Library.

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
#include <stdio.h>

#include <GNUstepGUI/GSFontInfo.h>
#include <Foundation/NSArchiver.h>
#include <Foundation/NSBundle.h>
#include <Foundation/NSException.h>
#include <Foundation/NSFileManager.h>
#include <Foundation/NSPathUtilities.h>
#include <Foundation/NSProcessInfo.h>
#include <Foundation/NSTask.h>
#include <Foundation/NSValue.h>
#include "headless/HLContext.h"
#include "headless/HLPrivate.h"
#include "headless/HLServer.h"

#define stringify_it(X) #X

@interface NSBundle (Private)
// Maybe we should rather use -pathForAuxiliaryExecutable:?
+ (NSString *) _absolutePathOfExecutable: (NSString *)path;
@end

static NSMutableDictionary* creationDictionary;

// Fills in the size into an creation string to make it an X font name
NSString *HLXFontName(NSString *fontName, float size)
{
  NSString *creationName = [creationDictionary objectForKey: fontName];

  if (creationName != nil)
    return [NSString stringWithFormat: creationName, (int)size];
  else
    return nil;
}

@implementation HLFontEnumerator



- (NSString *)
    defaultSystemFontName
{
    return @"HLSystemFont";
}
- (NSString *)
    defaultBoldSystemFontName
{
    return @"HLSystemFont";
}
- (NSString *)
    defaultFixedPitchFontName
{
    return @"HLSystemFont";
}

- (void) 
  enumerateFontsAndFamilies
{
  // This method has to set up the ivars allFontNames and allFontFamilies
  // [self subclassResponsibility: _cmd];
  // ASSIGN(allFontNames,       @[]);
  // ASSIGN(allFontFamilies,     [NSMutableDictionary dictionary]);
  // ASSIGN(allFontDescriptors, @[]);
  NSArray *toBeAllFontNames = [NSArray arrayWithArray:@[
        @"HLSystemFont",
  ]];
  
  NSArray *toBeAllFamilies = [NSMutableDictionary dictionaryWithDictionary:@{
        @"HLSystemFont": @"HLSystemFont",
  }];
  
  [toBeAllFontNames retain];
  [toBeAllFamilies retain];
  
  allFontNames       = toBeAllFontNames;
  allFontFamilies    = toBeAllFamilies;
  // allFontDescriptors = [@[] retain];
}

/*
 GSFontEnumerator *e = [GSFontEnumerator sharedEnumerator];

 font_roles[RoleSystemFont].defaultFont         = [e defaultSystemFontName];
 font_roles[RoleBoldSystemFont].defaultFont     = [e defaultBoldSystemFontName];
 font_roles[RoleUserFixedPitchFont].defaultFont = [e defaultFixedPitchFontName];
 */


@end
