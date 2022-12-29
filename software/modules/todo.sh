#!/bin/bash
#
# Your own module (example template)
# More information:
# http://your.web.pa.ge/
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled YOUR_MODULE || exit 0

URL="http://aminet.net/path/filename"
FILE="local_filename"
MODULE="path/to/unpacked/rom_module"
NAME="Your own cool module"

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

# TODO HSMathLibs
# - LIBS:mathffp.library
# - LIBS:mathieeesingbas.library
# other? Your ideas go here!
# http://wt.exotica.org.uk/files/test/WT31.lzx
