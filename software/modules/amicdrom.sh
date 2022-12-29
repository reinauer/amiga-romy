#!/bin/bash
#
# AmiCDROM Filesystem
# More information:
# https://aminet.net/package/disk/cdrom/AmiCDROM-1.15
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_AMICDROM || exit 0

URL="http://aminet.net/disk/cdrom/AmiCDROM-1.15.lha"
FILE="AmiCDROM-1.15.lha"
MODULE="AmiCDROM/l/cdrom-handler"
NAME="AmiCDROM"

CMD=$1
case "$CMD" in
    download)
	gather_file_online "$FILE" "$URL"
	;;
    unpack)
	printf " * Unpacking $NAME"
	lha xq $ARCHIVES/$FILE
	printf " ok\n"
	;;
    compile)
	;;
    build)
	# MODULES="$MODULES $( this.sh build )"
	echo "$MODULE"
	;;
    *)
	echo "$(basename $0): Unknown command '$CMD'"
	exit 1
	;;
esac

exit 0
