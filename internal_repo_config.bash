#!/bin/bash

yum-config-manager --disable rhel-6-server-cf-tools-1-rpms
yum-config-manager --disable rhel-6-server-rpms

cat > /etc/yum.repos.d/srvspsld01.repo  << \EOF
[rhel-local]
gpgcheck=0
name=Red Hat Linux $releasever - $basearch - For Malwee
baseurl=http://srvspsld01/
EOF

sed -i s/^keepcache=0/keepcache=1/ /etc/yum.conf 
# We use subscription manager instead of RHN
yum -y remove yum-rhn-plugin

yum clean all

