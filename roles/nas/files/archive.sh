#!/bin/bash

d=`date`
year=${d: -2}

if ls -d ${year}* &> /dev/null
then
    for run in `ls -d ${year}*`
    do
        pm archive swestore --package-run --pbzip2 --check-finished --send-to-swestore --swestore-path a2010002 --flowcell $run --clean-swestore --force --clean-from-staging &
    done
fi