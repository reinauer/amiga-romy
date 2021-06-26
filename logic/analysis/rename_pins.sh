#!/bin/bash
# get http://www.brouhaha.com/~eric/retrocomputing/mmi/palasm/opaljr21.zip
cat $1 | sed 's,CLK,CLK90,g; s,i2,A22,g; s,i3,A23,g; s,i4,A24,g; s,i5,A25,g; s,i6,A26,g; s,i7,A27,g; s,i8,A28,g; s,i9,A29,g; s,i10,A30,g; s,i11,A31,g; s,GND,GND,g; s,i13,RW,g; s,f14,AS,g; s,o15,ROMEN,g; s,f16,SPEED,g; s,f17,REG2,g; s,f18,REG1,g; s,f19,A19,g; s,f20,A20,g; s,f21,A21,g; s,f22,STERM,g; s,f23,DSTERM,g; s,vcc,VCC,g; s,gnd,GND,'
