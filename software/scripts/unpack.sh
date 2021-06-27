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

printf " * Unpacking AmigaOS 3.2 ..."
mkdir -p $BUILD/AmigaOS-3.2
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

#rm -rf hrtmon
printf " * Unzipping hrtmodule238 ..."
lha xf $ARCHIVES/hrtmon238.lha > /dev/null
printf " ok\n"

#rm -rf vasm
printf " * Unpacking vasm ..."
tar xzf $ARCHIVES/vasm.tar.gz
printf " ok\n"

#rm -rf rnc_propack_source
printf " * Unpacking rnc_propack_source ..."
unzip -qqo $ARCHIVES/rnc_propack_source.zip
#mv rnc_propack_source-master rnc_propack_source
printf " ok\n"

# Modules
for MOD in $PWD/../modules/*; do
	$MOD unpack
done

cd ..

