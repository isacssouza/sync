#!/bin/bash

# script to be used with nautilus-actions.
# $1 is the source/dir to be synced.

# ask user for the destination path.
dest=`zenity --entry --text='Enter the destination path. e.g. user@host:/path/to/dir/'`

# if not empty
if [ $dest ]
then
    #do the sync and pipe into a progress window. When the progess window dies, the sync dies too.
    sync.sh $1 $dest | zenity --progress --pulsate --auto-kill --title="Synchronizing..." --text="$1\n-->\n$dest\n\nPress Cancel to stop syncing."
fi
