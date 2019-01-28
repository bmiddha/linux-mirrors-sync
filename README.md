# linux-mirrors-sync

Easy to customize scripts to sync Linux mirrors.

`syncall.sh` Run scripts in `scripts/` and send and send an email if error occours

Use the `-d`flag on any of the scripts to enable debug mode. It will display the rsync progress.

# Systemd service and timer

Change the script path in the `mirrorsync.service` file.
Copy the service and timer files to systemd directory

Start and enable the timer with `systemctl enable mirrorsync.timer` `systemctl start mirrorsync.timer`
Check timer status with `systemctl list-timers`

# Logging

Logs are stored in `/var/log/mirrorsync.mirrorname.log`.
If not running as root you will need to create and change ownership of the files.

For example:
```
touch /var/log/mirrorsync.archlinux.log
chown mirrorsync:mirrorsync /var/log/mirrorsync.archlinux.log
```
