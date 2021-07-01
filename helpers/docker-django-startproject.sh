#!/bin/bash

[ $# -ge 1 ] && {
    PROJECT_NAME="$1"
} || {
    echo "ERROR| syntax: ${BASH_SOURCE[0]} PROJECT_NAME [PROJECT_PATH=.]}"
    exit 1
}

[ $# -ge 2 ] && {
    PROJECT_PATH="$2"
} || {
    PROJECT_PATH=.
}

echo docker-compose run app sh -c "django-admin.py startproject ${PROJECT_NAME} ${PROJECT_PATH}"
docker-compose run app sh -c "django-admin.py startproject ${PROJECT_NAME} ${PROJECT_PATH}"
