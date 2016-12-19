
sidadm=podadm
db2sid=db2pod
DB2INSTALLER=/tmp/DB2_LUW_10.5_FP7SAP_RDBMS_LINUX_/LINUXX86_64
SID=POD

# rsync -avz /sapmedia/IBM_DB2/DB2_LUW_10.5_FP7SAP_RDBMS_LINUX_ /tmp/

set -e

su - $sidadm -c 'stopsap all'

tar -jcvf /backup/$db2sid.tar.bz2 /db2/$db2sid

su - $db2sid -c '
$DB2DIR/bin/ipclean;
$DB2DIR/das/bin/db2admin stop ;
db2ls '


cd $DB2INSTALLER/ESE/disk1/

# responda DB2DIR ; no
./installFixPack -f db2lib

# If you get DBI1086E, verify that there are no broken links in the /db2/db2smn/db2_software/adm
/db2/$db2sid/db2_software/instance/db2iupdt $db2sid
cd $DB2INSTALLER/

chmod a+rwx -R .

su - $db2sid -c startdb || true

su - $db2sid -c "cd $DB2INSTALLER ; ./db6_update_db.sh -d $SID"

su - $db2sid -c "cd $DB2INSTALLER ; db2 -z db6_update_db_out.log -tvf db6_update_db_out.sql ; " || true

su - $sidadm -c "startsap all"

