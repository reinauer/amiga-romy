#! /usr/bin/env bash
#
# BSD FastFileSystem support by Chris Hooper
# More information:
# https://aminet.net/package/disk/misc/bffs16_src
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_BSDFFS || exit 0

URL="http://aminet.net/disk/misc/bffs16_src.lha"
FILE="bffs16_src.lha"
MODULE="bffs_1.6/l/BFFSFilesystem"
# FIXME or is it BFFSFilesystem.robe?
NAME="Berkeley Fast File System"

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
