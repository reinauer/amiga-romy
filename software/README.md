= 1MB ROM Builder for ROMY =

This contraption will build a 1MB ROM

 * It uses Amiga 4000D 3.1.4 files to produce the image
 * It exchanges all resident modules from the 3.1.4.1 Updates disk
 * It replaces intuition.library with intuition v45
 * It will add icon.library and workbench.library from the Install disk
 * It will create a rom-able HRTmon and add it to the image

= How to build =

You will need romtools from the amitools package installed: https://github.com/cnvogelg/amitools
Put your Amiga 4000D files (AmigaOS-3.1.4-A4000.zip and AmigaOS-3.1.4.1-Update.zip) into your
$HOME/Downloads folder, and then type

```
 $ make
 ROMY 1MB Kickstart patcher

 Fasten your seatbelts and hold your breath

 Gathering all files... done
  * Unzipping AmigaOS 3.1.4 + Update ... ok
    * Unpacking Extras3_1_4 ... ok
    * Unpacking Fonts ... ok
    * Unpacking Install3_1_4 ... ok
    * Unpacking Locale ... ok
    * Unpacking ModulesA4000D_3.1.4 ... ok
    * Unpacking Storage3_1_4 ... ok
    * Unpacking Update3.1.4.1 ... ok
    * Unpacking Workbench3_1_4 ... ok
  * Unzipping hrtmodule238 ... ok
  * Unpacking vasm ... ok
  * Unpacking rnc_propack_source ... ok
 Compiling vasm... ok.
 Compiling rnc_propack_source... ok.
 Compressing hrtmon data... ok.
 Compiling HRTmodule... ok.
 Header 11144ef9 512
 Header 11144ef9 512
 Header 11144ef9 512
 Header 11144ef9 512
 Header 11144ef9 512
 You made it! It is done!

 Write build/kick.a4000.46.144.1mb.LO.bin and build/kick.a4000.46.144.1mb.HI.bin to to two 27C400 chips.
 $
```

= How to flash =

You can flash the two resulting files to two 27C400 (or comparable) EPROMs.
Note that in order for the resulting Kickstart to work, you will have to have
ROMY installed in your Amiga 4000D.


= How to use =

You should have an ikod.se INT7 adapter installed in order to use HRTmon (or
some other means of triggering INT7)

= Credits =

 * Thanks to the authors of the various tools I am using in these scripts. It
   wouldn't have happened without you.
 * Thanks to Guillaume Binet (RetroLab on YouTube) for the inspiration and doing
   all the ground work.
 * Thanks to highpuff for the ikod.se INT7 adapter.
 * Thanks to everybody in the Amiga community for keeping the Amiga Fever alive.

