#!/bin/sh

cp hotlist ~/.config/mc/hotlist
cp ini ~/.config/mc/ini
cp bashrc ~/.local/share/mc/bashrc
cat mc.menu | tee -a /etc/mc/mc.menu

sed -i -e 's/skin=.*/skin=xoria256/i' ~/.config/mc/ini
