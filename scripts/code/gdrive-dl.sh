#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# this script allows to download files from Google Drive
# taken and adapted from https://gist.github.com/tanaikech/f0f2d122e05bf5f971611258c22c110f

# make sure to read "Update at March 21, 2019"
# https://gist.github.com/tanaikech/f0f2d122e05bf5f971611258c22c110f#update-at-march-21-2019

FILE_NAME="$1"
GDRIVE_ID="$2"
FILE_MD5="$3"

GDRIVE_URL1="https://drive.google.com/uc?export=download&id="
GDRIVE_URL2="https://drive.google.com/uc?export=download&confirm="

if [[ "$CI" == 'true' ]]; then
    # restore file from cache
    # SemaphoreCI restores caches on _partial_ key match
    # so even if MD5 is omitted, a match would still occur
    cache restore "$FILE_NAME-$FILE_MD5"
fi

if [[ -e "$FILE_NAME" ]]; then
    # either the file exists as it is a local development machine
    # or CI has successfully restored cache
    echo "Skipping download of the $FILE_NAME (file is already present!)"

    exit 0
fi

echo "Downloading file $FILE_NAME..."

# suppress progress bar from curl but keep errors (stderr)
# https://stackoverflow.com/a/21109454
curl -sS -c ./cookie -s -L "$GDRIVE_URL1${GDRIVE_ID}" > /dev/null
curl -sS -Lb ./cookie "$GDRIVE_URL2$(awk '/download/ {print $NF}' ./cookie)&id=${GDRIVE_ID}" -o "${FILE_NAME}"
rm cookie

if [[ -n "$FILE_MD5" ]]; then

    MD5_EXPECTED="$FILE_MD5  $FILE_NAME"
    MD5_ACTUAL="$(md5sum "$FILE_NAME")"

    if [[ "$MD5_ACTUAL" != "$MD5_EXPECTED" ]]; then

        echo ""
        echo "Failed to properly download $FILE_NAME!"
        echo "MD5 sum mismatch!"
        echo ""
        echo "Expected $MD5_EXPECTED!"
        echo "Received $MD5_ACTUAL!"
        echo ""
        echo "Removing corrupted download... $FILE_NAME"
        rm "$FILE_NAME"
        echo ""

        exit 1
    fi

    if [[ "$CI" == 'true' ]]; then
        cache store "$FILE_NAME-$FILE_MD5" "$FILE_NAME"
    fi

fi
