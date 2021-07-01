#!/bin/bash

[ $# -ge 1 ] && {
    APP_NAME="$1"
} || {
    echo "ERROR| syntax: ${BASH_SOURCE[0]} APP_NAME"
    exit 1
}

echo docker-compose run app sh -c "python manage.py startapp ${APP_NAME}"
docker-compose run app sh -c "python manage.py startapp ${APP_NAME}"
