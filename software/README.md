# 1MB/2MB/4MB ROM Builder for ROMY

This contraption will build larger Kickstart ROMs for (almost) all Amigas

* Support for Kickstart 3.1.4 (46.143) 3.1.4.1 (46.160) and 3.2 (47.96)
* On 3.1.4 it exchanges all resident modules from the 3.1.4.1 Updates disk
* On 3.1.4 it replaces intuition.library with intuition v45
* It will add icon.library and workbench.library from the Install disk
* It will create a rom-able HRTmon and add it to the image
* On Amiga 1200, it will add ehide.device to boot off TF1260 IDE

# How to build

* You will need romtools from the amitools package installed: https://github.com/cnvogelg/amitools
* 3.1.4: Put your Amiga 4000D files (AmigaOS-3.1.4-A4000.zip and AmigaOS-3.1.4.1-Update.zip) into your
$HOME/Downloads folder
* 3.2: Place an ISO of your 3.2 CD in $HOME/Downloads/AmigaOS3.2CD.iso

Then type:
```
 $ make
 ROMY 1MB/2MB/4MB Kickstart patcher

 Usage:

  $ make kickstart TARGETS="A500 A4000" VERSION=47.96 SIZES="1mb 4mb"

  TARGETS
   - A500
   - A1200
   - A3000
   - A4000
   - A4000T

  SIZES
   - 1mb (*)
   - 2mb (**)
   - 4mb (**)

   (*) 0xe00000 base    (**) 0x1000000 base

  VERSION
   - 46.143
   - 46.160
   - 47.96

  For CDTV, A500, A600, A1000, A2000 use the A500 image
  For CD32, please talk to me

  Defaults
   TARGETS="A500 A1200 A3000 A4000 A4000T"
   VERSION="47.96"
   SIZES="1mb 2mb 4mb"
```

 Now, if you want to build a 1MB Kickstart 3.2 image for the Amiga 4000, you write:
```
 $ make kickstart TARGETS="A4000" SIZES="1mb" VERSION="47.96"
 ROMY 1MB/2MB/4MB Kickstart patcher

 Fasten your seatbelts and hold your breath (no, better don't!)

 Processing Kickstart 47.96 for A4000 (1mb)
 Success! Now write build/47.96/kick.a4000.47.96.1mb.LO.bin and build/47.96/kick.a4000.47.96.1mb.HI.bin to two 27C400(1M)/27C160(4M) chips (A4000).

 $
```

# How to flash

You can flash the two resulting files to two 27C400 (or comparable) EPROMs.
Note that in order for the resulting Kickstart to work, you will have to have
ROMY installed in your Amiga 4000D.


# How to use

You should have an ikod.se INT7 adapter installed in order to use HRTmon (or
some other means of triggering INT7)

# Credits

* Thanks to the authors of the various tools I am using in these scripts. It
  wouldn't have happened without you.
* Thanks to Guillaume Binet (RetroLab on YouTube) for the inspiration and doing
  all the ground work.
* Thanks to highpuff for the ikod.se INT7 adapter.
* Thanks to faxm0dem for the awesome arom2bin tool.
* Thanks to everybody in the Amiga community for keeping the Amiga Fever alive.

