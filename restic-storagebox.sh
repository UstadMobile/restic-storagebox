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
		
		if [ -f $SCRIPTDIR/excludes.txt ]; then
	        EXCLUDES="--exclude-file=$DIR_EXCLUDE_FILE"
	    else 
	        EXCLUDES=""     
	    fi
		
		restic -r sftp://$USERNAME@$URL:23/$REPONAME backup $DIRS_TO_BACKUP $EXCLUDES 

		# Delete old backups
		if [ "$KEEP_ARGS" != "" ]; then
		    restic -r sftp://$USERNAME@$URL:23/$REPONAME forget $KEEP_ARGS --prune
    	else
    	    echo "restic-storagebox: WARNING: no setting given for forget / prune"
    	fi    
		
		;;
		
    "snapshots")
        restic -r sftp://$USERNAME@$URL:23/$REPONAME snapshots
        ;;		
		
esac

