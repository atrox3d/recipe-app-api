#!/bin/bash
HELPERS_DIR="$(dirname ${BASH_SOURCE[0]})"
. "${HELPERS_DIR}/.private.env"

echo "current path --> $(pwd)"
echo "move to      --> ${NOTEBOOK_CODE_PATH}"
cd "${NOTEBOOK_CODE_PATH}"
echo "current path --> $(pwd)"
git pull
