#!/bin/bash
#
# Thomas Richter's MMULib
# More information:
# https://aminet.net/package/util/libs/MMULib

. $( dirname $0 )/../scripts/functions.sh

is_enabled LIBRARY_MMULIB || exit 0

URL="https://aminet.net/util/libs/MMULib.lha"
FILE="MMULib.lha"
MODULE="MMULib/Libs/680x0.library"
is_enabled LIBRARY_MMULIB_68020 && MODULE="$MODULE MMULib/Libs/68020.library"
is_enabled LIBRARY_MMULIB_68030 && MODULE="$MODULE MMULib/Libs/68030.library"
is_enabled LIBRARY_MMULIB_68040 && MODULE="$MODULE MMULib/Libs/68040.library"
is_enabled LIBRARY_MMULIB_68060 && MODULE="$MODULE MMULib/Libs/68060.library"
# TODO add disassembler.library, memory.library, mmu.library?
NAME="MMULib"

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
