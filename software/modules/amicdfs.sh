#!/bin/bash
#
# AmiCDFS Filesystem
# More information:
# https://aminet.net/package/disk/cdrom/amicdfs240.lha
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_AMICDFS || exit 0

URL="http://aminet.net/disk/cdrom/amicdfs240.lha"
FILE="amicdfs240.lha"
MODULE="AmiCDFS2/L/AmiCDFS"
NAME="AmiCDFS"

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
