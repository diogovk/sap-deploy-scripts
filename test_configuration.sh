#!/bin/bash

check_service(){
  SERV="$1"
  service $SERV status || echo ERRO: $SERV  não está rodando
  chkconfig $SERV --list | grep '3:on' || {
    echo ERRO: $SERV não está habilitado no boot
  }
}

system_is_abap(){
  # if this file exists we assume this is an abap system
  [ -f /usr/sap/[A-Z][A-Z][A-Z]/*00/work/dw.sap* ]
}

abap_checks(){
  grep 'default_realm *= *MALWEE.COM.BR' /etc/krb5.conf || {
    echo 'ERRO: /etc/krb5.conf incompleto'
  }
  
  grep -q '^[^#].*/etc/kinit_sidadm.sh' /etc/crontab  && [ -x /etc/kinit_sidadm.sh ] && [ -f /etc/krb5.keytab ] || {
    echo 'ERRO: Problema no kinit'
  }

  grep 'snc/enable *= *1' /sapmnt/[A-Z][A-Z][A-Z]/profile/[A-Z][A-Z][A-Z]_*$(hostname) || {
    echo 'ERRO: SSO is not enabled 1'
  }
}


echo "### $(hostname) ### "
system_is_abap && abap_checks

subscription-manager release | grep 'Release: 6.5' || echo ERRO: Versao RedHat nao configurada para 6.5

grep '^server *ti-ad01.malwee.com.br' /etc/ntp.conf || echo ERRO: Sevidor NTP ti-ad01.malwee.com.br não encontrado
check_service ntpd


rpm -q ksh && rpm -q uuidd && rpm -q kernel-devel || {
  echo ERRO: kernel-devel, ksh e uuidd devem estar instalados
}

check_service uuidd

if rpm -q lgtoclnt ; then
  check_service networker
else
  echo ATENCAO: lgtoclnt não está instalado. Instale caso esta maquina faça backup de filesystem
fi

rpm -q yum-rhn-plugin && {
  echo ATENCAO: yum-rhn-plugin está instalado.
}

yum repolist 2>/dev/null | grep rhel-6-server-rpms && {
  echo ATENCAO: Repositorio RedHat esta habilitado
}

swapon -s | grep -q partition || {
  echo ERRO: Swap nao encontrado
}

[ -f /etc/yum.repos.d/srvspsld01.repo ] && grep -q 'keepcache=1' /etc/yum.conf || {
  echo ATENCAO: Revise configurações de servidor interno
}

grep -q '^kernel.msgmni=1024' /etc/sysctl.conf || {
  echo ERRO: Parametros de Kernel não estão setados em /etc/sysctl.conf
}


grep -q '@sapsys' /etc/security/limits.conf || {
  echo 'ERRO: Limites não encontrados em /etc/security/limits.conf '
}
uname -r | grep -q '2.6.32-431.29.2.el6.x86_64' || {
  echo 'ERRO: Versão de kernel incorreta'
}

grep -q 'CPIC_MAX_CONV=2000' /etc/environment || {
  echo 'ERRO: /etc/environment incompleto'
}



if hostname | grep malwee.com.br || hostname -f | grep -v malwee.com.br ; then
  echo 'ERRO: Problema com o hostname da máquina'
fi

grep -q 'nameserver *172.16.3.104' /etc/resolv.conf && grep 'search *malwee.com.br'  /etc/resolv.conf || {
  echo 'ERRO: Problema na configuração de DNS'
}

grep -q /usr/sap/trans'[ 	].*nfs' /etc/fstab || grep '^/usr/sap/trans' /etc/exports  || {
  echo 'ATENCAO: /usr/sap/trans deve ser exportado ou montado via NFS'
}

grep -q 'id:3:initdefault:' /etc/inittab || {
  echo 'ERRO: /etc/inittab deve estar como 3'
}


/usr/sap/hostctrl/exe/saphostexec -version | grep -q '^patch number.*190' || {
  echo 'ERRO: Patch number não está 190'
}

echo '#############


'
