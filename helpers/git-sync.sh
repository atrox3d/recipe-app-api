#!/bin/bash
HELPERS_DIR="$(dirname ${BASH_SOURCE[0]})"
. "${HELPERS_DIR}/.private.env"

echo "you are here: $(pwd)"
echo "cd ${NOTEBOOK_CODE_PATH}"

cd "${NOTEBOOK_CODE_PATH}"
echo "you are here: $(pwd)"

git pull
