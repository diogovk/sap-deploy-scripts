#!/bin/bash

# After installing a newer linux kernel is necessary to recompile
# the vmware-tools modules.
# For some weird reason the initrd created by vmware-tools, doesn't 
# have proper depmod files and fail to boot
# The solution we found was to rebuild the initrd again using dracut

vmware-config-tools.pl -k 2.6.32-431.11.2.el6.x86_64 -d

dracut -f initramfs-2.6.32-431.11.2.el6.x86_64.img 2.6.32-431.11.2.el6.x86_64

