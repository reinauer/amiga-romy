#!/bin/bash
set -e

# This script needs https://github.com/cnvogelg/amitools/pull/154

BUILD=$PWD/build
cd $BUILD

AMIGA=$1
case "$1" in
  A1200)
    FILES=AmigaOS-3.1.4-A1200
    KICKFILE=kick.a1200.46.143
    #KICKDIR=46.143_Hyperion\(A1200_R2\)
    KICKDIR=46.143_Hyperion\(A1200\)
    ;;

  A3000)
    FILES=AmigaOS-3.1.4-A3000
    KICKFILE=kick.a3000.46.143
    #KICKDIR=46.143_Hyperion\(A3000_R2\)
    KICKDIR=46.143_Hyperion\(A3000\)
    ;;

  A4000T)
    FILES=AmigaOS-3.1.4-A4000T
    KICKFILE=kick.a4000t.46.143
    KICKDIR=46.143_Hyperion\(A4000T_R2\)
    ;;

  A500) ;&
  A600) ;&
  A2000) ;&
  A500/A600/A2000)
    AMIGA=A500/A600/A2000
    FILES=AmigaOS-3.1.4-A500
    KICKFILE=kick.a500.46.143
    KICKDIR=46.143_Hyperion\(A500-A2000_R2\)
    ;;

  A4000) ;&
  *)
    AMIGA=A4000
    FILES=AmigaOS-3.1.4-A4000
    KICKFILE=kick.a4000.46.143
    KICKDIR=46.143_Hyperion\(A4000_R2\)
    ;;

esac
FILES=AmigaOS-3.1.4-A4000
NEWREV=46.144
NEWKICK=$( echo kick.$AMIGA.$NEWREV | tr "A-Z" "a-z" |sed s,/,.,g)

romtool -q split $FILES/ROMs/unsplit_unswapped/$KICKFILE -o .

zcat $FILES/Update3.1.4.1/DEVS/audio.device.Z > $KICKDIR/audio.device_45.18
zcat $FILES/Update3.1.4.1/L/FastFileSystem.Z > $KICKDIR/filesystem_46.20
zcat $FILES/Update3.1.4.1/L/Shell-Seg.Z > $KICKDIR/shell_46.21
zcat $FILES/Update3.1.4.1/LIBS/intuition-v45.library.Z > $KICKDIR/intuition.library_45.13

perl -pi -e 's,audio.device_45.15,audio.device_45.18,' $KICKDIR/index.txt
perl -pi -e 's,filesystem_46.13,filesystem_46.20,' $KICKDIR/index.txt
perl -pi -e 's,shell_46.10,shell_46.21,' $KICKDIR/index.txt
perl -pi -e 's,intuition.library_40.87,intuition.library_45.13,' $KICKDIR/index.txt

rm $KICKDIR/audio.device_45.15
rm $KICKDIR/filesystem_46.13
rm $KICKDIR/shell_46.10
rm $KICKDIR/intuition.library_40.87

# This is a 512KB ROM that works without ROMY:
romtool -q build -o $NEWKICK-512kb -t kick -s 512 -r $NEWREV $KICKDIR/index.txt

# Now patch for 1MB. This will cause the Amiga to yellow screen without ROMY:
romtool -q patch -o $NEWKICK.rom $NEWKICK-512kb 1mb_rom

# Cleanup
rm -r $KICKDIR

romtool -q build -o extension.rom -t ext -f -r $NEWREV hrtmodule $FILES/Install3_1_4/Libs/icon.library $FILES/Install3_1_4/Libs/workbench.library

romtool -q combine $NEWKICK.rom extension.rom -o $NEWKICK.1mb.rom

if [ "$AMIGA" == "A500/A600/A2000" ]; then
  srec_cat "$NEWKICK.1mb.rom" -binary -byteswap 2 -o $NEWKICK.1mb.bin -binary
  printf "Write build/$NEWKICK.1mb.bin to one 27C800 chip (A500/A600/A2000).\n\n"
else
  srec_cat "$NEWKICK.1mb.rom" -binary -split 4 0 2 -byteswap 2 -o $NEWKICK.1mb.HI.bin -binary
  srec_cat "$NEWKICK.1mb.rom" -binary -split 4 2 2 -byteswap 2 -o $NEWKICK.1mb.LO.bin -binary
  printf "Write build/$NEWKICK.1mb.LO.bin and build/$NEWKICK.1mb.HI.bin to two 27C400 chips (A1200/A3000/A4000(T).\n"
fi

cd ..
printf "You made it! It is done!\n\n"

