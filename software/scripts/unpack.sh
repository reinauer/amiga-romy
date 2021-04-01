#!/bin/sh


BUILD=$PWD/build
ARCHIVES=$PWD/archives

mkdir -p $BUILD

rm -rf $BUILD/AmigaOS-3.1.4-A4000
mkdir $BUILD/AmigaOS-3.1.4-A4000
cd $BUILD/AmigaOS-3.1.4-A4000

printf " * Unzipping AmigaOS 3.1.4 + Update ..."
unzip -qq  $ARCHIVES/AmigaOS-3.1.4-A4000.zip
unzip -qqo $ARCHIVES/AmigaOS-3.1.4.1-Update.zip
printf " ok\n"

for ADF in *.adf
do
  mkdir  ${ADF%.adf}
  #cd  ${ADF%.adf}
  printf "   * Unpacking ${ADF%.adf} ..."
  unadf $ADF -d ${ADF%.adf} > /dev/null 2>&1
  printf " ok\n"
  #cd ..
done

cd ..
rm -rf hrtmon
printf " * Unzipping hrtmodule238 ..."
lha x $ARCHIVES/hrtmon238.lha > /dev/null
# cp ../hrtmodule238 .
printf " ok\n"

rm -rf vasm
printf " * Unpacking vasm ..."
tar xzf $ARCHIVES/vasm.tar.gz
printf " ok\n"

rm -rf rnc_propack_source
printf " * Unpacking rnc_propack_source ..."
unzip -qq $ARCHIVES/rnc_propack_source.zip
mv rnc_propack_source-master rnc_propack_source
printf " ok\n"

cd ..

