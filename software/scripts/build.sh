#! /usr/bin/env bash
#
# This script assembles the final 1MB Kickstart image
#
#  (C) 2021 Stefan Reinauer
#
set -e

# This script needs the latest github version of amitools
# (with https://github.com/cnvogelg/amitools/pull/154 merged)

. $( dirname $0 )/functions.sh

BUILD=$PWD/build
cd $BUILD

AMIGA=$1

#VERSION=46.160
#VERSION=46.143
VERSION=$2
VERSION=${VERSION:-"47.96"}

# Lower case...
SIZE=`echo $3|tr "A-Z" "a-z"`
SIZE=${SIZE:-"1mb"}

case "$VERSION" in
  46.143) ;&
  46.160)
    FILES=AmigaOS-3.1.4
    case "$AMIGA" in
      A1200)
        KICKFILE=kick.a1200.${VERSION}
        KICKDIR=${VERSION}_Hyperion\(A1200*\)
        ;;

      A3000)
        KICKFILE=kick.a3000.${VERSION}
        KICKDIR=${VERSION}_Hyperion\(A3000*\)
        ;;

      A4000T)
        KICKFILE=kick.a4000t.${VERSION}
        KICKDIR=${VERSION}_Hyperion\(A4000T*\)
        ;;

      CDTV) ;&
      A500) ;&
      A600) ;&
      A1000) ;&
      A2000) ;&
      A500/A600/A2000)
        AMIGA=A500/A600/A2000
        KICKFILE=kick.a500.${VERSION}
        KICKDIR=${VERSION}_Hyperion\(A500-A2000*\)
        ;;

      A4000) ;&
      *)
        AMIGA=A4000
        KICKFILE=kick.a4000.${VERSION}
        KICKDIR=${VERSION}_Hyperion\(A4000*\)
        ;;

    esac
    ;;
  47.96)
    FILES=AmigaOS-3.2
    # KICKDIR isn't used yet for 3.2 so the values are wrong
    case "$AMIGA" in
      A1200)
        KICKFILE=kicka1200.rom
        KICKDIR=${VERSION}_Hyperion\(A1200*\)
        ;;

      A3000)
        KICKFILE=kicka3000.rom
        KICKDIR=${VERSION}_Hyperion\(A3000*\)
        ;;

      A4000T)
        KICKFILE=kicka4000t.rom
        KICKDIR=${VERSION}_Hyperion\(A4000T*\)
        ;;

      CDTV) ;&
      A500) ;&
      A600) ;&
      A1000) ;&
      A2000) ;&
      A500/A600/A2000) ;&
      CDTV/A500/A600/A1000/A2000)
        AMIGA=CDTV/A500/A600/A1000/A2000
        KICKFILE=kickcdtva1000a500a2000a600.rom
        KICKDIR=${VERSION}_Hyperion\(A500-A2000*\)
        ;;

      A4000) ;&
      *)
        AMIGA=A4000
        KICKFILE=kicka4000.rom
        KICKDIR=${VERSION}_Hyperion\(A4000*\)
        ;;
    esac
    ;;
  47.102)
    FILES=AmigaOS-3.2.1
    # KICKDIR isn't used yet for 3.2.1 so the values are wrong
    case "$AMIGA" in
      A1200)
        KICKFILE=${AMIGA}.${VERSION}.rom
        KICKDIR=${VERSION}_Hyperion\(A1200*\)
        ;;

      A3000)
        KICKFILE=${AMIGA}.${VERSION}.rom
        KICKDIR=${VERSION}_Hyperion\(A3000*\)
        ;;

      A4000T)
        KICKFILE=${AMIGA}.${VERSION}.rom
        KICKDIR=${VERSION}_Hyperion\(A4000T*\)
        ;;

      CDTV) ;&
      A500) ;&
      A600) ;&
      A1000) ;&
      A2000) ;&
      A500/A600/A2000) ;&
      CDTV/A500/A600/A1000/A2000)
        AMIGA=CDTV/A500/A600/A1000/A2000
        KICKFILE=CDTVA500A600A2000.${VERSION}.rom
        KICKDIR=${VERSION}_Hyperion\(A500-A2000*\)
        ;;

      A4000) ;&
      *)
        AMIGA=A4000
        KICKFILE=${AMIGA}.${VERSION}.rom
        KICKDIR=${VERSION}_Hyperion\(A4000*\)
        ;;
    esac
    ;;
esac
mkdir -p $VERSION

DEST=$PWD/$FILES

#
# Define list of additional modules
#
MODULES=
if [ $VERSION == 46.143 -o $VERSION == 46.160 ]; then
  MODULES="$MODULES $DEST/Install3_1_4/Libs/icon.library"
  MODULES="$MODULES $DEST/Install3_1_4/Libs/workbench.library"
fi

