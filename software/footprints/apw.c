/* KiCAD footprint generator for APW9328 PLCC plugs.
 * And maybe other stuff in the future.
 * GPL-2
 * (C) 2021 Stefan Reinauer <stefan.reinauer@coreboot.org>
 */

#include <stdio.h>
#include <float.h>

// From the datasheet:
// TODO add the other components
#define COMPONENT_NAME "APW9328"
#define COMPONENT_PINS 84
#define COMPONENT_PINS_X 21
#define COMPONENT_PINS_Y 21
#define COMPONENT_PITCH 1.27
#define COMPONENT_A 36.6
#define COMPONENT_B 27.5
#define COMPONENT_C 36.6
#define COMPONENT_D 27.5
#define COMPONENT_PAD_WIDTH 0.9

// Your preference

// Pad placement
// 0: Pads only on one layer
// 1: Pads on front and back layer, connected together with a via
#define COMPONENT_THROUGHHOLE 1

// Via placement
// 0: Via on the inside of the footprint
// 1: Via on the outside of the footprint
#define COMPONENT_VIA_OUTSIDE 1

// Pin numbering:
//
//           1 ->
//    +------*------\
//    |             |
//    |             |
//    |             |
//    |             |
//    |             |
//    +-------------+
//
// 84pin:
//   75 .. 84 1 .. 11 (top)
//   12 .. 32 (right)
//   33 .. 53 (bottom)
//   54 .. 74 (left)

static void kicad_mod_header(void)
{
	printf ("(footprint \"%s\" (version 20210228) (generator pcbnew) (layer \"F.Cu\")\n"
		"  (tedit 60690F97)\n"
  		"  (descr \"PLCC plug, %d pins, surface mount\")\n"
		"  (tags \"plcc smt\")\n"
		"  (autoplace_cost180 1)\n"
  		"  (attr smd)\n", COMPONENT_NAME, COMPONENT_PINS);
}

static void kicad_mod_timestamp(void)
{
	/* A lot of files I worked with had a zero timestamp, although
	 * my copy of KiCAD 6.0rc1 added timestamps for some pads. Not
	 * sure what these are actually good for. Let's assume zero is
	 * sufficient */
	printf ("    (tstamp 00000000-0000-0000-0000-000000000000)\n");
}

static void kicad_mod_texts(double height)
{
	double font_height=1;
	double offset=(height / 2) + font_height;

	printf("  (fp_text reference \"IC2\" (at 0 %.3f -180) (layer \"F.SilkS\")\n"
		"    (effects (font (size %.3f %.3f) (thickness 0.15)))\n",
		-offset, font_height, font_height);
	kicad_mod_timestamp();
	printf("  )\n");


	printf("  (fp_text value \"%s\" (at 0 %.3f -180) (layer \"F.Fab\")\n"
		"    (effects (font (size %.3f %.3f) (thickness 0.15)))\n",
		COMPONENT_NAME, offset + .5, font_height, font_height);
	kicad_mod_timestamp();
	printf("  )\n");

	printf("  (fp_text user \"${REFERENCE}\" (at 0 0.525 -180) (layer \"F.Fab\")\n"
		"    (effects (font (size %.3f %.3f) (thickness 0.15)))\n",
		font_height, font_height);
	kicad_mod_timestamp();
	printf("  )\n");
}

