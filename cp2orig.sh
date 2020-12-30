#!/bin/sh

#
# Восстанавливаем старые настройки bash
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


if [ -f $_home/.bashrc.new ]; then
  echo 'Restore new file'
  mv -vi $_home/.bash_profile.new $_home/.bash_profile
  mv -vi $_home/.bashrc.new       $_home/.bashrc
else 
  echo 'Restore origin file.'
  cp -vi $_home/.bash_profile $_home/.bash_profile.new
  cp -vi $_home/.bashrc       $_home/.bashrc.new

  cp -vi $_home/.bash_profile.orig $_home/.bash_profile
  cp -vi $_home/.bashrc.orig  $_home/.bashrc
fi
exit 0
