#!/bin/sh

#
# Копирует файлы настроек bash в личную папку пользователя
#

cp -v ./.bash_aliases $HOME/.bash_aliases
cp -v ./.bash_profile $HOME/.bash_profile
cp -v ./.bashrc $HOME/.bashrc
cp -v ./.bashrc $HOME/.bash_logout
cp -v ./.dir_colors $HOME/.dir_colors

if [ ! "x$1" == "x" ]; then
  chown $1:$1 $HOME/.bash_aliases $HOME/.bash_profile $HOME/.bashrc $HOME/.dir_colors $HOME/.bash_logout
fi
