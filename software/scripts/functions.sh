#! /usr/bin/env bash

# Downloading functions

# TODO this does not work, so we need to gather some files locally
#USER="youwish"
#PASS="toknow"
#curl -L -u "$USER":"$PASS" -# "https://www.hyperion-entertainment.com/index.php/downloads?view=download&layout=form&file=105" --output archives/AmigaOS-3.1.4-A4000.zip
#curl -L -u "$USER":"$PASS" -# "https://www.hyperion-entertainment.com/index.php/downloads?view=download&layout=form&file=116" --output archives/AmigaOS-3.1.4.1-Update.zip

# See from where we're calling with the scripts
# directory because archives might or might not be there yet.
if [ -d $PWD/scripts ]; then
  TOP=$( realpath $PWD )
elif [ -d $PWD/../scripts ]; then
  TOP=$( realpath $PWD/.. )
fi

ARCHIVES=$TOP/archives

if [ ! -r $TOP/amiga-romy.conf ];
then
   echo "ERROR: amiga-romy.conf not found."
   exit 1
fi
. $TOP/amiga-romy.conf

DEBUG=0
debug()
{
  if [ $DEBUG = 1 ]; then
    echo $@
  fi
}

gather_file()
{
  FILE=$1
  if [ -r archives/$FILE ]; then
    echo "  * $FILE cached."
    return
  fi

  if [ -r $FILES/$FILE ]; then
    echo "  * Found $FILE"
    cp $FILES/$FILE archives
  else
    echo "  * Can not find $FILES/$FILE"
  fi
}

gather_file_online()
{
  FILE=$1
  URL=$2
  if [ -r archives/$FILE ]; then
    echo "  * $FILE cached."
    return
  fi
  echo "  * Downloading $FILE"
  curl -Ls "$URL" --output archives/$FILE
}


# Unpacking functions

unpack_AmigaOS314()
{
  AMIGA=$1

  if [ $AMIGA = archive ]; then
    if [ -r $HOME/Downloads/ROMs/unsplit_unswapped ]; then
      echo " * Found test archive, pre-populating..."
      cp -a $HOME/Downloads/ROMs/unsplit_unswapped/* \
		$BUILD/AmigaOS-3.1.4/ROMs/unsplit_unswapped
    fi
    return
  fi

  if [ ! -r $ARCHIVES/AmigaOS-3.1.4-$AMIGA.zip ]; then
    echo " * AmigaOS 3.1.4 $AMIGA files not found, skipping"
    return
  fi

  printf " * Unzipping AmigaOS 3.1.4 ($AMIGA) ..."
  mkdir -p $BUILD/AmigaOS-3.1.4-$AMIGA
  cd $BUILD/AmigaOS-3.1.4-$AMIGA
  unzip -qq  $ARCHIVES/AmigaOS-3.1.4-$AMIGA.zip

  cp -a $BUILD/AmigaOS-3.1.4-$AMIGA/ROMs/unsplit_unswapped/* \
	 $BUILD/AmigaOS-3.1.4/ROMs/unsplit_unswapped
  cp -a $BUILD/AmigaOS-3.1.4-$AMIGA/Install3_1_4.adf $BUILD/AmigaOS-3.1.4/
  cd ..
  rm -rf $BUILD/AmigaOS-3.1.4-$AMIGA
  printf " ok\n"
}

unpack_adfs()
{
  for ADF in *.adf
  do
    rm -rf ${ADF%.adf}
    #cd  ${ADF%.adf}
    printf "   * Unpacking ${ADF%.adf} ..."
    xdftool $ADF unpack .
    printf " ok\n"
    #cd ..
  done
}

# config handling
#

is_enabled()
{
  VAR=CONFIG_$1
  if [ "${!VAR}" == "" ]; then
    echo "ERROR: config option $VAR does not exist."
    return 1
  fi
  if [ "${!VAR}" = "y" -o "${!VAR}" = "Y" ];  then
    return 0
  fi
  return 1
}

