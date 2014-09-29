#!/bin/bash

yum install zabbix-agent
sed -i 's/^Server=.*/Server=archdiogo/' /etc/zabbix/zabbix_agent.conf 
sed -i 's/^Server=.*/Server=archdiogo/' /etc/zabbix/zabbix_agentd.conf
service zabbix-agent start
chkconfig zabbix-agent on


