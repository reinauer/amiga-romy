KICK="$1"
EXT="$2"
OUT="$3"
srec_cat "$KICK" -Binary -Byte_Swap -Split 4 0 2 -Offset 0x40000 \
         "$KICK" -Binary -Byte_Swap -Split 4 2 2 -Offset 0xC0000 \
         "$EXT" -Binary -Byte_Swap -Split 4 0 2 -Offset 0x00000 \
         "$EXT" -Binary -Byte_Swap -Split 4 2 2 -Offset 0x80000 \
         -Output "$OUT" -Binary
