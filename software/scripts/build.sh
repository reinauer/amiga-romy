#!/bin/bash
#
# This script assembles the final 1MB Kickstart image
#
#  (C) 2021 Stefan Reinauer
#
set -e

# This script needs the latest github version of amitools
# (with https://github.com/cnvogelg/amitools/pull/154 merged)

BUILD=$PWD/build
cd $BUILD

#VERSION=46.160
VERSION=46.143

AMIGA=$1
case "$1" in
  A1200)
    FILES=AmigaOS-3.1.4-A1200
    KICKFILE=kick.a1200.${VERSION}
    KICKDIR=${VERSION}_Hyperion\(A1200*\)
    ;;

  A3000)
    FILES=AmigaOS-3.1.4-A3000
    KICKFILE=kick.a3000.${VERSION}
    KICKDIR=${VERSION}_Hyperion\(A3000*\)
    ;;

  A4000T)
    FILES=AmigaOS-3.1.4-A4000T
    KICKFILE=kick.a4000t.${VERSION}
    KICKDIR=${VERSION}_Hyperion\(A4000T*\)
    ;;

  A500) ;&
  A600) ;&
  A2000) ;&
  A500/A600/A2000)
    AMIGA=A500/A600/A2000
    FILES=AmigaOS-3.1.4-A500
    KICKFILE=kick.a500.${VERSION}
    KICKDIR=${VERSION}_Hyperion\(A500-A2000*\)
    ;;

  A4000) ;&
  *)
    AMIGA=A4000
    FILES=AmigaOS-3.1.4-A4000
    KICKFILE=kick.a4000.${VERSION}
    KICKDIR=${VERSION}_Hyperion\(A4000*\)
    ;;

esac

if [ ! -r files ]; then
  echo "Creating symlink for $FILES to files"
  ln -s $FILES files
fi

DEST=$PWD/files

#
# Define list of additional modules
#
MODULES=
MODULES="$MODULES hrtmodule"
if [ $VERSION == 46.143 -o $VERSION == 46.160 ]; then
  MODULES="$MODULES $DEST/Install3_1_4/Libs/icon.library"
  MODULES="$MODULES $DEST/Install3_1_4/Libs/workbench.library"
fi
HAVE_TF1260=0
if [ $AMIGA == A1200 -a $HAVE_TF1260 == 1 ]; then
  MODULES="$MODULES ehide.device"
fi

#
# Updating the main rom
#

case "$VERSION" in
  46.143)
    NEWREV=46.144
    NEWKICK=$( echo kick.$AMIGA.$NEWREV | tr "A-Z" "a-z" |sed s,/,.,g)

    romtool -q split $DEST/ROMs/unsplit_unswapped/$KICKFILE -o .

    # These different revisions are a mess. Hack alert.
    mv $KICKDIR $NEWREV
    KICKDIR=$NEWREV

    zcat $DEST/Update3.1.4.1/DEVS/audio.device.Z > $KICKDIR/audio.device_45.18
    zcat $DEST/Update3.1.4.1/L/FastFileSystem.Z > $KICKDIR/filesystem_46.20
    zcat $DEST/Update3.1.4.1/L/Shell-Seg.Z > $KICKDIR/shell_46.21
    zcat $DEST/Update3.1.4.1/LIBS/intuition-v45.library.Z > $KICKDIR/intuition.library_45.13

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
    ;;

  *)
    # For anything but 46.143 we currently don't know how to update the modules
    # in the main rom. Patches are welcome. Hence, for now, copy the ROM file
    # verbatim in this case.
    NEWREV=$VERSION
    NEWKICK=$( echo kick.$AMIGA.$NEWREV | tr "A-Z" "a-z" |sed s,/,.,g)
    cp $DEST/ROMs/unsplit_unswapped/$KICKFILE $NEWKICK-512kb
    ;;
esac

#
# Patching the main rom for 1MB support
#

# TODO: What does this look like for 4MB support?
# Now patch for 1MB. This will cause the Amiga to yellow screen without ROMY:
romtool -q patch -o $NEWKICK.rom $NEWKICK-512kb 1mb_rom

# Cleanup
if [ -x $KICKDIR ]; then
  rm -r $KICKDIR
fi

#
# Build the extended ROM image with additional modules
#

romtool -q build -o extension.rom -t ext -f -r $NEWREV $MODULES

romtool -q combine $NEWKICK.rom extension.rom -o $NEWKICK.1mb.rom

#
# Create programmable image
#

if [ "$AMIGA" == "A500/A600/A2000" ]; then
  srec_cat "$NEWKICK.1mb.rom" -binary -byteswap 2 -o $NEWKICK.1mb.bin -binary
  printf "Success! Now write build/$NEWKICK.1mb.bin to one 27C800 chip ($AMIGA).\n\n"
else
  srec_cat "$NEWKICK.1mb.rom" -binary -split 4 0 2 -byteswap 2 -o $NEWKICK.1mb.HI.bin -binary
  srec_cat "$NEWKICK.1mb.rom" -binary -split 4 2 2 -byteswap 2 -o $NEWKICK.1mb.LO.bin -binary
  printf "Success! Now write build/$NEWKICK.1mb.LO.bin and build/$NEWKICK.1mb.HI.bin to two 27C400 chips ($AMIGA).\n\n"
fi

cd ..

