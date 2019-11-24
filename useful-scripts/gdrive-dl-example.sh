#!/bin/bash -e

trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# scaffold/skeleton for using gdrive-dl.sh

FILE1_NAME="file_name"
FILE1_GDRIVE_ID="..."
FILE1_MD5="..."

./bin/wordpress/gdrive-dl.sh $FILE1_NAME $FILE1_GDRIVE_ID $FILE1_MD5
