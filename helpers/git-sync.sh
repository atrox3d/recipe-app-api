#!/bin/bash
HELPERS_DIR="$(dirname ${BASH_SOURCE[0]})"
. "${HELPERS_DIR}/.private.env"

echo "you are here: $(pwd)"
echo "cd ${NB_PATH}"

cd "${NB_PATH}"
echo "you are here: $(pwd)"

git pull
