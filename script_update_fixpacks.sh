
sidadm=poqadm
db2sid=db2poq
DB2INSTALLER=/tmp/DB2_LUW_10.5_FP5_RDBMS_LINUX_/LINUXX86_64
SID=POQ

set -e

su - $sidadm
stopsap all
exit

tar -jcvf /backup/$db2sid.tar.bz2 /db2/$db2sid



su - $db2sid
$DB2DIR/bin/ipclean
$DB2DIR/das/bin/db2admin stop

db2ls
exit


cd $DB2INSTALLER/ESE/disk1/

# responda DB2DIR ; no
./installFixPack -f db2lib


/db2/$db2sid/db2_software/instance/db2iupdt $db2sid
cd $DB2INSTALLER/

chmod a+rwx -R .

su - $db2sid
startdb
exit

su - db2poq -c "cd $DB2INSTALLER ; ./db6_update_db.sh -d $SID"

su - db2poq -c "cd $DB2INSTALLER ; db2 -z db6_update_db_out.log -tvf db6_update_db_out.sql ; "

su - $sidadm
startsap all
exit

