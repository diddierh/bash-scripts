#!/bin/bash
for i in `ls`
do
update-alternatives --install /usr/bin/$i $i `pwd`/$i 2000
done
