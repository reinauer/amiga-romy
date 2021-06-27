#!/bin/bash
#
# Add your own modules like this
#

CMD=$1

. $( dirname $0 )/../scripts/functions.sh

URL="https://aminet.net/util/libs/explode-7.lha"
FILE="explode-7.lha"
MODULE=explode.library
NAME="Explode 7"

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
