#!/bin/sh

os_ver=$(hostnamectl | grep "Operating System:" | awk '{print $5}')
if [ "x$os_ver" == "x7" ]; then
  rpm -Uvh https://repo.zabbix.com/zabbix/5.1/rhel/7/x86_64/zabbix-release-5.1-1.el7.noarch.rpm
  yum clean all
  yum install zabbix-agent
elif [ "x$os_ver" == "x8" ]; then
  rpm -Uvh https://repo.zabbix.com/zabbix/5.1/rhel/8/x86_64/zabbix-release-5.1-1.el8.noarch.rpm
  dnf clean all
  dnf install zabbix-agent
fi

if ! [[ -d /etc/zabbix ]]; then
  echo 'Zabbix folder /etc/zabbix not exist'
  exit 1
fi

cd /etc/zabbix
cp zabbix_agentd.conf zabbix_agentd.conf.`date +'%Y%m%dT%H%M%S'`
echo 'Include=/etc/zabbix/zabbix_agentd.d/*.conf' > zabbix_agentd.conf

sed -i -e 's|^\(PIDFile=\).*$|\1/tmp/zabbix_agentd.pid|' /usr/lib/systemd/system/zabbix-agent.service

cd /etc/zabbix/zabbix_agentd.d

cat<<EOFF>zabbix_agent.conf
PidFile=/tmp/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
DebugLevel=0
Server=192.168.64.21
ServerActive=192.168.64.21
ListenPort=10050
HostnameItem=system.hostname
HostMetadataItem=system.uname
StartAgents=3
RefreshActiveChecks=120
LogRemoteCommands=1
EOFF

cd /etc/logrotate.d
cat<<EOFF>zabbix-agent
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

# cat /etc/hosts

firewall-cmd --permanent --zone=public --add-port=10050/tcp
firewall-cmd --reload

set -x
systemctl daemon-reload
systemctl enable --now zabbix-agent
systemctl is-enabled zabbix-agent.service
set +x

# tail -f /var/log/zabbix/zabbix_agentd.log

exit 0
