#!/bin/bash

# set -e
# gh repo clone lab313ru/rnc_propack_source
BUILD=$PWD/build

printf "Compiling vasm... "
cd $BUILD/vasm
make -s CPU=m68k SYNTAX=mot
cd ..
printf "ok.\n"

printf "Compiling rnc_propack_source... "
cd rnc_propack_source
make -s 2>/dev/null
cd ..
printf "ok.\n"

printf "Compressing hrtmon data... "
rnc_propack_source/rnc64 p hrtmon/HRTmon.data hrtmon.data.rnc -m=1 > /dev/null
printf "ok.\n"


printf "Compiling HRTmodule... "
VERSION="$( strings hrtmon/HRTmon.data |grep \$VER|cut -d\  -f3- )"

cp ../src/hrtmodule.s .
sed -i s,VERSION,"$VERSION", hrtmodule.s

vasm/vasmm68k_mot -m68020 -Fhunkexe -o hrtmodule hrtmodule.s > /dev/null

printf "ok.\n"
