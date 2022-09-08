#! /usr/bin/env bash
#
# arp.library 40.2 module
# More information:
# http://aminet.net/package/util/libs/arp40_2
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled LIBRARY_ARP || exit 0

URL="https://aminet.net/util/libs/arp40_2.lha"
FILE="arp40.2.lha"
MODULE=ArpLib40.2/arp.library
NAME="Arp 40.2"

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
