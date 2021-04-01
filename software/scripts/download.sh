#!/bin/sh
printf "Gathering all files... "

# Point this directory to the place where you downloaded
# your Amiga OS 3.1.4 files:

FILES=$HOME/Downloads

mkdir -p archives

if [ ! -r $FILES/AmigaOS-3.1.4-A4000.zip ]
then
  echo "Can not find $FILES/AmigaOS-3.1.4-A4000.zip"
  exit 1
fi
if [ ! -r $FILES/AmigaOS-3.1.4.1-Update.zip ]
then
  echo "Can not find $FILES/AmigaOS-3.1.4.1-Update.zip"
  exit 1
fi
cp -a $FILES/AmigaOS-3.1.4-A4000.zip archives
cp -a $FILES/AmigaOS-3.1.4.1-Update.zip archives

# TODO this does not work
#USER="youwish"
#PASS="toknow"
#curl -L -u "$USER":"$PASS" -# "https://www.hyperion-entertainment.com/index.php/downloads?view=download&layout=form&file=105" --output archives/AmigaOS-3.1.4-A4000.zip
#curl -L -u "$USER":"$PASS" -# "https://www.hyperion-entertainment.com/index.php/downloads?view=download&layout=form&file=116" --output archives/AmigaOS-3.1.4.1-Update.zip

curl -s http://www.doobreynet.co.uk/files/remus/Remus_1.78.lha --output archives/Remus_1.78.lha
curl -s http://www.doobreynet.co.uk/files/remus/ROMsplit_1.25.lha --output archives/ROMsplit_1.25.lha
curl -s http://www.doobreynet.co.uk/files/remus/Remus_1.78_Update2.lha --output archives/Remus_1.78_Update2.lha
curl -s http://www.whdload.de/whdload/Tools/hrtmon238.lha --output archives/hrtmon238.lha
curl -s "http://eab.abime.net/attachment.php?attachmentid=48312&d=1461965752" --output archives/HRTModule236.lha
curl -s https://raw.githubusercontent.com/keirf/Amiga-Stuff/master/host_tools/kickconv.c --output archives/kickconv.c

curl -s http://sun.hasenbraten.de/vasm/release/vasm.tar.gz --output archives/vasm.tar.gz
curl -Ls https://github.com/lab313ru/rnc_propack_source/archive/refs/heads/master.zip --output archives/rnc_propack_source.zip

printf "done\n"
