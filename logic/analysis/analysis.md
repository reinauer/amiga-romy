
# Prerequisites

* Get OpalJr: wget http://www.brouhaha.com/~eric/retrocomputing/mmi/palasm/opaljr21.zip
* Install galette: https://github.com/simon-frankau/galette

# Get source files

* Use dosbox or dosemu with jed2eqn.
* See script.bat for an automated script

# Conver pin names
* run rename_pins.sh to rename the pins according to the schematics
```
  for f in *.EQN; do
    ./rename_pins.sh $f > ${f%.EQN}.pld
  done
```

