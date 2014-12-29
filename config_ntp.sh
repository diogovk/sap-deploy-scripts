
# habilita NTP no boot
chkconfig ntpd on

echo "adicione:
  server malwee.com.br
  server ti-ad01.malwee.com.br
  server ti-ad02.malwee.com.br
em /etc/ntp.conf e então execute:
  service ntpd restart"


