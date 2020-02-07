#!/bin/bash
set -e
title='Installing BackupAgent'
spinner(){
	counter=5
	while [ $counter -gt -1 ]
	do
		echo -ne '%  ' ${title} '%  \r';
		sleep 0.5;
		echo -ne '-  ' ${title} '-  \r';
		sleep 0.5;
		echo -ne '\  ' ${title} '\  \r';
		sleep 0.5;
		#echo $counter;
		counter=$(( $counter-1 ))
	done
	


}


completed(){
	echo ' '
	echo 'Successfully installed BackupAgent! You can now start modifying /etc/backup-agent/files-to-backup to add files/directories that needs to be backed up.'
	
	echo 'BackupAgent uses AWS S3 to store backups, Use the user with which AWS cli is configured to run backup-agent.'
	
	echo 'You can now run backup-agent command from bash to run BackupAgent.'
}

echo '#### BackupAgent ####'

spinner &
spinner_pid=$!
sleep 3

if [ $( ls /etc/backup-agent/paths-to-backup 2> /dev/null | wc -l ) -ne 0 ] 
then
	kill -9 $spinner_pid
	echo "/etc/backup-agent/paths-to-backup already exists! BackupAgent will use this file to read paths which needs to be backed up."
else
	sudo mkdir -p /etc/backup-agent/
	sudo cp ./paths-to-backup /etc/backup-agent/paths-to-backup
	kill -9 $spinner_pid
fi

sudo rm -rf /opt/backup-agent/
sudo mkdir -p /opt/backup-agent/
sudo cp -a ./backup-agent.sh /opt/backup-agent/backup-agent.sh

if [ $(cat $HOME/.profile | grep 'backup-agent' | wc -l) -eq 0 ]
then
	echo 'PATH="/opt/backup-agent:$PATH"' >> $HOME/.profile
fi

sleep 3

completed

