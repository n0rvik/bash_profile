#!/bin/sh

#
# Копирует файлы настроек bash в личную папку пользователя
#

set -u

_home=$HOME
if [ ! "x$1" == "x" ]; then
   if [ -d "/home/$1" ]; then
     _home=/home/$1
   else
     echo "Directory not exist. Stop."
     exit 1
   fi
fi

mkdir -vp $_home/.config/backup
mkdir -vp $_home/.config/bashrc
mkdir -vp $_home/.config/bashrc.d

if [ ! "x$1" == "x" ]; then
  chown -Rv $1:$1 $_home/.config
fi

sfile=(.bash_aliases .bash_profile .bashrc .bash_logout .dir_colors .inputrc)

star=
for i in ${sfile[*]} ; do
  star="${star} $_home/${i}"
done

/bin/tar -cvf $_home/.config/backup/.profile.`date +'%Y%m%d-%H%M%S'`.tar ${star}
if [ ! "x$1" == "x" ]; then
  chown -Rv $1:$1 $_home/.config/backup
fi

for i in ${sfile[*]} ; do
  /bin/cp -v ./${i} $_home/${i}
  if [ ! "x$1" == "x" ]; then
    chown -v $1:$1 $_home/${i}
  fi
done



exit 0
