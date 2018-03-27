\ Menu bootscript for OLPC with overclocking.  Place in /boot as olpc.fth

\ select overclock level
cr
." 1 to set the clock speed as normal" cr
." 2 to under clock the machine to 333 MHZ memory 133" cr
." 3 to overclock it to 500 memory 200" cr
." 4 to overclock extreme to 533 233 WARNING MIGHT BE UNSTABLE" cr cr
key case
  [char] 2 of    \ underclock
    7de009e 3d3 4c000014 wrmsr ." underclock"
  endof
  [char] 3 of    \ over clock normal
    7de009e 5dd 4c000014 wrmsr ." overclock normal"
  endof
  [char] 4 of    \ overclock EXTREME
    7de009e 6df 4c000014 wrmsr ." overclock EXTREME"
  endof
  \ Default - keep the normal setting
endcase

\ select boot location
cr
." 1 to boot from SD" cr
." 2 to boot from USB" cr
." 3 to boot from internal nand" cr
." 4 to boot alternate image from Nand" cr
cr
key case
  [char] 1 of      \ SD boot info
     " ro root=mmcblk0p1 rootdelay=1 console=ttyS0,115200 console=tty0 fbcon=font:SUN12x22" to boot-file
     " sd:\boot\vmlinuz" to boot-device
     " sd:\boot\olpcrd.img" to ramdisk
  endof
  [char] 2 of      \ USB boot info
     " ro root=sda1 rootdelay=1 console=ttyS0,115200 console=tty0 fbcon=font:SUN12x22" to boot-file
     " disk:\boot\vmlinuz" to boot-device
     " disk:\boot\olpcrd.img" to ramdisk
  endof
  [char] 4 of      \ Alternate boot image info
      " ro root=mtd0 rootfstype=jffs2 console=ttyS0,115200 console=tty0 fbcon=font:SUN12x22" to boot-file
      " nand:\boot-alt\vmlinuz" to boot-device
      " nand:\boot-alt\olpcrd.img" to ramdisk
  endof
  ( default )      \ Default sugar boot image info
      " ro root=mtd0 rootfstype=jffs2 console=ttyS0,115200 console=tty0 fbcon=font:SUN12x22" to boot-file
      " nand:\boot\vmlinuz" to boot-device
      " nand:\boot\olpcrd.img" to ramdisk
endcase
unfreeze
boot
