#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
# trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

# check if shellcheck is installed locally or not
IS_SHELLCHECK=$(command -v shellcheck || true)

# reason for using sed in $CMD_COUNT
# https://stackoverflow.com/questions/30927590/wc-on-osx-return-includes-spaces/30927885#30927885

# internal variables:
# find all bash script files (.sh) excluding "vendor" and "node_modules" folders
CMD_LS="find . -type f -name '*.sh' -not -path \"*/vendor/*\" -not -path \"*/node_modules/*\""
# count how many bash script files were found
CMD_COUNT=$(eval "$CMD_LS" | wc -l | sed 's/^ *//')
# pass found files to shellcheck
CMD_SHELLCHECK="$CMD_LS | xargs shellcheck"

# execute either locally installed shellcheck or fallback to Docker image option
if [[ -n "$IS_SHELLCHECK" ]]; then
    echo ''
    echo 'Using local ShellCheck...'

    # execute locally installed shellcheck
    eval "$CMD_SHELLCHECK"
else
    echo ''
    echo 'Using Docker container with ShellCheck...'

    # use Docker image option to run shellcheck
    docker run --rm \
                -v "$PWD:/PWD" \
                -w "/PWD" \
           koalaman/shellcheck-alpine /bin/sh -c "cd /PWD && $CMD_SHELLCHECK"
fi

echo ''
echo "ShellCheck analysed $CMD_COUNT scripts"
echo ''
