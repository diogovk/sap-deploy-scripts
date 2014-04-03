
set -e
VG=vg_sap
pvcreate /dev/sdc
vgcreate $VG /dev/sdc

source utils.sh

create_ext4_lvm  /sapmnt         lv_sapmnt       1G
create_ext4_lvm  /sapmnt/JBD     lv_sapmnt_jbd   10G
create_ext4_lvm  /sapmnt/BWD     lv_sapmnt_bwd   10G
create_ext4_lvm  /usr/sap        lv_usr_sap      1G
create_ext4_lvm  /usr/sap/DAA    lv_usr_sap_daa  5G
create_ext4_lvm  /usr/sap/JBD    lv_usr_sap_jdb  10G
create_ext4_lvm  /usr/sap/BWD    lv_usr_sap_bwd  10G
create_ext4_lvm  /usr/sap/trans  lv_usr_trans    30G


