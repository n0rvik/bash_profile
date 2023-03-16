#!/bin/bash

##    Работа скрипта зависит от настроек aide.conf.
##
##    1. Запретиь сжатие.
##
##    gzip_dbout=no
##    verbose=5
##    
##    2. Указать для логов новую папку
##    
##    
##    @@define LOGDIR /var/lib/aide
##    
##    
##    3. Указать базу для сравнения
##    
##    Просто добавляем эту запись
##    
##    database_new=file:@@{DBDIR}/aide.db.new
##    
##    
##    4. В скрипте изменить 
##    
##    compare="1"
##    
##    Новая база создается при любом проходе скрипта
##    
##    В скрипте есть параметр 
##    
##    compare="0"
##    
##    он определяет будут сравниваться данные или будут просто генериться заново
##    
##    При `compare="1"` данные сравниваются и если есть лог, он отсылается
##    
##    
##    5. Добавить в /etc/aide.conf
##    
##    # aide file
##    
##    !/var/lib/aide/aide.log.[0-9]+-[0-9]+$
##    !/var/lib/aide/aide.db.gz.[0-9]+-[0-9]+.gz$
##    !/var/lib/aide/aide.db.gz.[0-9]+-[0-9]+.gz.md5$
##    !/var/lib/aide/aide.db$
##    !/var/lib/aide/aide.db.new$
##    
##    
##    # Mail
##    !/mail
##    !/var/spool/mail
##    
##    # Log
##    !/var/log
##
##    6. Создать задачу cron.daily
##
##    cp aide.sh /etc/cron.daily/aide
##    chmod 755 /etc/cron.daily/aide
##


# SOURCE: https://www.rfxn.com/data-integrity-aide-for-host-based-intrusion-detection/

##
#             (C) 2002-2019, R-fx Networks <proj@rfxn.com>
#             (C) 2019, Ryan MacDonald <ryan@rfxn.com>
# This program may be freely redistributed under the terms of the GNU GPL v2
##
# Generate change logs with comparative execution against
# last execution database. This can be resource intensive
# and is best performed on remote systems with remotely
# stored database.
compare="1"

# E-mail addresses (comma spaced) for change reports, these can
# be very large; requires compare=1.
email="root@localhost"

# max age of local logs and databases in days
# default 90 days which results in ~1GB data path
maxage_days=7

# data path for aide databases
data=/var/lib/aide

# path to aide binary
aide=`which aide 2> /dev/null`

# timeout in seconds as maximum execution time for aide
runtime_timeout="14400"

####
nice=`which nice 2> /dev/null`
timeout=`which timeout 2> /dev/null`
move_file_timestamp() {
    file="$1"
    cp="$2"
    if [ -f "$file" ]; then
        size=`stat -c '%s' "$file"`
        if [ "$size" == "0" ]; then
            rm -f "$file"
            deleted=1
        fi
        if [ ! "$deleted" ]; then
            tstamp=`stat -c "%y" "$file" | tr '.' ' ' | tr -d ':-' | awk '{print$1"-"$2}'`
            if [ "$tstamp" ] && [ ! -f "${file}.${tstamp}" ]; then
                fname=`echo "$file" | sed 's/.new//'`
                if [ "$cp" ]; then
                    cp "$file" "${fname}.${tstamp}"
                else
                    mv "$file" "${fname}.${tstamp}"
                fi
                chmod 600 "${fname}.${tstamp}"
                echo "${fname}.${tstamp}"
            fi
        fi
    fi
    unset deleted sil file tstamp
}

# delete empty file log 
delnulsize_file() {
    file="$1"
    if [ -f "$file" ]; then
        size=`stat -c '%s' "$file"`
        if [ "$size" == "0" ]; then
            rm -f "$file"
        fi
    fi
    unset file size
}

if [ -f "$aide" ]; then
    dstamp=`date +"%Y%m%d-%H%M%S"`
    log=$data/aide.log
    cur_db=$data/aide.db
    new_db=$data/aide.db.new

    if [ ! -d "$data" ]; then
        mkdir -p $data
        chmod 700 $data
    else
        chmod 700 $data
    fi

    # if we find an existing aide.db, move it to time stamped file and gzip
    gzip_curdb=`move_file_timestamp "$cur_db"`
    test "$gzip_curdb" && gzip -f "$gzip_curdb" && md5sum "${gzip_curdb}.gz" > "${gzip_curdb}.gz.md5"

    # do the same with aide.log
    gzip_curlog=`move_file_timestamp "$log"`
    test "$gzip_curlog" && gzip -f "$gzip_curlog" && md5sum "${gzip_curlog}.gz" > "${gzip_curlog}.gz.md5"

    # is there a previous run aide.db.new? are we comparing?
    # if compare=1 then move it to current, otherwise timestamp
    # it and get it out of the way
    if [ -f "$data/aide.db.gz.last" ] && [ "$compare" == "1" ]; then
        cp "$data/aide.db.gz.last" "${cur_db}.gz"
        gunzip "${cur_db}.gz"
    else
        gzip_file=`move_file_timestamp "$new_db" `
        test "$gzip_file" && gzip -f "$gzip_file" && md5sum "${gzip_file}.gz" > "${gzip_file}.gz.md5"
    fi

    # generate new database (aide.db.new)
    $timeout $runtime_timeout $nice -n 19 $aide --init >> /dev/null 2>&1

    if [ "$compare" == "1" ]; then
        # perform comparative execution (aide.db & aide.db.new)
        $timeout $runtime_timeout $nice -n 19 $aide --compare >> /dev/null 2>&1
        rm -f $cur_db

        # move the new aide.db.new to timestamped file
        gzip_file=`move_file_timestamp "$new_db"`
        test "$gzip_file" && gzip -f "$gzip_file" && md5sum "${gzip_file}.gz" > "${gzip_file}.gz.md5"
        ln -fs "${gzip_file}.gz" $data/aide.db.gz.last
    else
        # move the new aide.db.new to timestamped file
        gzip_file=`move_file_timestamp "$new_db"`
        test "$gzip_file" && gzip -f "$gzip_file" && md5sum "${gzip_file}.gz" > "${gzip_file}.gz.md5"
        ln -fs "${gzip_file}.gz" $data/aide.db.gz.last

        # no comparison done, no need for log file
        rm -f $log
    fi

    delnulsize_file "$log"
    if [ "$compare" == "1" ] && [ "$email" ] && [ -f "$log" ]; then
        cat $log | mail -s "AIDE change report on $HOSTNAME" $email
        # move aide.log to timestamped file
        gzip_file=`move_file_timestamp "$log"`
        test "$gzip_file" && gzip -f "$gzip_file" && md5sum "${gzip_file}.gz" > "${gzip_file}.gz.md5"
    fi

    # delete files older than $maxage_days from aide data path
    find=`which find 2> /dev/null`
    if [ -f "$find" ] && [ "$data" ] && [ "$maxage_days" ]; then
        $find ${data} -type f -mtime +${maxage_days} -print0 | xargs -0 rm -f
    fi
fi
