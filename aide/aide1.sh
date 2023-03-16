#!/bin/bash

#
#   Это более простой вариант проверки целостности файлов
#   по сравнению с https://www.rfxn.com/data-integrity-aide-for-host-based-intrusion-detection/
#   
#   Исходник https://www.hiroom2.com/2017/06/09/centos-7-file-integrity-check-with-aide/
#

# FILE: /etc/cron.daily/runaide
#
# 1. INSTALL: yum install aide mailx liblockfile postfix mutt
# 
# 2. Перед первым запуском отредактируйте /etc/aide.conf
# и запустите 
#
# aide --config-check
# aide --init
# cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
#
# 3. Создайте задачу cron
#
# cp aide1.sh /etc/cron.daily/aide
# chmod 755 /etc/cron.daily/aide

set -u

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

LOCK_FILE=/var/run/aide.lock
MAIL_ADDR=root@localhost
AIDE=$(which aide)
NICE=$(which nice)
RM=$(which rm)
CP=$(which cp)
CAT=$(which cat)
MAIL=$(which mail)
DOTLOCKFILE=$(which dotlockfile)
MKTEMP=$(which mktemp)

${DOTLOCKFILE} -p ${LOCK_FILE} || exit 1

TMP=$(${MKTEMP} -t aide.XXXXXX)
if [ $? -ne 0 ]; then
  echo "Can't create tmp file."
  exit 1
fi

trap "${RM} ${TMP} 2>/dev/null" 0

${NICE} -n 19 ${AIDE} --update >${TMP} 2>&1
ret=$?
if [ ${ret} -eq 0 ]; then
  # Nothing is changed.
  ${CP} /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
elif [ ${ret} -lt 8 ]; then
  # Some file is changed.
  ${CAT} ${TMP} | ${MAIL} -s "AIDE detects changes. Host: ${HOSTNAME}" ${MAIL_ADDR}
  ${CP} /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
else
  # Cannot update database.
  ${CAT} ${TMP} | ${MAIL} -s "AIDE fatal error. Host: ${HOSTNAME}" ${MAIL_ADDR}
fi

${DOTLOCKFILE} -u ${LOCK_FILE}


