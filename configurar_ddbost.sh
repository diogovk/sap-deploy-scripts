#!/bin/bash

ask_sure() {
  echo tem certeza que deseja continuar?
  echo Ctrl-C para cancelar
  echo '<Enter> para continuar'
  read
}

rpm -q emcddbda || {
  echo Pacote emcddbda é necessário e não está instalado.
  exit 1
}

rpm -q lgtoclnt-8.1.1.2-1.x86_64 && {
  # o agente do Networker estava causando problemas na arquivamento de logs do DB2
  # Depois de instalar o agente mais antigo o erro parou de acontecer
  echo lgtoclnt-8.1.1.2-1.x86_64 é conhecido por causar problemas junto ao DDBoost.
  ask_sure
}

reinstall_lgtoclnt() {
    # apaga o agente networker e instala a versão 7.6 a partir de repositorio (interno)
  yum remove lgtoclnt -y
  rm -rf /nsr/
  yum install -y lgtoclnt-7.6.5-1.x86_64
  semanage fcontext -a -f -- -t textrel_shlib_t "/usr/lib/nsr/lib.*\.soa" && restorecon -R "/usr/lib/nsr" || true
}


set -e

# DEVICE_HOST define em qual dos servidores datadomain o DDBoost vai salvar o backup/logs
# O ideal é que fique no datacenter contrario a onde está o servidor.
grep '^DEVICE_HOST *=' /opt/ddbda/config/db2_ddbda.cfg && {
  echo Host está correto?
  ask_sure
}

# nome da instancia (ex: ECP)
echo Digite o nome da instancia:
read INSTNAME

DB2USER="$(cat /etc/passwd | grep ^db2 | head -1 |cut -f 1 -d:)"
[ -z "$DB2USER" ] && {
  echo Problema ao encontrar usuario DB2
  exit 2
}


# Os dois comandos abaixo são apenas para máquinas que não utilizam HADR
# 
/opt/ddbda/bin/ddbmadmin -U || true
/opt/ddbda/bin/ddbmadmin -P -z /opt/ddbda/config/db2_ddbda.cfg

[ ! -e /db2/boostcfg ] && ln -s /opt/ddbda/config /db2/boostcfg

su - $DB2USER -c "db2 update db cfg for $INSTNAME  using VENDOROPT @/opt/ddbda/config/db2_ddbda.cfg"  || true

su - $DB2USER -c "db2 update db cfg for $INSTNAME using LOGARCHMETH1 VENDOR:/usr/lib/ddbda/lib64/libddboostdb2.so LOGARCHOPT1 @/db2/boostcfg/db2_ddbda.cfg" || true

su - $DB2USER -c "db2 update db cfg for $INSTNAME using LOGARCHCOMPR1 OFF" || true

su - $DB2USER -c "db2 update db cfg for $INSTNAME using FAILARCHPATH /db2/$INSTNAME/log_archive " || true

echo Configuração executada com sucesso.
echo 'Agora é necessário reiniciar o banco se aplicação (stopsap all ; db2start) e executar um backup offline '
echo Para executar backup offline:
echo "  db2 backup DB $INSTNAME load /usr/lib/ddbda/lib64/libddboostdb2.so open 1 sessions options @/opt/ddbda/config/db2_ddbda.cfg"
echo 'Lembre-se de configurar o PURGE automático:
  db2 update db cfg for POP using REC_HIS_RETENTN 30
  db2 update db cfg for POP using NUM_DB_BACKUPS 30
  db2 update db cfg for POP using AUTO_DEL_REC_OBJ ON'


