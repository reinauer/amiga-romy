#!/bin/bash
#
# Linux EXT2 Filesystem
# More information:
# https://aminet.net/package/disk/misc/ext2fs_0.41
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_EXT2 || exit 0

URL="http://aminet.net/disk/misc/ext2fs_0.41.lha"
FILE="ext2fs_0.41.lha.lha"
MODULE="EXT2FileSystem/AmigaOS/Ext2FileSystem"
NAME="SmartFileSystem"

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
