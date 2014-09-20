#!/bin/bash

# After installing a newer linux kernel is necessary to recompile
# the vmware-tools modules.
# For some weird reason the initrd created by vmware-tools, doesn't 
# have proper depmod files and fail to boot
# The solution we found was to rebuild the initrd again using dracut

#yum update installs the newer kernel
yum update && vmware-config-tools.pl -k 2.6.32-431.20.3.el6.x86_64 -d && dracut -f /boot/initramfs-2.6.32-431.20.3.el6.x86_64.img 2.6.32-431.20.3.el6.x86_64 && echo ok

