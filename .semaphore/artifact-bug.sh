#!/bin/bash
# credit goes to Van Eyck
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# this
set -Eeuo pipefail
trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# this script provides a workaround for SemaphoreCI bug where
# if artifact directory has only 1 file, there are issues
# with restoring/pulling such artifact into workflow/folder

# sanity check:
# make sure path is specified (1st parameter)
if [[ -z "${1:-}" ]]; then
    echo 'You forgot to specify path!'
    exit 1
fi

# sanity check:
# path should not start with a trailing slash
# see below (switch case) for explanations
if [[ "${1:0:1}" = '/'  ]]; then
    echo 'Path should not start with slash!'
    exit 1
fi

# sanity check:
# path should not end with a trailing slash
# see below (switch case) for explanations
if [[ "${1: -1}" = '/' ]] ; then
    echo 'Path should not contain trailing slash!'
    exit 1
fi

# script can either create or delete dummy files depending
# on the switch (2nd positional paramter) used; dummy
# files are created if file count is <2
case "${2:-}" in
    delete )
        echo 'Removing dummy files (bug fix workaround)...'
        echo 'Any removed files will be reported here!'
        echo ''
        find . -type f -path "*/$1/*" -name 'dummy*' -delete -exec echo "Removing... {}!" \;
        ;;
    *)
        # count files and save as integer
        I="$(find . -type f -path "*/$1/*" | wc -l)"

        # if count is less than 2, create dummy files
        if [[ "$I" -lt 2 ]]; then
            echo "Less than 2 files detected in the path $PWD!"

            # calculate how many dummy files are required
            N="$((2 - I))"

            # loop to create dummy files so that count > 2
            for (( i = 0; i < N; i++ )); do
                echo "Adding a dummy file 'dummy$i'!"
                touch "$PWD/$1/dummy$i"
            done
        else
            echo ''
            echo "Artifact bug workaround is not required (2+ files)!"
            echo ''
        fi
        ;;
esac
