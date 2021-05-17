#!/bin/bash

# set -e
BUILD=$PWD/build

cd $BUILD

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
cd ..

