
set -e
VG=vg_db2
#pvcreate /dev/sdd
#vgcreate $VG /dev/sdd

source utils.sh

#create_ext4_lvm  /db2/POQ              lv_db2-poq              1G
#create_ext4_lvm  /db2/POQ/db2dump      lv_db2-poq-db2dump      5G
create_ext4_lvm  /db2/POQ/log_archive  lv_db2-poq-log_archive  10G
create_ext4_lvm  /db2/POQ/log_dir      lv_db2-poq-log_dir      10G
create_ext4_lvm  /db2/POQ/sapdata1     lv_db2-poq-sapdata1     75G
create_ext4_lvm  /db2/POQ/sapdata2     lv_db2-poq-sapdata2     75G
create_ext4_lvm  /db2/POQ/sapdata3     lv_db2-poq-sapdata3     75G
create_ext4_lvm  /db2/POQ/sapdata4     lv_db2-poq-sapdata4     75G
create_ext4_lvm  /db2/db2poq           lv_db2-db2poq           5G


