
set -e
NFS_OPTS="rsize=8192,wsize=8192,soft,timeo=5,retry=5,intr"
mkdir -p /sapmedia

grep -q 'srvspsolman01.malwee.com.br:/sapmedia /sapmedia' /etc/fstab || {
  echo "srvspsolman01.malwee.com.br:/sapmedia	/sapmedia	nfs	$NFS_OPTS	0 0" >> /etc/fstab
} 
mkdir -p /usr/sap/trans
grep -q 'srvsdpo01.malwee.com.br:/usr/sap/trans    /usr/sap/trans' /etc/fstab || {
  echo "srvsdpo01.malwee.com.br:/usr/sap/trans	/usr/sap/trans	nfs	$NFS_OPTS	0 0" >> /etc/fstab
}
mount -a

