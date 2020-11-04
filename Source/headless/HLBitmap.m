/*
   XGBitmapImageRep.m

   NSBitmapImageRep for GNUstep GUI X/GPS Backend

   Copyright (C) 1996-1999 Free Software Foundation, Inc.

   Author:  Adam Fedor <fedor@colorado.edu>
   Author:  Scott Christley <scottc@net-community.com>
   Date: Feb 1996
   Author:  Felipe A. Rodriguez <far@ix.netcom.com>
   Date: May 1998
   Author:  Richard Frith-Macdonald <richard@brainstorm.co.uk>
   Date: Mar 1999

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
#include <stdlib.h>

// #include <X11/Xlib.h>
// #include <X11/Xutil.h>

#include <Foundation/NSData.h>
#include <Foundation/NSDebug.h>
#include "gsc/gscolors.h"
// #include "xlib/XGPrivate.h"

/* Macros that make it easier to convert
   between (r,g,b) <--> pixels.
*/

#define VARIABLES_DECLARATION \
        unsigned char _rshift, _gshift, _bshift, _ashift; \
        unsigned int  _rmask,  _gmask,  _bmask,  _amask; \
        unsigned char _rwidth, _gwidth, _bwidth, _awidth



#define InitRGBShiftsAndMasks(rs,rw,gs,gw,bs,bw,as,aw) \
     do { \
	_rshift = (rs);              \
	_rmask  = (1<<(rw)) -1;      \
	_rwidth = (rw);              \
	_gshift = (gs);              \
	_gmask  = (1<<(gw)) -1;      \
	_gwidth = (gw);              \
	_bshift = (bs);              \
	_bmask  = (1<<(bw)) -1;      \
	_bwidth = (bw);              \
	_amask  = (1<<(aw)) -1;      \
	_ashift = (as);              \
	_awidth = (aw);              \
       } while (0)


#define PixelToRGB(pixel,r,g,b)  \
     do { \
	(r) = (pixel >> _rshift) & _rmask; \
	(g) = (pixel >> _gshift) & _gmask; \
	(b) = (pixel >> _bshift) & _bmask; \
        } while (0)

/* Note that RGBToPixel assumes that the
   r,g,b values are in the correct domain.
   If not, the value is nonsense.
*/

#define RGBToPixel(r,g,b, pixel) \
     do { \
        pixel = ((r) << _rshift)  \
               |((g) << _gshift)  \
               |((b) << _bshift); \
        } while (0)

#define CLAMP(a) \
    do { \
	(a) = MAX(0, MIN(255, (a))); \
    } while (0)

#define CSIZE 16384
#define GS_QUERY_COLOR(color)					\
  do {								\
    int centry = color.pixel % CSIZE;				\
    if (empty[centry] == NO && pixels[centry] == color.pixel)	\
      {								\
	color = colors[centry];					\
      }								\
    else							\
      {								\
	empty[centry] = NO;					\
	XQueryColor(context->dpy, context->cmap, &color);	\
	pixels[centry] = color.pixel;				\
	colors[centry] = color;					\
      }								\
  } while (0)

/* Composite source image (pixmap) onto a destination image with alpha.
   Only works for op=Sover now

   Assumptions:
    - all images are valid.
    - srect is completely contained in the source images
    - srect put at the origin is contained in the destination image
*/
int
_pixmap_combine_alpha(RContext *context,
                      RXImage *source_im, RXImage *source_alpha,
                      RXImage *dest_im, RXImage *dest_alpha,
                      XRectangle srect,
                      NSCompositingOperation op,
                      XGDrawMechanism drawMechanism,
		      float fraction)
{
  return 0;
}

/*
 * The following structure holds the information necessary for unpacking
 * a bitmap data object. It holds an index into the raw data, precalculated
 * spans for magnification and minifaction, plus the buffer which holds
 * a complete line of colour to be output to the screen in RGBA form.
 */

struct _bitmap_decompose {
};

/*
 * Here we extract a value a given number of bits wide from a bit
 * offset into a block of memory starting at "base". The bit numbering
 * is assumed to be such that a bit offset of zero and a width of 4 gives
 * the upper 4 bits of the first byte, *not* the lower 4 bits. We do allow
 * the value to cross a byte boundary, though it is unclear as to whether
 * this is strictly necessary for OpenStep tiffs.
 */

static int
    _get_bit_value(unsigned char *base, long msb_off, int bit_width)
{
}

/*
 * Extract a single pixel from a row. We are passed addresses for the red,
 * green, blue and alpha components, along with the column number and all the
 * necessary information to access the raw data. This function is responsible
 * for extracting the raw data and converting it to 8 bit RGB for return so
 * as to present a unified interface to the higher functions.
 */

static void
    _get_image_pixel(
        int col, unsigned char *r, unsigned char *g,
	      unsigned char *b, unsigned char *a,
	      unsigned char **planes, unsigned int *bit_off,
	      int spp, int bpp, int bps,
	      int pro_mul, int cspace, BOOL has_alpha, BOOL one_is_black)
{
}

/*
 * Main image decomposing function. This function creates the next row
 * in the image that needs to be output to the screen. For direct packed
 * images it simply copies the data directly, for all others it runs through
 * a set of loops pulling out image values and forming the avregae colour in 8
 * it RGB for that particular screen pixel from the underlying image pixels,
 * no matter what format they are in.
 */

static void
    _create_image_row(struct _bitmap_decompose *img)
{
}

