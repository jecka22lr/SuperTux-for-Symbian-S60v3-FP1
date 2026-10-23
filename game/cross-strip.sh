#!/bin/bash

/usr/local/gp2xdev/gp2x/bin/strip -s ./src/supertux

if [ `ifconfig | grep -c usb` -gt 0 ]; then
    if [ `mount | grep -c /mnt/gp2x` -lt 1 ]; then
	mount /mnt/gp2x
    fi
    cp ./src/supertux /mnt/gp2x/mnt/sd/games/supertux/supertux.gpe
else
    mount /media/sdcard
    cp ./src/supertux /media/sdcard/games/supertux/supertux.gpe
    umount /media/sdcard
fi
