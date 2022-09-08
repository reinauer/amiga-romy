#! /usr/bin/env bash
#
# Microsoft NTFS
# More information:
# https://aminet.net/package/disk/misc/ntfs_0.9
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_NTFS || exit 0

URL="http://aminet.net/disk/misc/ntfs_0.9.lha"
FILE="ntfs_0.9.lha"
MODULE="NTFileSystem/AmigaOS/NTFileSystem"
NAME="NTFileSystem"

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
