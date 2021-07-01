#!/bin/bash

DEFAULT_IMAGE=recipe-app-api-no-postgres_app

if [ $# -ge 1 ]
then
    IMAGE="$1"
else
    IMAGE="${DEFAULT_IMAGE}"
fi

#echo docker-compose run app sh -c "django-admin.py startproject ${PROJECT_NAME} ${PROJECT_PATH}"
#docker-compose run app sh -c "django-admin.py startproject ${PROJECT_NAME} ${PROJECT_PATH}"
echo docker run --rm "${IMAGE}" sh -c "python manage.py test"
docker run --rm "${IMAGE}" sh -c "python manage.py test"
