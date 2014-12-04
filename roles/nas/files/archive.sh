#!/bin/bash

d=`date`
year=${d: -2}

# Look for uncompressed runs
if ls -d ${year}*/ &> /dev/null
then
    for run in `ls -d ${year}*/`
    do
        pm archive swestore --package-run --pbzip2 --check-finished --send-to-swestore --swestore-path a2010002 --flowcell $run --clean-swestore --force --clean-from-staging &
    done
else
    echo "No runs found to tarball :-)"
fi

# Look for already compressed runs
if ls ${year}*bz2 &> /dev/null
then
   for run in `ls ${year}*bz2`
    do
        pm archive swestore --send-to-swestore --swestore-path a2010002 --tarball $run --clean-swestore --clean-from-staging &
    done
else
    echo "No tarballed runs found :-)"
fi