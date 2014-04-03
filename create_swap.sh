# parted /dev/sdb mklabel msdos
# parted /dev/sdb mkpart primary linux-swap 0 17.2GB Ignore
set -e

mkswap /dev/sdb1 
echo "/dev/sdb1               none                    swap    defaults        0 0" >> /etc/fstab
swapon -a
swapon -s



