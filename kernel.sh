
echo kernel.sem=1250 256000 100 1024 >> /etc/sysctl.conf
echo vm.max_map_count=2000000 >> /etc/sysctl.conf

sysctl -p

