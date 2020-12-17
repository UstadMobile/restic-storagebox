#/bin/bash

# Your username as per the Hetzner storage box interface
USERNAME=u12345
URL=$USERNAME.your-storagebox.de
REPONAME=$HOSTNAME-repo

#Space separated list of files to backup
DIRS_TO_BACKUP="/home /etc"

# A password file that contains the encryption password for the 
# restic repo. $SCRIPTDIR is the path to restic-storagebox.sh
export RESTIC_PASSWORD_FILE=$SCRIPTDIR/restic-repo-password

#How long to keep backups for as per the --keep-within argument
#for restic.
KEEP_WITHIN="2m"

