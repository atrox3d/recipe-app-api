#!/bin/bash
ALL_TEST_DIRS=(examples/ core/)

if [ $# -ge 1 ]
then
    TEST_DIRS="${@}"
else
    TEST_DIRS="${ALL_TEST_DIRS[@]}"
fi

echo "TEST_DIRS: ${TEST_DIRS[@]}"
echo docker-compose run app sh -c "python manage.py ${TEST_DIRS} && echo \"flake8:\" && flake8 --count"
docker-compose run app sh -c "python manage.py test ${TEST_DIRS} && echo \"flake8:\" && flake8 --count"
