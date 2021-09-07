#!/bin/sh

set -u
set -e

_GRC=grc-1.13

tar -xvf ${_GRC}.tar.gz
cd ${_GRC} && ./install.sh 
cd ..
[ -d ${_GRC} ] && rm -rf ${_GRC}/


