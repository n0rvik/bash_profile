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

cp -v ./.bash_aliases $_home/.bash_aliases
cp -v ./.bash_profile $_home/.bash_profile
cp -v ./.bashrc       $_home/.bashrc
cp -v ./.bash_logout  $_home/.bash_logout
cp -v ./.dir_colors   $_home/.dir_colors

if [ ! "x$1" == "x" ]; then
  chown -v $1:$1 $_home/.bash_aliases \
                 $_home/.bash_profile \
                 $_home/.bashrc \
                 $_home/.dir_colors \
                 $_home/.bash_logout
fi

exit 0
