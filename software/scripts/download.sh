#!/bin/sh

printf "Gathering all files... "

# Point this directory to the place where you downloaded
# your Amiga OS files:

FILES=$HOME/Downloads

# TODO this does not work, so we need to gather some files locally
#USER="youwish"
#PASS="toknow"
#curl -L -u "$USER":"$PASS" -# "https://www.hyperion-entertainment.com/index.php/downloads?view=download&layout=form&file=105" --output archives/AmigaOS-3.1.4-A4000.zip
#curl -L -u "$USER":"$PASS" -# "https://www.hyperion-entertainment.com/index.php/downloads?view=download&layout=form&file=116" --output archives/AmigaOS-3.1.4.1-Update.zip

gather_file()
{
  FILE=$1
  if [ -r archives/$FILE ]; then
    echo "  * $FILE cached."
    return
  fi

  if [ -r $FILES/$FILE ]; then
    echo "  * Found $FILE"
    cp $FILES/$FILE archives
  else
    echo "  * Can not find $FILES/$FILE"
  fi
}

gather_file_online()
{
  FILE=$1
  URL=$2
  if [ -r archives/$FILE ]; then
    echo "  * $FILE cached."
    return
  fi
  echo "  * Downloading $FILE"
  curl -Ls "$URL" --output archives/$FILE
}

mkdir -p archives

# From Hyperion
echo "Looking for Hyperion files"
gather_file AmigaOS-3.1.4-A3000.zip
gather_file AmigaOS-3.1.4-A4000.zip
gather_file AmigaOS-3.1.4-A4000T.zip
gather_file AmigaOS-3.1.4.1-Update.zip
gather_file AmigaOS3.2CD.iso
gather_file kick_3.1.4.1.zip

# From Terrible Fire
echo "Looking for Terrible Fire files"
gather_file ehide.device

# Other stuff

echo "Looking for other files"
gather_file_online Remus_1.78.lha "http://www.doobreynet.co.uk/files/remus/Remus_1.78.lha"
gather_file_online ROMsplit_1.25.lha "http://www.doobreynet.co.uk/files/remus/ROMsplit_1.25.lha"
gather_file_online Remus_1.78_Update2.lha "http://www.doobreynet.co.uk/files/remus/Remus_1.78_Update2.lha"
gather_file_online hrtmon238.lha "http://www.whdload.de/whdload/Tools/hrtmon238.lha"
gather_file_online HRTModule236.lha "http://eab.abime.net/attachment.php?attachmentid=48312&d=1461965752"
gather_file_online kickconv.c "https://raw.githubusercontent.com/keirf/Amiga-Stuff/master/host_tools/kickconv.c"
gather_file_online vasm.tar.gz "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz"
gather_file_online rnc_propack_source.zip "https://github.com/lab313ru/rnc_propack_source/archive/refs/heads/master.zip"

printf "done\n"
