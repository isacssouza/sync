dest=`zenity --entry --text='Enter the destination path'`
sync.sh $1 $dest | zenity --progress --pulsate --auto-kill --no-cancel --title="Synchronizing..." --text="$1\n-->\n$dest"
