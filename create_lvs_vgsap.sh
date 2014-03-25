
set -e
VG=vg_sap
#pvcreate /dev/sdc
vgcreate $VG /dev/sdc

source utils.sh

# create_ext4_lvm  /sapmnt       lv_sapmnt       1G
# create_ext4_lvm  /sapmnt/POQ   lv_sapmnt_poq   10G
# create_ext4_lvm  /usr/sap      lv_usr_sap      1G
# create_ext4_lvm  /usr/sap/DAA  lv_usr_sap_daa  5G
# create_ext4_lvm  /usr/sap/POQ  lv_usr_sap_poq  10G


