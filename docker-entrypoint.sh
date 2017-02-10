#!/bin/bash

if [ "$1" == "start" ]
then
	AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
	if [ -z "${S3_URL}" ]   
	then
		echo "Fatal: Please define S3_URL. Exiting now"
		exit 1
	fi
	echo "Starting download"
	aws s3 sync --quiet "${S3_URL}" /data
	touch /data/.completed
	echo "Download completed"
	while true
	do
		sleep ${INTERVAL:-60}
		if aws s3 sync --quiet --exclude ".completed" /data "${S3_URL}" 
		then
			echo "Upload completed"
		else
			echo "Upload failed, will retry"
		fi
	done		
else
	exec $@
fi

