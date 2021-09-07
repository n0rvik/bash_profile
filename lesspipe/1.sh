#!/bin/sh

set -u
set -e

_LESSPIPE=lesspipe-1.89

tar -xvf ${_LESSPIPE}.tar.gz
cd ${_LESSPIPE} && ./install.sh 
cd ..
[ -d ${_LESSPIPE} ] && rm -rf ${_LESSPIPE}/

