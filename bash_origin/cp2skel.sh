#!/bin/sh

#
# Копирует файлы настроек bash в личную папку skel
#

_toskel=/etc/skel

#cp -v ./.bash_aliases $_toskel/.bash_aliases
cp -v ./.bash_profile $_toskel/.bash_profile
cp -v ./.bashrc       $_toskel/.bashrc
cp -v ./.bash_logout  $_toskel/.bash_logout

