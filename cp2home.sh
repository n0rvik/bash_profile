#!/bin/sh

#
# Копирует файлы настроек bash в личную папку пользователя
#

_home=$HOME
if [ ! "x$1" == "x" ]; then
   if [ -d "/home/$1" ]; then
     _home=/home/$1
   else
     echo "Directory not exist. Stop."
     exit 1
   fi
fi

mkdir -vp $_home/.config/bashrc
mkdir -vp $_home/.config/bashrc.d

sfile=(.bash_aliases .bash_profile .bashrc .bash_logout .dir_colors .inputrc)

for i in ${sfile[*]}; do
  if [ -f "$_home/${i}.orig"]; then
    /bin/cp -v $_home/${i}.orig $_home/${i}.bak
  fi
  if [ -f "$_home/${i}"]; then
    /bin/cp -v $_home/${i} $_home/${i}.orig
  fi
  /bin/cp -v ./${i} $_home/${i}
  if [ ! "x$1" == "x" ]; then
    chown -v $1:$1 $_home/${i}
    chown -v $1:$1 $_home/${i}.orig
    chown -v $1:$1 $_home/${i}.bak
  fi
done

exit 0
