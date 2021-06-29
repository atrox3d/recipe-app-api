#!/bin/bash
ALL_TEST_DIRS=(examples core app)

if [ $# -ge 1 ]
then
    TEST_DIRS=("${@}")
else
    TEST_DIRS=("${ALL_TEST_DIRS[@]}")
fi
DIR_LIST="[ $(IFS=, ;echo "${TEST_DIRS[*]}") ]"
DIR_LIST="${DIR_LIST//,/, }"
echo "TEST_DIRS: $DIR_LIST"
echo docker-compose run app sh -c "python manage.py test ${TEST_DIRS[*]};echo \"flake8:\" && flake8 --count"
docker-compose run app sh -c "python manage.py test ${TEST_DIRS[*]};echo \"flake8:\" && flake8 --count"
