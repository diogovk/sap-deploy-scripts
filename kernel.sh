
echo '# SAP settings
kernel.msgmni=1024
kernel.sem=1250 256000 100 1024
vm.max_map_count=2000000' >> /etc/sysctl.conf

sysctl -p

