# Logic Files

## Overview

The jedec/ directory contains the logic files compiled from the source files
in source/: romst.pld for Revisions 10 and 11, romy.pld for Revision 12.

There are three different revisions of ROMY:

* Revision 10 is the recommended one for A3000 and A4000D.
* Revision 11 might fix issues with the NCR 710 on A4000T
* Revision 12 is meant for all of them, but has not been tested on hardware
  yet.

There are also different versions for 1MB and 4MB ROMYs.

All three revisions terminate a cycle on the same clock: with _SPEED high
(JP1 as shipped) STERM comes on the second CLK90 edge of the cycle and DSTERM
on the fourth, with _SPEED low on the first and third. They differ in what
happens afterwards:

* Revision 10 holds STERM and DSTERM for two clocks. A bus master that keeps
  _AS asserted a clock longer than the 68030, or starts its next cycle before
  CLK90 sees _AS negated, gets that next cycle terminated as well, whatever
  its address.
* Revision 11 makes each termination a single clock, but starts over while
  _AS stays asserted, even outside the ROM window, and its leftover state can
  still terminate a following cycle.
* Revision 12 terminates each cycle exactly once and holds the termination
  until _AS is negated, so the hold time is set by the bus master's own _AS
  timing rather than by how CLK90 is phased against the master's clock (the
  NCR 53C710 needs STERM held 7 ns past its sampling edge, which a one-clock
  pulse only gives if CLK90 lags its clock enough). It clears all state the
  moment _AS is negated (the 22V10's asynchronous reset), so nothing carries
  over into the next cycle, however briefly _AS goes high in between.

## Building

make compiles all variants with lincupl's native cupl:
jedec/romst_rev1{0,1}_{1,4}mb.jed from source/romst.pld, and
jedec/romy_rev12_{1,4}mb.jed from source/romy.pld. romst.pld takes ROMY_REV10
or ROMY_REV11 and ROMY_1MB or ROMY_4MB, romy.pld only the size.

    make LINCUPL=/path/to/cupl

## Simulation

source/simulation/romy_rev12_{1,4}mb.si hold csim test vectors for
source/romy.pld: reads and writes in and around the ROM window with each
jumper setting, power-up, Kickstart ROM accesses, _AS held past the
termination, and a cycle following without a clock in between. The expected
values come from the Revision 12 specification. With lincupl:

    make sim LINCUPL=/path/to/cupl CSIM=/path/to/csim

The listings end up in sim/romy_*.so.

Help / patches / improvements wanted.
