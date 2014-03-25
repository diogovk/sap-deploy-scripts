
create_ext4_lvm(){
  set -e
  MOUNT_POINT="$1"
  LV_NAME="$2"
  SIZE="$3"
  lvcreate $VG -n "$LV_NAME" -L "$SIZE"
  mkdir -p "$MOUNT_POINT"
  DEVICE=/dev/$VG/"$LV_NAME"
  mkfs.ext4 $DEVICE
  echo "$DEVICE	$MOUNT_POINT	ext4	defaults	1 2" >> /etc/fstab
  mount -a
  mount | grep -q " $MOUNT_POINT "
}
