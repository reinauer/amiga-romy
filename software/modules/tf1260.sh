#! /usr/bin/env bash
#
# TF1260 ehide.device module
# More information:
# https://wordpress.hertell.nu/?page_id=1161
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled TF1260 || exit 0

URL="https://wordpress.hertell.nu/files/ehide_d2874a8.tar.gz"
FILE="ehide.tar.gz"
MODULE=ehide.device
NAME="TF1260 ehide.device"

CMD=$1
case "$CMD" in
    download)
	echo "Looking for TF1260 drivers"
	gather_file_online "$FILE" "$URL"
	;;
    unpack)
	printf " * Unpacking $NAME"
	tar xzf $ARCHIVES/$FILE
	printf " ok\n"
	;;
    compile)
	;;
    build)
	# MODULES="$MODULES $( this.sh build )"
	if [ "$AMIGA" == "A1200" ]; then
	  echo "$MODULE"
	fi
	;;
    *)
	echo "$(basename $0): Unknown command '$CMD'"
	exit 1
	;;
esac

exit 0
