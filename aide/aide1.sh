#!/bin/bash

# FILE: /etc/cron.daily/aide
# INSTALL: yum install aide mailx liblockfile postfix mutt
# aide --config-check
# aide --init
# cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
# cp aide1.sh /etc/cron.daily/aide
# chmod 755 /etc/cron.daily/aide

set -u

LOCK_FILE=/var/run/aide.lock
MAIL_ADDR=root@${HOSTNAME}
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


