#!/bin/bash

# Effectively disable core dumps in RHEL 6.X

echo "# Disable core dumps
*                 hard    core           0 " >> /etc/security/limits.conf


service abrtd stop
chkconfig abrtd off


