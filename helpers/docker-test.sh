#!/bin/bash

function syntax() {
    local SYNTAX=(
        "${BASH_SOURCE[0]} [ -a -d -c -C \"command\" -D \"dir1 dir2 ...\" -f -F -v LEVEL  ] [ dir1 dir2 ... ]"
        "-a: all test dirs"
        "-d: default test dirs"
        "-c: clear terminal"
        "-C: execute another command"
        "-D: use \"dir1 dir2 ...\""
        "-h: this help"
        "-f: enable flake8"
        "-F: run only flake8"
        "-v: set verbose level (0-3)"
        "directories to test (override -a -d -D options)"
    )
    echo "syntax:"
    for line in "${SYNTAX[@]}"
    do
        echo "$line"
    done
}
#
#   setup globals
#
ALL_TEST_DIRS=(examples core app)
DEFAULT_DIRS=(core app)
TEST_DIRS=("${DEFAULT_DIRS[@]}")
VERBOSE=""
FLAKE8=false
ONLY_FLAKE8=false
COMMAND=false

#
#   parse command line options
#
while getopts ":acC:D:dfFhv:" opt
do
		case $opt in
		    #
		    #   test all directories
		    #
			a)
                TEST_DIRS=("${ALL_TEST_DIRS[@]}")
			;;
		    #
		    #   clear the screen
		    #
			c)
                clear
			;;
		    #
		    #   execute arbitrary command inside docker container
		    #
			C)
                COMMAND="${OPTARG}"
			;;
		    #
		    #   test default directories
		    #
			d)
                TEST_DIRS=("${DEFAULT_DIRS[@]}")
			;;
		    #
		    #   test directories inside provided quoted string
		    #
			D)
				read -r -a TEST_DIRS <<< "$OPTARG"
			;;
		    #
		    #   run ALSO flake8
		    #
			f)
				FLAKE8=true
			;;
		    #
		    #   run ONLY flake8
		    #
			F)
				ONLY_FLAKE8=true
			;;
            h)
                syntax
                exit 0
            ;;
		    #
		    #   enable verbose unit test
		    #
            v)
                VERBOSE="-v${OPTARG}"
            ;;
			\?)
				echo "ERROR | unknown parameter -${OPTARG}"
                syntax
				exit 1
			;;
			:)
				echo "ERROR | missing value for parameter -${OPTARG }"
				exit 2
			;;
		esac
done
shift "$((OPTIND-1))"
#
#   override everything and use positional parameters as dirs
#
if [ $# -ge 1 ]
then
    TEST_DIRS=("${@}")
fi
#
#   show final parameters
#
DIR_LIST="[ $(IFS=, ;echo "${TEST_DIRS[*]}") ]"
DIR_LIST="${DIR_LIST//,/, }"
#
echo "TEST_DIRS: $DIR_LIST"
echo "FLAKE8   : $FLAKE8"
echo "ARGS     : ${*}"
#
#   run another command and exit
#
[ "${COMMAND}" != "false" ] && {
    echo docker-compose run app sh -c "${COMMAND}"
    docker-compose run app sh -c "${COMMAND}"
    exit
}
#
#   run ONLY flake8
#
[ "${ONLY_FLAKE8}" == "true" ] && {
    echo docker-compose run app sh -c "\"flake8:\"; flake8 --count"
    echo "----------------------------------------------------------------------"
    docker-compose run app sh -c "echo \"flake8:\"; flake8 --count"
    exit
}

if [ "${FLAKE8}" == "true" ]
then
    #
    #   run ALSO flake8
    #
    echo docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]};echo \"flake8:\"; flake8 --count"
    echo "----------------------------------------------------------------------"
    docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]};echo \"flake8:\"; flake8 --count"
else
    #
    #   run ONLY tests
    #
    echo docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]}"
    echo "----------------------------------------------------------------------"
    docker-compose run app sh -c "python manage.py test ${VERBOSE} ${TEST_DIRS[*]}"
fi