if [ $VERSION == 47.96 ]; then
  MODULES="$MODULES $DEST/Install3.2/Libs/icon.library"
  MODULES="$MODULES $DEST/Install3.2/Libs/workbench.library"
  #MODULES="$MODULES $DEST/Install3.2/L/CDFileSystem"
  MODULES="$MODULES $DEST/DiskDoctor/Devs/trackfile.device"
  # TODO option for old intuition.library?
fi

if [ $VERSION == 47.102 ]; then
  WD=$PWD
  zcat $DEST/Update3.2.1/L/CDFileSystem.Z > $DEST/Update3.2.1/L/CDFileSystem
  zcat $DEST/Update3.2.1/LIBS/workbench.library.Z > $DEST/Update3.2.1/LIBS/workbench.library
  zcat $DEST/Update3.2.1/LIBS/icon.library.Z > $DEST/Update3.2.1/LIBS/icon.library
  #MODULES="$MODULES $DEST/Update3.2.1/L/CDFileSystem"
  MODULES="$MODULES $DEST/Update3.2.1/LIBS/workbench.library"
  MODULES="$MODULES $DEST/Update3.2.1/LIBS/icon.library"
  MODULES="$MODULES $DEST/DiskDoctor/Devs/trackfile.device"
  # TODO option for old intuition.library?
fi


# Make Amiga type available to modules
export AMIGA

# Modules
for MOD in $PWD/../modules/*; do
	MODULES="$MODULES $($MOD build)"
done
debug "MODULES=$MODULES"

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
    romtool -q build -o $VERSION/$NEWKICK-512kb -t kick -s 512 -r $NEWREV $KICKDIR/index.txt
    ;;

  *)
    # For anything but 46.143 we currently don't know how to update the modules
    # in the main rom. Patches are welcome. Hence, for now, copy the ROM file
    # verbatim in this case.
    NEWREV=$VERSION
    NEWKICK=$( echo kick.$AMIGA.$NEWREV | tr "A-Z" "a-z" |sed s,/,.,g)
    cp $DEST/ROMs/unsplit_unswapped/$KICKFILE $VERSION/$NEWKICK-512kb
    ;;
esac

#
# Patching the main rom for 1MB support
#

# Now patch for larger size. This will cause the Amiga to yellow screen without ROMY:
PATCH=${SIZE}_rom
test $SIZE = "2mb" && PATCH=4mb_rom
romtool -q patch -o $VERSION/$NEWKICK.rom $VERSION/$NEWKICK-512kb ${PATCH}

# Cleanup
if [ -x $KICKDIR ]; then
  rm -r $KICKDIR
fi

#
# Build the extended ROM image with additional modules
#

test $SIZE = "1mb" && EXTSIZE=512
test $SIZE = "2mb" && EXTSIZE=1536
test $SIZE = "4mb" && EXTSIZE=3584

debug "romtool build -o $VERSION/extension.rom -t ext -s $EXTSIZE -f -r $NEWREV $MODULES"
romtool build -o $VERSION/extension.rom -t ext -s $EXTSIZE -f -r $NEWREV $MODULES

debug "romtool combine $VERSION/$NEWKICK.rom $VERSION/extension.rom -o $VERSION/$NEWKICK.$SIZE.rom"
romtool combine $VERSION/$NEWKICK.rom $VERSION/extension.rom -o $VERSION/$NEWKICK.$SIZE.rom

#
# Create programmable image
#

# FIXME A500 can not do 4MB
if [ "$AMIGA" == "A500/A600/A2000" -o "$AMIGA" = "CDTV/A500/A600/A1000/A2000" ]; then
  test $SIZE = "1mb" && CHIP="27C800"
  test $SIZE = "2mb" && CHIP="MX29F1615(unsupported)"
  test $SIZE = "4mb" && CHIP="29F320(unsupported)"

  srec_cat "$VERSION/$NEWKICK.$SIZE.rom" -binary -byteswap 2 -o $VERSION/$NEWKICK.$SIZE.bin -binary
  printf "Success! Now write build/$VERSION/$NEWKICK.$SIZE.bin to one $CHIP chip ($AMIGA).\n\n"
else
  test $SIZE = "1mb" && CHIP="27C400"
  test $SIZE = "2mb" && CHIP="27C800"
  test $SIZE = "4mb" && CHIP="27C160/MX29F1615"

  srec_cat "$VERSION/$NEWKICK.$SIZE.rom" -binary -split 4 0 2 -byteswap 2 -o $VERSION/$NEWKICK.$SIZE.HI.bin -binary
  srec_cat "$VERSION/$NEWKICK.$SIZE.rom" -binary -split 4 2 2 -byteswap 2 -o $VERSION/$NEWKICK.$SIZE.LO.bin -binary
  printf "Success! Now write build/$VERSION/$NEWKICK.$SIZE.LO.bin and build/$VERSION/$NEWKICK.$SIZE.HI.bin to two $CHIP chips ($AMIGA).\n\n"
fi

cd ..