static void kicad_mod_silkscreen(char *silkscreen)
{
	double ox, oy, top_height;
	ox = COMPONENT_A / 2;
	oy = COMPONENT_C / 2;
	top_height = -oy;

	//     x1/y1  x2/y2
	//	+------+
	//      |      |
	//      |      |
	//	+------+
	//     x4/y4  x3/y3

	double x1,x2,x3,x4;
	double y1,y2,y3,y4;

	//x1 = -18.15; y1 = -17.625;
	//x2 = 18.15; y2 = -17.625;
	x1 = -18.5; y1 = -18.5;
	x2 = 18.5; y2 = -18.5;
	x3 = 18.5; y3 = 18.5;
	x4 = -18.5; y4 = 18.5;

  	// right line
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x2, y2 + 1, x3, y3, silkscreen);
	// left line
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x4, y4, x1, y1, silkscreen);
  	// bottom line
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x3, y3, x4, y4, silkscreen);

  // \ <--
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x2-1,y2,x2,y2+1, silkscreen);
  // top line left of 1
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", x1, y1, -1.0, y1, silkscreen);
  // top line right of 1
	printf("  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"%s\") (width 0.12) (tstamp 00000000-0000-0000-0000-000000000000))\n", 1.0, y1, x2-1, y2, silkscreen);
