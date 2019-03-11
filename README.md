# Mattermost Shared Storage Recipe

## Problem

You are running a Mattermost cluster and want to use a shared data directory for file uploads, user images, and custom branding logos.

## Solution

Before you start, make sure there is a Samba/Windows share accessible to all servers in the cluster. 

1. Install `cifs-utils` so you can conn

```bash
sudo apt install cifs-utils
```

2. Create the directory where you'd like to mount the shared drive:

```bash
sudo mkdir -p /media/mmst-data/
```

3. Create the file `/opt/mattermost/config/smbcredentials` with the correct username and password to access the file share

```
username=samba_user
password=samba_password
```

4. Add the following line to the `/etc/fstab` file:

```
//<SHARE HOST>/<SHARE NAME>  /media/mmst-data  cifs  credentials=/opt/mattermost/config/smbcredentials,uid=998,gid=998,iocharset=utf8,rw  0  0
```

**Note:** Replace the `uid` and `gid` values with the user id and group id of the user running Mattermost on your system

5. Mount the shared drive:

```bash
sudo mount -a
```

6. Copy over any existing data:

```
rsync -av --progress /opt/mattermost/data/ /media/mmst-data/
```

7. Change the `FileSettings.Directory` value in the `config.json` to the path of the new shared directory.

8. Restart Mattermost


## Discussion

This guide used Ubuntu 18.04 as a reference system. The steps for most supported operating systems are similar.

Using a shared network device has obvious advantages over local storage. First, when running in a cluster it ensures all Mattermost application servers have access to the files, so links will always work. Second, this allows Mattermost to run on a system with minimal disk space. Finally, this can leverage your existing storage and backup systems, putting all your organization's files in one place.