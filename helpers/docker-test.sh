#!/bin/bash

ALL_TEST_DIRS=(examples core app)
DEFAULT_DIRS=(core app)
TEST_DIRS=("${DEFAULT_DIRS[@]}")
VERBOSE=""
FLAKE8=false
ONLY_FLAKE8=false

SYNTAX=(
    "${BASH_SOURCE[0]} [ -a -d -D \"dir1 dir2 ...\" -f -F -v LEVEL  ] [ dir1 dir2 ... ]"
    "-a: all test dirs"
    "-d: default test dirs"
    "-D: use \"dir1 dir2 ...\""
    "-h: this help"
    "-f: enable flake8"
    "-F: run only flake8"
    "-v: set verbose level (0-3)"
    "directories to test"
)


while getopts ":afFhD:dv:" opt
do
		case $opt in
			a)
                TEST_DIRS=("${ALL_TEST_DIRS[@]}")
			;;
			d)
                TEST_DIRS=("${DEFAULT_DIRS[@]}")
			;;
			D)
				read -r -a TEST_DIRS <<< "$OPTARG"
			;;
			f)
				FLAKE8=true
			;;
			F)
				ONLY_FLAKE8=true
			;;
            h)
				echo "syntax:"
                for line in "${SYNTAX[@]}"
                do
                    echo "$line"
                done
                exit 0
            ;;
            v)
                VERBOSE="-v${OPTARG}"
            ;;
			\?)
				echo "ERROR | unknown parameter -${OPTARG}"
				echo "syntax:"
                for line in "${SYNTAX[@]}"
                do
                    echo "$line"
                done
				exit 1
			;;
			:)
				echo "ERROR | missing value for parameter -${OPTARG }"
				exit 2
			;;
		esac
done
shift "$((OPTIND-1))"

if [ $# -ge 1 ]
then
    TEST_DIRS=("${@}")
fi

DIR_LIST="[ $(IFS=, ;echo "${TEST_DIRS[*]}") ]"
DIR_LIST="${DIR_LIST//,/, }"
echo "TEST_DIRS: $DIR_LIST"
echo "FLAKE8   : $FLAKE8"
echo "ARGS     : ${*}"


[ "${ONLY_FLAKE8}" == "true" ] && {
    echo docker-compose run app sh -c "\"flake8:\"; flake8 --count"
    docker-compose run app sh -c "echo \"flake8:\"; flake8 --count"
    exit
}

[ "${FLAKE8}" == "true" ] && {
    echo docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]};echo \"flake8:\"; flake8 --count"
    docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]};echo \"flake8:\"; flake8 --count"
} || {
    echo docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]}"
    docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]}"
}
