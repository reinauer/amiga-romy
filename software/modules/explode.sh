#! /usr/bin/env bash
#
# Explode-7 library
# More information:
# https://aminet.net/package/util/libs/explode-7
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled LIBRARY_EXPLODE || exit 0

URL="https://aminet.net/util/libs/explode-7.lha"
FILE="explode-7.lha"
MODULE=explode.library
NAME="Explode 7"

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
