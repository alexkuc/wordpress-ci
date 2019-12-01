#!/bin/bash
# credit goes to Van Eyck and David Pashley
# see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# see https://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -Eeuo pipefail
# trap 'printf "\n[ERROR]: Error occurred at $BASH_SOURCE:$LINENO\n[COMMAND]: $BASH_COMMAND\n"' ERR

IS_SHELLCHECK=$(command -v shellcheck || true)

# reason for using sed in $CMD_COUNT
# https://stackoverflow.com/questions/30927590/wc-on-osx-return-includes-spaces/30927885#30927885

CMD_LS="find . -type f -name '*.sh' -not -path \"*/vendor/*\""
CMD_COUNT=$(eval "$CMD_LS" | wc -l | sed 's/^ *//')
CMD_SHELLCHECK="$CMD_LS | xargs shellcheck"

if [[ -n "$IS_SHELLCHECK" ]]; then
    echo ''
    echo 'Using local ShellCheck...'

    eval "$CMD_SHELLCHECK"
else
    echo ''
    echo 'Using Docker container with ShellCheck...'

    docker run --rm \
                -v "$PWD:/PWD" \
                -w "/PWD" \
           koalaman/shellcheck-alpine /bin/sh -c "cd /PWD && $CMD_SHELLCHECK"
fi

echo ''
echo "ShellCheck analysed $CMD_COUNT scripts"
echo ''
