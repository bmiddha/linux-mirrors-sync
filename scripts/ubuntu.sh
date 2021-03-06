#!/bin/bash
## Mirror Synchronization Script

## Mirror name
name=Ubuntu

## Point our log file to somewhere and setup our admin email
log=/var/log/mirrorsync.ubuntu.log

## Setup the server to mirror
remote=rsync://archive.ubuntu.com/ubuntu/

## Setup the local directory 
local=/raid6-array/mirror/ubuntu/

## Initialize some other variables
complete="false"
failures=0
status=1
pid=$$

echo "`date +%x-%R` - $pid - Started $name Mirror Sync" >> $log
while [[ "$complete" != "true" ]]; do

        if [[ $failures -gt 0 ]]; then
                ## Sleep for 5 minutes for sanity's sake
                ## The most common reason for a failure at this point
                ##  is that the rsync server is handling too many concurrent connections.
                sleep 5m
        fi

        if [[ $1 == "debug" ]]; then
                echo "Working on attempt number $failures"
                rsync -rtlpH --safe-links --exclude="*.torrent" --bwlimit=4096 --delay-updates --delete-after --progress $remote $local
                status=$?
        else
                rsync -rtlpH --safe-links --exclude="*.torrent" --bwlimit=4096 --delay-updates --delete-after $remote $local >> $log
                status=$?
        fi
        
        if [[ $status -ne "0" ]]; then
                complete="false"
                (( failures += 1 ))
		if [[ $failures -gt "2" ]];then
			complete="false"
			exit 1
		fi
        else
                echo "`date +%x-%R` - $pid - Finished $name Mirror Sync" >> $log
        	complete="true"
        fi
done

exit 0
