#!/bin/bash
echo Mirror Sync Script

mirrors=( archlinux centos ubuntu-releases ubuntu )
dir=/opt/mirrorsync/scripts
arg=""
errors=0
exitcode=1
emailrecepient="sysadmin@example.com"                           // change this
emailsender="`whoami`@`hostname`"
emailsubject="Error while syncing linux mirrors on `hostname -s`"
format=" %-30s %-20s %-10s\n"
mailfile="$dir/status.mail"

function sync {
        for i in "${mirrors[@]}"
        do
                ($dir/$i.sh $arg)
                exitcode=$?
                if [[ $exitcode -ne "0" ]]
                then
                        (( errors += 1 ))
                fi
                printf "$format" "`date`" "$i" "$exitcode" >> $mailfile
                sleep 5
        done
}


if [[ $1 == "debug" ]]
then
        arg="debug"
fi

printf "" > $mailfile
printf "<pre>\n" >> $mailfile
printf "$format" "TIMESTAMP" "MIRROR" "EXITCODE" >> $mailfile

sync

printf "</pre>" >> $mailfile

if [[ $errors -ne "0" ]]
then
        echo sending mail
        ( (
        echo To: $emailrecepient
        echo From: $emailsender
        echo "Content-Type: text/html; "
        echo Subject: $emailsubject
        echo
        cat $mailfile
        ) | sendmail -t)
fi
(rm $mailfile)
