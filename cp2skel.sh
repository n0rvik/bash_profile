#!/bin/sh

#
# Копирует файлы настроек bash в личную папку skel
#

_home=/etc/skel

cp -v ./.bash_aliases $_home/.bash_aliases
cp -v ./.bash_profile $_home/.bash_profile
cp -v ./.bashrc       $_home/.bashrc
cp -v ./.bash_logout  $_home/.bash_logout

