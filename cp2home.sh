#!/bin/sh

#
# Копирует файлы настроек bash в личную папку пользователя
#

set -u

tmp_login=${1-}
tmp_home=$HOME

if [ ! "x$tmp_login" == "x" ]; then
   if [ -d "/home/$tmp_login" ]; then
     tmp_home=/home/$tmp_login
   else
     echo "Directory not exist. Stop."
     exit 1
   fi
fi

mkdir -vp $tmp_home/.config/backup
mkdir -vp $tmp_home/.config/bashrc
mkdir -vp $tmp_home/.config/bashrc.d

if [ ! "x$tmp_login" == "x" ]; then
  chown -Rv $tmp_login:$tmp_login $tmp_home/.config
fi

sfile=(.bash_aliases .bash_profile .bashrc .bash_logout .dir_colors)

star=
for i in ${sfile[*]} ; do
  star="${star} $tmp_home/${i}"
done

/bin/tar -cvf $tmp_home/.config/backup/.profile.`date +'%Y%m%d-%H%M%S'`.tar ${star}
if [ ! "x$tmp_login" == "x" ]; then
  chown -Rv $tmp_login:$tmp_login $tmp_home/.config/backup
fi

for i in ${sfile[*]} ; do
  /bin/cp -v ./${i} $tmp_home/${i}
  if [ ! "x$tmp_login" == "x" ]; then
    chown -v $tmp_login:$tmp_login $tmp_home/${i}
  fi
done

exit 0
