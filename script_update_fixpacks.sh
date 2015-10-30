
sidadm=ecqadm
db2sid=db2ecq
DB2INSTALLER=/tmp/DB2_LUW_10.5_FP5_RDBMS_LINUX_/LINUXX86_64
SID=ECQ

# rsync -avz /sapmedia/IBM_DB2/DB2_LUW_10.5_FP5_RDBMS_LINUX_ /tmp/

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

# If you get DBI1086E, verify that there are no broken links in the /db2/db2smn/db2_software/adm
/db2/$db2sid/db2_software/instance/db2iupdt $db2sid
cd $DB2INSTALLER/

chmod a+rwx -R .

su - $db2sid
startdb
exit

su - $db2sid -c "cd $DB2INSTALLER ; ./db6_update_db.sh -d $SID"

su - $db2sid -c "cd $DB2INSTALLER ; db2 -z db6_update_db_out.log -tvf db6_update_db_out.sql ; "

su - $sidadm
startsap all
exit

