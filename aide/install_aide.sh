#!/bin/sh


# wget http://www.rfxn.com/downloads/install_aide
# sh install_aide "you@domain.com"

aide=`which aide`
force="$1"

# if aide is not installed OR cron is not present,  do install
if [ -z "$aide" ] || [ ! -f "/etc/cron.weekly/aide" ] || [ "$force" ]; then
    if [ "$1" ]; then
        email="$1"
    fi
    /usr/bin/yum install -y aide
    wget -t3 -T3 https://cdn.rfxn.com/downloads/aide.conf -O /etc/aide.conf
    chmod 640 /etc/aide.conf
    chmod 755 /etc/cron.hourly/runtime_aide
    wget -t3 -T3 https://cdn.rfxn.com/downloads/cron.aide -O /etc/cron.weekly/aide
    chmod 755 /etc/cron.weekly/aide
    ln -s /usr/bin/aide /usr/sbin/aide
    if [ "$email" ]; then
        sed -i "s/email=.*/email=$email/" /etc/cron.weekly/aide
    fi
    mkdir -p /var/lib/aide
fi
