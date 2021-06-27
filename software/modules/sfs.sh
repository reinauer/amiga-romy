#!/bin/bash
#
# Smart Filesystem
# More information:
# https://aminet.net/package/disk/misc/SFS
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_SFS || exit 0

URL="http://aminet.net/disk/misc/SFS.lha"
FILE="SFS.lha"
MODULE="Smartfilesystem/AmigaOS3.x/L/SmartFilesystem"
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
