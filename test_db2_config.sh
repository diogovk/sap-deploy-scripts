#!/bin/bash


DB2USER="$(cat /etc/passwd | grep ^db2 | head -1 |cut -f 1 -d:)"

DB2DB="$(su - $DB2USER -c 'echo $DB2DBDFT')"
echo User: $DB2USER
echo Database: $DB2DB

RET=0

tmpfile=$(mktemp)
su - $DB2USER -c 'db2 get db cfg for '"$DB2DB" > $tmpfile || {
  echo ERRO: Não foi possivel buscar a configuração do banco.
  RET=1
}


grep '(FAILARCHPATH) = /db2/'"$DB2DB" $tmpfile || {
  echo ERRO: Configuração de FAILARCHPATH parece estar errada
  RET=2
}

grep '(LOGARCHCOMPR1) = OFF' $tmpfile || {
  echo ERRO: Quando usar DDBoost deve-se desabilitar compressao de log
  RET=3
}

grep '(LOGARCHMETH1) = VENDOR:/usr/lib/ddbda/lib64/libddboostdb2.so' $tmpfile  &&
  grep '(LOGARCHOPT1) = @/opt/ddbda/config/db2_ddbda.cfg' $tmpfile &&
    grep '(VENDOROPT) = @/opt/ddbda/config/db2_ddbda.cfg' $tmpfile || {
      echo ERRO: Configuração de DDBoost está incorreta
      RET=4
}

grep '(NUM_DB_BACKUPS) = 30'  $tmpfile && 
  grep '(REC_HIS_RETENTN) = 30' $tmpfile &&
    grep '(AUTO_DEL_REC_OBJ) = ON' $tmpfile || {
      echo ERRO: Configuração de auto-prune está incorreta
      RET=5
}

rpm -q emcddbda || {
  echo ERRO: Pacote emcddbda é necessário e não está instalado.
  RET=6
}

rpm -q lgtoclnt-8.1.1.2-1.x86_64 && {
  echo ERRO: lgtoclnt-8.1.1.2-1.x86_64 é conhecido por causar problemas junto ao DDBoost.
  RET=7
} 
exit $RET
