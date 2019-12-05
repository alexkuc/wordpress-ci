#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# scaffold/skeleton for using gdrive-dl.sh

FILE1_NAME="..." # set the name of the file which will be saved to the cwd/pwd
FILE1_GDRIVE_ID="..." # can be obtained from shareable link
FILE1_MD5="" # optional - provide md5 checksum to safe guard against broken downloads

./scripts/other/gdrive-dl.sh "$FILE1_NAME" "$FILE1_GDRIVE_ID" "$FILE1_MD5"
