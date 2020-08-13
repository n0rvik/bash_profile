#!/bin/sh

rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all
yum install zabbix-agent

if [ $? -ne 0 ]; then
  echo "Error install zabbix-agent"
  exit 1
fi

cd /etc/zabbix

cp zabbix_agentd.conf zabbix_agentd.conf.orig

echo 'Include=/etc/zabbix/zabbix_agentd.d/*.conf' > zabbix_agentd.conf

cd /etc/zabbix/zabbix_agentd.d

cat <<EOFF >zabbix_agent.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=192.168.64.21
ServerActive=
ListenPort=10050
HostnameItem=system.hostname
HostMetadataItem=system.uname
StartAgents=3
RefreshActiveChecks=120
LogRemoteCommands=1
EOFF

cd /etc/logrotate.d
cat <<EOFF >zabbix-agent
/var/log/zabbix/zabbix_agentd.log {
        weekly
        rotate 4
        compress
        delaycompress
        missingok
        notifempty
        create 0664 zabbix zabbix
}
EOFF

exit 0
