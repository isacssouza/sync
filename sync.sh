#!/bin/bash

# -d Run on debug mode
# -q Quiet mode

# check if the -d argument was given.
if [ `echo $* | grep -c "\-d"` -ne 0 ] 
then
    # set debug mode
    set -x
fi

# save the current stdout file descriptor
exec 3>&1

# check if the -q argument was given.
if [ `echo $* | grep -c "\-q"` -ne 0 ] 
then
    # set quiet mode. i.e. print on /dev/null
    exec 1>/dev/null
fi

# the name of the file used for keeping the time of the last sync
syncFile=/tmp/.lastSync

# the source is the first paramenter
src=$1

# the destiny is the second parameter
dest=$2


# check if the destiny is a remote connection.
if [ `echo $dest | grep -c "@"` -ne 0 ] 
then
    # get only the user@host from the destiny
    host=`echo $dest | sed -e 's/:.*//'`

    # keep a master connection for faster slave connections
    ssh -TMNf -S ~/.ssh/syncMaster $host
fi

# Do an initial sync.
rsync -e 'ssh -S ~/.ssh/syncMaster' -Phravz $src $dest

# create the sync file
touch $syncFile

while true 
do
    # Look for changed files after last $syncFiles change. 
    # This will give us the number of files changed after the last sync.
    changedNum=`find $src -cnewer $syncFile -type f | wc -l`
   
    if [ $changedNum -ne 0 ] # if at least one file was changed
    then
        echo "Number of files changed: $changedNum"
    
        # Do the sync
        rsync -e 'ssh -S ~/.ssh/syncMaster' -Phravz $src $dest 

        # touch the sync file to keep the last sync time
        touch $syncFile
    fi

    # Sleep some time so we don't eat all resources
    sleep 1
done