/*
 * Set the ranges covered by a pixel within the image. Given the source
 * number of pixels and the destination number of pixels we calculate which
 * pixels in the source are more than 50% overlapped by each pixel in the
 * destination and record the start and end of the range. For mappings where
 * the source is being magnified this will only be a single pixel, for others
 * it may be one or more pixels, spaced evenly along the line. These are
 * the pixels which will then be averaged to make the best guess colour for
 * the destination pixel. As this is a slow process then a flag is passed in
 * which will cause the nearest pixel alorithm that is used for magnification
 * to be applied to minificationas well. The result looks rougher, but is much
 * faster and proprtional to the size of the output rather than the input
 * image.
 */

static void
      _set_ranges(
          long src_len,
          long dst_len,
		      unsigned int *start_ptr, 
          unsigned int *end_ptr, 
          BOOL fast_min)
{
}

/*
 * Combine the image data with the currentonscreen data and push the
 * result back to the screen. The screen handling code is almost identical
 * to the original code. The function assumes that the displayable rectangle
 * is always a subset of the complete screen rectangle which is the area
 * in pixels that would be covered by the entire image. This is used to 
 * calculate the scaling required.
 */

int
_bitmap_combine_alpha(RContext *context,
		unsigned char * data_planes[5],
		int width, int height,
		int bits_per_sample, int samples_per_pixel,
		int bits_per_pixel, int bytes_per_row,
		int colour_space, BOOL one_is_black,
		BOOL is_planar, BOOL has_alpha, BOOL fast_min,
		RXImage *dest_im, RXImage *dest_alpha,
		XRectangle srect, XRectangle drect,
		NSCompositingOperation op,
		XGDrawMechanism drawMechanism)
{
}

NSData * 
    _pixmap_read_alpha(
       RContext *context,
		   RXImage *source_im, 
      RXImage *source_alpha,
		   XRectangle srect,
		   XGDrawMechanism drawMechanism)
{  
  unsigned long  pixel;
  NSMutableData *data;
  unsigned char *bytes;
  int spp;

  spp = (source_alpha) ? 4 : 3;
  data = [NSMutableData dataWithLength: srect.width*srect.height*spp];
  if (data == nil)
    return nil;
  bytes = [data mutableBytes];

  if (drawMechanism == XGDM_FAST15
      || drawMechanism == XGDM_FAST16
      || drawMechanism == XGDM_FAST32
      || drawMechanism == XGDM_FAST32_BGR
      || drawMechanism == XGDM_FAST8)
    {
      VARIABLES_DECLARATION;
      unsigned	row;

      switch (drawMechanism)
	{
	case XGDM_FAST15:
	  InitRGBShiftsAndMasks(10,5,5,5,0,5,0,8);
	  break;
	case XGDM_FAST16:
	  InitRGBShiftsAndMasks(11,5,5,6,0,5,0,8);
	  break;
	case XGDM_FAST32:
	  InitRGBShiftsAndMasks(16,8,8,8,0,8,0,8);
	  break;
	case XGDM_FAST32_BGR:
	  InitRGBShiftsAndMasks(0,8,8,8,16,8,0,8);
	  break;
	case XGDM_FAST8:
	  InitRGBShiftsAndMasks(5,3,2,3,0,2,0,8);
	  break;
	default:
	  NSLog(@"Huh? Backend confused about XGDrawMechanism");
	  //Try something.  With a bit of luck we see
	  //which picture goes wrong.
	  InitRGBShiftsAndMasks(11,5,5,6,0,5,0,8);
	}

      for (row = 0; row < srect.height; row++)
	{
	  unsigned	col;

	  for (col = 0; col < srect.width; col++)
	    {
	      unsigned	sr, sg, sb, sa;

	      // Get the source pixel information
	      pixel = XGetPixel(source_im->image, col, row);
	      PixelToRGB(pixel, sr, sg, sb);
	      // Expand to 8 bit value
	      sr = (sr << (8-_rwidth));
	      sg = (sg << (8-_gwidth));
	      sb = (sb << (8-_bwidth));

	      if (source_alpha)
		{
		  pixel = XGetPixel(source_alpha->image, col, row);
		  sa = (pixel >> _ashift) & _amask;
		}
	      else
		sa = _amask;

	      bytes[(row * srect.width + col)*spp]   = sr;
	      bytes[(row * srect.width + col)*spp+1] = sg;
	      bytes[(row * srect.width + col)*spp+2] = sb;
	      if (source_alpha)
		bytes[(row * srect.width + col)*spp+3] = sa;
	    }
	}
    }
  else
    {
      unsigned row;
      unsigned long pixels[CSIZE];
      XColor colors[CSIZE];
      BOOL empty[CSIZE];
      int cind;
      
      for (cind = 0; cind < CSIZE; cind++)
	{
	  empty[cind] = YES;
	}

      /*
       * This block of code should be totally portable as it uses the
       * 'official' X mechanism for converting from pixel values to
       * RGB color values - on the downside, it's very slow.
       */
      pixel = (unsigned long)-1;	// Never valid?

      for (row = 0; row < srect.height; row++)
	{
	  unsigned	col;

	  for (col = 0; col < srect.width; col++)
	    {
	      int r, g, b, alpha;
	      XColor pcolor, acolor;
	      pcolor.pixel = XGetPixel(source_im->image, col, row);
	      GS_QUERY_COLOR(pcolor);
	      r = pcolor.red >> 8;
	      g = pcolor.green >> 8;
	      b = pcolor.blue >> 8;
	      alpha = 255;
	      if (source_alpha)
		{
		  acolor.pixel = XGetPixel(source_alpha->image, col, row);
		  GS_QUERY_COLOR(acolor);
		  alpha = acolor.red >> 8;
		}

	      bytes[(row * srect.width + col)*spp]   = r;
	      bytes[(row * srect.width + col)*spp+1] = g;
	      bytes[(row * srect.width + col)*spp+2] = b;
	      if (source_alpha)
		bytes[(row * srect.width + col)*spp+3] = alpha;
	    }
	}
    }

  return (NSData *)data;
}

