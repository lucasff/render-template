#!/usr/bin/env bash

catch() {
    {
        IFS=$'\n' read -r -d '' "${1}";
        IFS=$'\n' read -r -d '' "${2}";
        (IFS=$'\n' read -r -d '' _ERRNO_; return ${_ERRNO_});
    } < <((printf '\0%s\0%d\0' "$( ( ( ( { ${3}; echo "${?}" 1>&3-; } | tr -d '\0' 1>&4-) 4>&2- 2>&1- | tr -d '\0' 1>&4-) 3>&1- | exit "$(cat)") 4>&1-)" "${?}" 1>&2) 2>&1)
}

RENDER=/usr/local/bin/render-template
COMMAND="$RENDER -f=/tmp/data-file $INPUT_TEMPLATE"

echo "$INPUT_VARS" > /tmp/data-file

catch OUTPUT ERROR "$COMMAND"

echo "::set-output name={result}::{$OUTPUT}"
echo "::set-error name={error}::{$ERROR}"
