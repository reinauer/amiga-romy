#!/bin/bash
#
# Microsoft FAT95 Filesystem
# More information:
# https://aminet.net/package/disk/misc/fat95

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_FAT95 || exit 0

URL="http://aminet.net/disk/misc/fat95.lha"
FILE="fat95.lha"
MODULE="fat95/l/fat95"
NAME="FAT95"

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
