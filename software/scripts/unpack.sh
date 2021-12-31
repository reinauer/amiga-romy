#!/bin/bash

BUILD=$PWD/build
ARCHIVES=$PWD/archives

mkdir -p $BUILD
. $( dirname $0 )/functions.sh

mkdir -p $BUILD/AmigaOS-3.1.4
mkdir -p $BUILD/AmigaOS-3.1.4/ROMs/unsplit_unswapped
unpack_AmigaOS314 archive
unpack_AmigaOS314 A1200
unpack_AmigaOS314 A3000
unpack_AmigaOS314 A4000
unpack_AmigaOS314 A4000T

cd $BUILD/AmigaOS-3.1.4

printf " * Unzipping AmigaOS 3.1.4.1 Update ..."
unzip -qqo $ARCHIVES/AmigaOS-3.1.4.1-Update.zip
if [ -r $ARCHIVES/kick_3.1.4.1.zip ]; then
  unzip -qqo $ARCHIVES/kick_3.1.4.1.zip
  rm roms/*.bin
  mv roms/* ROMs/unsplit_unswapped
  rm -r roms
fi
printf " ok\n"
unpack_adfs
cd ..

if [ -r $ARCHIVES/AmigaOS3.2CD.iso ]; then
  mkdir -p $BUILD/AmigaOS-3.2
  printf " * Unpacking AmigaOS 3.2 ..."
  sudo echo "Need root access"
  sudo mount $ARCHIVES/AmigaOS3.2CD.iso /mnt -oloop,ro -t iso9660
  mkdir -p $BUILD/AmigaOS-3.2/ROMs/unsplit_unswapped
  cp /mnt/rom/*.rom $BUILD/AmigaOS-3.2/ROMs/unsplit_unswapped
  cp /mnt/adf/install3.2.adf $BUILD/AmigaOS-3.2/
  cp /mnt/adf/diskdoctor.adf $BUILD/AmigaOS-3.2/
  chmod 644 $BUILD/AmigaOS-3.2/ROMs/unsplit_unswapped/*.rom
  chmod 644 $BUILD/AmigaOS-3.2/*.adf
  sudo umount /mnt
  cd $BUILD/AmigaOS-3.2/
  unpack_adfs
  cd ..
fi

if [ -r $ARCHIVES/Update3.2.1.lha ]; then
  printf " * Unpacking AmigaOS 3.2.1 Update ..."
  mkdir -p $BUILD/AmigaOS-3.2.1
  cd $BUILD/AmigaOS-3.2.1
  lha xq $ARCHIVES/Update3.2.1.lha
  mkdir -p $BUILD/AmigaOS-3.2.1/ROMs/unsplit_unswapped
  cp Update3.2.1/ROMs/*.rom $BUILD/AmigaOS-3.2.1/ROMs/unsplit_unswapped
  cp Update3.2.1/ADFs/Update3.2.1.adf $BUILD/AmigaOS-3.2.1/
  cp Update3.2.1/ADFs/DiskDoctor.adf $BUILD/AmigaOS-3.2.1/
  chmod 644 $BUILD/AmigaOS-3.2.1/ROMs/unsplit_unswapped/*.rom
  chmod 644 $BUILD/AmigaOS-3.2.1/*.adf
  printf " ok\n"
  unpack_adfs
  cd ..
fi

# Modules
for MOD in $PWD/../modules/*; do
	$MOD unpack
done

cd ..

