#!/bin/sh

git clone https://github.com/golang/go.git g
git clone g og

cd og || exit 1
gp=`pwd`
git checkout go1.4.2 || exit 1
cd src || exit 1
./all.bash || exit 2

cd ../.. || exit 1

cd g || exit 1
git checkout go1.6 || exit 1
cd src || exit 1
GOROOT_BOOTSTRAP="$gp" ./all.bash || exit 2

