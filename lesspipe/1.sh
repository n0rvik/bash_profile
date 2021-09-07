#!/bin/sh

set -u
set -e

_LESSPIPE=lesspipe-1.89

tar -xvf ${_LESSPIPE}.tar.gz
cd ${_LESSPIPE} && make && make install
cd ..
[ -d ${_LESSPIPE} ] && rm -rf ${_LESSPIPE}/

