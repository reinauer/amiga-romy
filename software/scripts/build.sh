#!/bin/sh


# 3.1.4 rom looks like this for me:

# exec_46.45(A4000_R2)
# expansion_45.4(A4000)
# bonus_40.1(A4000-46.143)
# mathieeesingbas.lib_45.9
# scsi.device_45.7(A4000)
# audio.device_45.15
# battclock.resource_45.1
# battmem.res_39.2(46.143)
# bootmenu_45.6
# cia.resource_45.1
# con-handler_40.2(46.143)
# console.device_45.4
# disk.resource_37.2(46.143)
# dos.library_40.5
# filesystem.resource_46.1
# filesystem_46.13
# graphics.lib_45.27
# keymap.library_45.1
# layers.library_45.30
# mathffp.library_45.3
# misc.resource_37.1(46.143)
# potgo.resource_37.5
# ram-handler_45.5
# ramdrive_45.3
# ramlib_45.1
# input_45.2
# shell_46.10
# romboot_45.1
# timer.device_45.1
# trackdisk.device_45.1
# utility.library_45.2
# intuition.library_40.87
# gadtools.library_40.5
# wb_icon_45.194
# wbtask_39.1

BUILD=$PWD/build
cd $BUILD

FILES=AmigaOS-3.1.4-A4000
KICKDIR=46.143_Hyperion\(A4000_R2\)

romtool -q split $FILES/ROMs/unsplit_unswapped/kick.a4000.46.143 -o .

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

romtool -q build -o kick.a4000.46.144.pre -t kick -s 512 -r 46.144 46.143_Hyperion\(A4000_R2\)/index.txt

# This is a 512KB ROM that works without ROMY:
cp kick.a4000.46.144.pre kick.a4000.46.144-512kb.rom

# Now patch for 1MB. This will cause the Amiga to yellow screen without ROMY:
romtool -q patch -o kick.a4000.46.144.rom kick.a4000.46.144.pre 1mb_rom

# Cleanup
rm kick.a4000.46.144.pre
rm -r $KICKDIR

romtool -q build -o extension.rom -t ext -f -r 46.144 hrtmodule $FILES/Install3_1_4/Libs/icon.library $FILES/Install3_1_4/Libs/workbench.library

romtool -q combine kick.a4000.46.144.rom extension.rom -o kick.a4000.46.144.1mb.rom

#./kickconv --split kick.a4000.46.144.1mb.rom kick_swapped
#./kickconv --swap kick_swapped_hi kick_hi.rom
#./kickconv --swap kick_swapped_lo kick_lo.rom

../scripts/arom2bin_slim kick.a4000.46.144.1mb.rom

cd ..
printf "You made it! It is done!\n\n"
printf "Write build/kick.a4000.46.144.1mb.LO.bin and build/kick.a4000.46.144.1mb.HI.bin to to two 27C400 chips.\n\n"

