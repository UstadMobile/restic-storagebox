
# Restic Storage Box

Simple script designed to backup a dedicated or virtual server to Hetzner's Storage Box

To use:

1. In the Hetzner Robot, select your storage box and enable SSH.

2. Create an SSH on the server to be backed up and put this on
   the storage box to enable passwordless login for restic. Follow
   The instructions from Hetzner's docs here: 
   [https://docs.hetzner.com/robot/storage-box/backup-space-ssh-keys/](https://docs.hetzner.com/robot/storage-box/backup-space-ssh-keys/)
   
3.  Make a copy of this script somewhere

```
cd /opt
git clone https://github.com/UstadMobile/restic-storagebox.git
cd restic-storagebox
```

4. Copy the exmaple configuration and edit as needed

```
cp restic-storagebox-settings.example.sh restic-storagebox-settings.sh
# Edit and set your username and directories to backup
```

5. If you need to run something before the backup (e.g. database dump)
   then add an executable script (with no extension) to the prebackup.d
   directory.
   
```
mkdir prebackup.d
# Add a script
```

6. Generate a new, strong password that is the restic repo password.
   It will be required for any restore. 

```
echo strongpassword > restic-repo-password
chmod 600 restic-repo-password
```
   
7. Initialize the repo (one time)

```
./restic-storagebox init
```

8. Backup

```
./restic-storagebox backup
```


