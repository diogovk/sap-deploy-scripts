set -e
VG=vg_backup
source utils.sh
#pvcreate /dev/sde
#vgcreate $VG /dev/sde

create_ext4_lvm  /backup lv_backup 99999M

