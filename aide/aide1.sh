#!/bin/sh

# FILE: /etc/cron.daily/aide
# INSTALL: yum install aide mailx liblockfile postfix mutt
# aide --config-check
# aide --init
# cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
# cp aide1.sh /etc/cron.daily/aide
# chmod 755 /etc/cron.daily/aide

LOCK_FILE=/var/run/aide.lock
MAIL_ADDR=root@localhost

dotlockfile -p ${LOCK_FILE} || exit 1

TMP=$(mktemp -t aide.XXXXXX)
trap "rm $TMP* 2>/dev/null" 0

aide --update > ${TMP} 2>&1
ret=$?
if [ ${ret} -eq 0 ]; then
  # Nothing is changed.
  cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
elif [ ${ret} -lt 8 ]; then
  # Some file is changed.
  cat ${TMP} | mail -s "AIDE detects changes. Host: $(hostname -f)" ${MAIL_ADDR}
  cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
else
  # Cannot update database.
  cat ${TMP} | mail -s "AIDE fatal error. Host: $(hostname -f)" ${MAIL_ADDR}
fi

dotlockfile -u ${LOCK_FILE}

