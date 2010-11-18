#!/bin/bash

# set -x

# the name of the file used for keeping the time of the last sync
syncFile=/tmp/.lastSync

# the source is the first paramenter
src=$1

# the destiny is the second parameter
dest=$2

# Do an initial sync.
rsync -Phravz $src $dest

# create the sync file
touch $syncFile

while true 
do
    # Look for changed files after last $syncFiles change. 
    # This will give us the number of files changed after the last sync.
    changedNum=`find $src -cnewer $syncFile -type f | wc -l`
    
    echo "Number of files changed: $changedNum"
    
    if [ $changedNum -ne 0 ] # if at least one file was changed
    then
        # Do the sync
        rsync -Phravz $src $dest

        # touch the sync file to keep the last sync time
        touch $syncFile
    fi

    # Sleep some time so we don't eat all resources
    sleep 1
done
