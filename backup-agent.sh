#!/bin/bash
set -e

spinner(){
	counter=5
	while [ $counter -gt -1 ]
	do
		echo -ne ". \r"
		sleep 0.5
		echo -ne "| \r"
		sleep 0.5
		echo -ne "' \r"
		sleep 0.5
		counter=$(( $counter - 1 ))
	done
	
}

aws_config_validate(){
	aws s3 ls 1> /dev/null
	if [ $? -ne 0 ]
	then
		sudo kill -9 $spinner_pid
		echo "AWS cli is not configured for current user or user is not priviledged to access AWS S3. BackupAgent required aws s3 access to store backups. Exiting..."
		exit 0
	fi

}

read_paths_file(){
	echo ""
}

echo "Running BackupAgent..."
echo "> Testing AWS cli configuration"
spinner &
spinner_pid=$!
aws_config_validate
sudo kill -9 $spinner_pid
echo " "
echo "> Reading /etc/backup-agent/paths-to-backup file"
read_paths_file

