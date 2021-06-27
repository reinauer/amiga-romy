#!/bin/sh

printf "Gathering all files... "

# Point this directory to the place where you downloaded
# your Amiga OS files:

FILES=$HOME/Downloads

. $( dirname $0 )/functions.sh

mkdir -p archives

# From Hyperion
echo "Looking for Hyperion files"
gather_file AmigaOS-3.1.4-A3000.zip
gather_file AmigaOS-3.1.4-A4000.zip
gather_file AmigaOS-3.1.4-A4000T.zip
gather_file AmigaOS-3.1.4.1-Update.zip
gather_file AmigaOS3.2CD.iso
gather_file kick_3.1.4.1.zip

# For Terrible Fire TF1260
echo "Looking for TF1260 drivers"
gather_file_online ehide.tar.gz "https://wordpress.hertell.nu/files/ehide_d2874a8.tar.gz"

# Other stuff
echo "Looking for other files"

# Database files needed by amitools (or are they?)
#gather_file_online Remus_1.79.lha "http://www.doobreynet.co.uk/files/remus/Remus_1.79.lha"
#gather_file_online ROMsplit_1.28.lha "http://www.doobreynet.co.uk/files/remus/ROMsplit_1.28.lha"

# HRTmon files
gather_file_online vasm.tar.gz "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz"
gather_file_online rnc_propack_source.zip "https://github.com/lab313ru/rnc_propack_source/archive/refs/heads/master.zip"
gather_file_online hrtmon238.lha "http://www.whdload.de/whdload/Tools/hrtmon238.lha"
gather_file_online HRTModule236.lha "http://eab.abime.net/attachment.php?attachmentid=48312&d=1461965752"

# for romdisk
gather_file_online ppami.exe "https://github.com/tobiasvl/rnc_propack/raw/master/PPAMI.EXE"

# Additional Libraries

for MOD in $PWD/modules/*; do
	$MOD download
done

printf "done\n"
