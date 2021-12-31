#!/bin/bash

. $( dirname $0 )/functions.sh

printf "Gathering all files... "

# Point this directory to the place where you downloaded
# your Amiga OS files:

FILES=$HOME/Downloads

mkdir -p archives

# From Hyperion
echo "Looking for Hyperion files"
gather_file AmigaOS-3.1.4-A3000.zip
gather_file AmigaOS-3.1.4-A4000.zip
gather_file AmigaOS-3.1.4-A4000T.zip
gather_file AmigaOS-3.1.4.1-Update.zip
gather_file AmigaOS3.2CD.iso
gather_file kick_3.1.4.1.zip
gather_file Update3.2.1.lha

# Other stuff
echo "Looking for add-on modules"

for MOD in $PWD/modules/*; do
	$MOD download
done

printf "done\n"
