#!/bin/bash
#
# HRTmon module
# More information:
# FIXME
#

. $( dirname $0 )/../scripts/functions.sh

is_enabled HRTMON || exit 0

MODULE=hrtmon/hrtmodule
NAME="HRTmon"

CMD=$1
case "$CMD" in
    download)
	# HRTmon files
	gather_file_online vasm.tar.gz "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz"
	gather_file_online rnc_propack_source.zip "https://github.com/lab313ru/rnc_propack_source/archive/refs/heads/master.zip"
	gather_file_online hrtmon238.lha "http://www.whdload.de/whdload/Tools/hrtmon238.lha"
	gather_file_online HRTModule236.lha "http://eab.abime.net/attachment.php?attachmentid=48312&d=1461965752"
	;;
    unpack)
	#rm -rf hrtmon
	printf " * Unzipping hrtmodule238 ..."
	lha xf $ARCHIVES/hrtmon238.lha > /dev/null
	printf " ok\n"

	#rm -rf vasm
	printf " * Unpacking vasm ..."
	tar xzf $ARCHIVES/vasm.tar.gz
	printf " ok\n"

	#rm -rf rnc_propack_source
	printf " * Unpacking rnc_propack_source ..."
	unzip -qqo $ARCHIVES/rnc_propack_source.zip
	#mv rnc_propack_source-master rnc_propack_source
	printf " ok\n"

	;;
    compile)
        BUILD=$PWD
	printf "Compiling vasm... "
	if [ -r $BUILD/vasm/vasmm68k_mot ]; then
	  printf "cached.\n"
	else
	  cd $BUILD/vasm
	  make -s CPU=m68k SYNTAX=mot
	  cd ..
	  printf "ok.\n"
	fi

	printf "Compiling rnc_propack_source... "
	if [ -r $BUILD/rnc_propack_source-master/rnc64 ]; then
	  printf "cached.\n"
	else
	  cd rnc_propack_source-master
	  make -s 2>/dev/null
	  cd ..
	  # if we recompiled rnc64, remove existing files
	  rm -f hrtmon.data.rnc
	  printf "ok.\n"
	fi

	printf "Compressing hrtmon data... "
	if [ -r $BUILD/hrtmon/hrtmon.data.rnc ]; then
	  printf "cached.\n"
	else
	  rnc_propack_source-master/rnc64 p hrtmon/HRTmon.data hrtmon/hrtmon.data.rnc -m=1 > /dev/null
	  printf "ok.\n"
	fi

	VERSION="$( strings hrtmon/HRTmon.data |grep \$VER|cut -d\  -f3- )"
	printf "Compiling HRTmodule $VERSION... "

	if [ -r $BUILD/hrtmon/hrtmodule ]; then
	  printf "cached.\n"
	else
	  cp ../src/hrtmodule.s hrtmon
	  sed -i s,VERSION,"$VERSION", hrtmon/hrtmodule.s

	  vasm/vasmm68k_mot -m68020 -Fhunkexe -o hrtmon/hrtmodule hrtmon/hrtmodule.s > /dev/null

	  printf "ok.\n"
	fi

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
