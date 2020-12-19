#!/bin/bash

export SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SCRIPTDIR/restic-storagebox-settings.sh

if [ ! -e $SCRIPTDIR/prebackup.d/ ]; then
    mkdir $SCRIPTDIR/prebackup.d/
fi

case "$1" in

   "init")
	   restic -r sftp://$USERNAME@$URL:23/$REPONAME init
	   ;;
   
   "backup")
		# Run any scripts in this directory. This can deal with dumping
		# databases, etc.

		run-parts $SCRIPTDIR/prebackup.d/

		for dir in $DIRS_TO_BACKUP; do
		    echo "Backup $dir"
		    DIR_EXCLUDE_FILE=$(echo $dir | sed 's/\//_/g').exclude.txt
		    if [ -f $DIR_EXCLUDE_FILE ]; then
		        EXCLUDES="--exclude-file $DIR_EXCLUDE_FILE"
		    else 
		        EXCLUDES=""     
		    fi
		    
			restic -r sftp://$USERNAME@$URL:23/$REPONAME backup $dir $EXCLUDES
		done

		# Delete old backups
		restic -r sftp://$USERNAME@$URL:23/$REPONAME forget --keep-within $KEEP_WITHIN --prune
		;;
		
    "snapshots")
        restic -r sftp://$USERNAME@$URL:23/$REPONAME snapshots
        ;;		
		
esac