#if 1
	// FIXME This needs to be done dynamically

  // right horiz edge top
	printf("  (fp_line (start 13.675 -14.8) (end 14.175 -14.8) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);

  // \ <--
	printf("  (fp_line (start 14.175 -14.8) (end 15.325 -13.65) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left horiz edge top
	printf("  (fp_line (start -13.675 -14.8) (end -15.325 -14.8) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // right vert edge top
	printf("  (fp_line (start 15.325 -13.65) (end 15.325 -13.15) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // right vert line bottom
	printf("  (fp_line (start 15.325 15.85) (end 15.325 14.2) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left hor line bottom
	printf("  (fp_line (start -13.675 15.85) (end -15.325 15.85) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left vert line bottom
	printf("  (fp_line (start -15.325 15.85) (end -15.325 14.2) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // left vert line top
	printf("  (fp_line (start -15.325 -14.8) (end -15.325 -13.15) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
  // right vert line bottom
	printf("  (fp_line (start 13.675 15.85) (end 15.325 15.85) (layer \"%s\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n", silkscreen);
#endif
}


/* Draw CrtYd */
// FIXME front layer only
static void kicad_mod_courtyard(void)
{
	double ox, oy;
	ox = COMPONENT_A / 2;
	oy = COMPONENT_C / 2;
	printf(
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  	"  (fp_line (start %.3f %.3f) (end %.3f %.3f) (layer \"F.CrtYd\") (width 0.05) (tstamp 00000000-0000-0000-0000-000000000000))\n",
  	-ox, -oy,  ox, -oy,
  	-ox,  oy, -ox, -oy,
  	 ox,  oy, -ox,  oy,
  	 ox, -oy,  ox,  oy);
}

/* Draw Fab layer */
// FIXME front layer only
static void kicad_mod_fabrication(void)
{
	printf(
  "  (fp_line (start -18 -17.475) (end 17 -17.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 18 18.525) (end -18 18.525) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 18 -16.475) (end 18 18.525) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -18 18.525) (end -18 -17.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 17 -17.475) (end 18 -16.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -16.73 -16.205) (end 16.73 -16.205) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -16.73 17.255) (end -16.73 -16.205) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 15.175 15.7) (end -15.175 15.7) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -15.175 15.7) (end -15.175 -14.65) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start -15.175 -14.65) (end 14.175 -14.65) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 15.175 -13.65) (end 15.175 15.7) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 16.73 17.255) (end -16.73 17.255) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 0 -16.475) (end -0.5 -17.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 0.5 -17.475) (end 0 -16.475) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 16.73 -16.205) (end 16.73 17.255) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n"
  "  (fp_line (start 14.175 -14.65) (end 15.175 -13.65) (layer \"F.Fab\") (width 0.1) (tstamp 00000000-0000-0000-0000-000000000000))\n");
}

/* 3d component selection */
// TODO create real 3d model for the plugs
static void kicad_mod_model(void)
{
	printf ("(model \"${KISYS3DMOD}/Package_LCC.3dshapes/PLCC-%d_SMD-Socket.wrl\"\n"
		"    (offset (xyz 0 0 0))\n"
		"    (scale (xyz 1 1 1))\n"
		"    (rotate (xyz 0 0 0))\n"
		"  )\n", COMPONENT_PINS);
}

static void kicad_mod_footer(void)
{
	printf(")\n");
}

// APW 9328 - 84pin --
//   A    B    C    D
//  36.6 27.5 36.6 27.6
static void pad(int n, double px, double py, double sx, double sy, int th)
{
	if (th) {
		/* Calculate drill hole offset for throughole pads */
		double ox, oy;
		if (sx > sy) {
			if (px < 0) {
				ox=2; oy=0;
			} else {
				ox=-2; oy=0;
			}
		} else {
			if (py < 0) {
				ox=0; oy=2;
			} else {
				ox=0; oy=-2;
			}
		}
		if (COMPONENT_VIA_OUTSIDE == 0) {
			ox *= -1;
			oy *= -1;
		}
		printf ("  (pad \"%d\" thru_hole rect (at %.3f %.3f) (locked) (size %.3f %.3f) ",
				n, px-ox, py-oy, sx, sy);
		printf ("(drill 0.3 (offset %.3f %.3f)) ", ox, oy);
		printf ("(layers \"*.Cu\" \"*.Mask\") ");
	} else {
		printf ("  (pad \"%d\" smd rect (at %.3f %.3f) (locked) (size %.3f %.3f) ",
			n, px, py, sx, sy);
		printf ("(layers \"F.Cu\" \"F.Paste\" \"F.Mask\") ");
	}
	printf ("(tstamp 00000000-0000-0000-0000-000000000000)");
	printf (")\n");
}

static void kicad_mod_pads(int throughhole)
{
	int i;

	double pitch = COMPONENT_PITCH;

	double a = COMPONENT_A;
	double b = COMPONENT_B;
	double c = COMPONENT_C;
	double d = COMPONENT_D;

	double pad_width = COMPONENT_PAD_WIDTH;
	double pad_length = (c - d) / 2;

	double pins_x = COMPONENT_PINS_X;
	double pins_y = COMPONENT_PINS_Y;
	double pins_width = pins_x * pitch;
	double pins_height = pins_y * pitch;

	double px, py, sx, sy;

	// top 1
	sx = pad_width; sy = pad_length;
	px = 0;
	py = -(c-pad_length)/2;
	for (i=1; i<= 11; i++) {
		pad(i, px, py, sx, sy, throughhole);
		px += pitch;
	}

	// right
	sx = pad_length; sy = pad_width;
	px = (a-pad_length)/2;
	py = -(pins_height- pitch)/2;
	for (i=12; i<= 32; i++) {
		pad(i, px, py, sx, sy, throughhole);
		py += pitch;
	}

	// bottom
	sx = pad_width; sy = pad_length;
	px = (pins_width-pitch)/2;
	py = (c-pad_length) /2;
	for (i=33; i<= 53; i++) {
		pad(i, px, py, sx, sy, throughhole);
		px -= pitch;
	}

	// left
	sx = pad_length; sy = pad_width;
	px = -(a-pad_length)/2;
	py = (pins_height-pitch) /2;
	for (i=54; i<= 74; i++) {
		pad(i, px, py, sx, sy, throughhole);
		py -= pitch;
	}

	// top2
	sx = pad_width; sy = pad_length;
	px = -(pins_width-pitch)/2;
	py = -(c-pad_length)/2;
	for (i=75; i<= 84; i++) {
		pad(i, px, py, sx, sy, throughhole);
		px += pitch;
	}
}

int main(void)
{
	kicad_mod_header();

	kicad_mod_texts(COMPONENT_A);
	kicad_mod_silkscreen("F.SilkS");
	kicad_mod_silkscreen("B.SilkS");
	kicad_mod_courtyard();
	kicad_mod_fabrication();
	kicad_mod_pads(COMPONENT_THROUGHHOLE);
	// FIXME probably not needed because there is no
	// correct 3d model for this.
	kicad_mod_model();

	kicad_mod_footer();
	return 0;
}

