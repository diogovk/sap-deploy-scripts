#!/bin/bash


find /sys/ -name scan | grep host[0-1]/scan | while read file ; do
  echo "- - -" > $file
done

find /sys/class/scsi_disk/2\:0\:*/device/rescan | while read file ; do
  echo 1 > $file
done


# LVM Resize example:
# pvresize /dev/sdc
# lvresize -r -L 20G /dev/mapper/vg_sap-lv_ECP
