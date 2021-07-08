#!/bin/bash
#
# romdisk module
# More information:
# https://github.com/cnvogelg/romdisk/
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled ROMDISK || exit 0

URL="https://github.com/tobiasvl/rnc_propack/raw/master/PPAMI.EXE"
FILE="ppami.exe"
MODULE=
NAME="romdisk.device / romdisk.rodi"

CMD=$1
case "$CMD" in
    download)
	gather_file_online "$FILE" "$URL"
	# FIXME download romdisk
	;;
    unpack)
	printf " * Unpacking $NAME"
	# FIXME
	printf " ok\n"
	;;
    compile)
	# FIXME compile romdisk
	;;
    build)
	# FIXME create a sample romdisk instead of
	# expecting one to be there already.
	if [ -r ../archives/romdisk.device_rel ]; then
	  echo "Warning: Will be building with romdisk.device."
	  cp ../archives/romdisk.device_rel romdisk.device
	  cp ../archives/romdisk.rodi .
	  MODULE="romdisk.device romdisk.rodi"
	fi
	# MODULES="$MODULES $( this.sh build )"
	echo "$MODULE"
	;;
    *)
	echo "$(basename $0): Unknown command '$CMD'"
	exit 1
	;;
esac

exit 0
