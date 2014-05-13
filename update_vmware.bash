
error(){
  echo "$@"
  umount /media/vmware-tools
  rmdir /media/vmware-tools
  exit 1
}

mkdir /media/vmware-tools
mount /dev/sr0 /media/vmware-tools
TAR_FILE="$(echo /media/vmware-tools/VMwareTools-*.tar.gz)"
[ -f "$TAR_FILE" ] || error "VMwareTools not found in /dev/sr0"
cp -a "$TAR_FILE" /tmp || error "Fail to copy VmwareTools to /tmp"
tar -C /tmp -xvf /tmp/"$(basename "$TAR_FILE")" || error "Fail to extract VMwareTools"
umount /media/vmware-tools
rmdir /media/vmware-tools

