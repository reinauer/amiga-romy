#! /usr/bin/env bash
#
# Toni Wilen's PFS3 All-In-One
# More information:
# https://aminet.net/package/disk/misc/pfs3aio
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled FILESYSTEM_PFS3 || exit 0

URL="http://aminet.net/disk/misc/pfs3aio.lha"
FILE="pfs3aio.lha"
MODULE="pfs3aio"
# What about pfs3aio-custom?
NAME="PFS3AIO"

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
