#!/bin/bash

function syntax() {
    local SYNTAX=(
        "${BASH_SOURCE[0]} [ -a -d -c -C \"command\" -D \"dir1 dir2 ...\" -f -F -T -v LEVEL  ] [ dir1 dir2 ... ]"
        "-a: all test dirs"
        "-d: default test dirs"
        "-c: clear terminal"
        "-C: execute another command"
        "-D: use \"dir1 dir2 ...\""
        "-h: this help"
        "-f: enable flake8"
        "-F: run only flake8"
        "-T: docker run -T: Disable pseudo-tty allocation."
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
DOCKER_RUN_NO_TTY=""
#
#   parse command line options
#
while getopts ":acC:D:dfFhTv:" opt
do
		case $opt in
			a)
    		    #   test all directories
    		    echo "GETOPTS| -a: test all directories"
                TEST_DIRS=("${ALL_TEST_DIRS[@]}")
			;;
			c)
    		    #   clear the screen
                clear
    		    echo "GETOPTS| -c: clear the screen"
			;;
			C)
    		    #   execute arbitrary command inside docker container
    		    echo "GETOPTS| -C: execute command '$OPTARG' and exit"
                COMMAND="${OPTARG}"
			;;
			d)
		        #   test default directories
    		    echo "GETOPTS| -d: test default directories"
                TEST_DIRS=("${DEFAULT_DIRS[@]}")
			;;
			D)
    		    #   test directories inside provided quoted string
    		    echo "GETOPTS| -S: test directories in '$OPTARG'"
				read -r -a TEST_DIRS <<< "$OPTARG"
			;;
			f)
    		    #   run ALSO flake8
    		    echo "GETOPTS| -f: run ALSO flake8"
				FLAKE8=true
			;;
			F)
       		    #   run ONLY flake8
    		    echo "GETOPTS| -F: run ONLY flake8"
				ONLY_FLAKE8=true
			;;
            h)
    		    echo "GETOPTS| -h: show syntax and exit"
                syntax
                exit 0
            ;;
            T)
    		    echo "GETOPTS| -T: docker run, disable tty"
                DOCKER_RUN_NO_TTY="-T"
            ;;
            v)
    		    #   enable verbose unit test
    		    echo "GETOPTS| -v: enable verbose unit test with level: $OPTARG"
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
#   create command
#
if [ "${COMMAND}" == "false" ]
then
    COMMAND=""
    if [ "${ONLY_FLAKE8}" == "true" ]
    then
        #   run ONLY flake8
        COMMAND="echo \"flake8:\"; flake8 --count"
    elif [ "${FLAKE8}" == "true" ]
    then
        #   run ALSO flake8
        COMMAND="python manage.py test ${VERBOSE} ${TEST_DIRS[*]};echo \"flake8:\"; flake8 --count"
    else
        #   run ONLY tests
        COMMAND="python manage.py test ${VERBOSE} ${TEST_DIRS[*]}"
    fi
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
#   run command
#
echo "COMMAND  : "docker-compose run ${DOCKER_RUN_NO_TTY} app sh -c "$COMMAND"
echo "----------------------------------------------------------------------"
docker-compose run --rm ${DOCKER_RUN_NO_TTY} app sh -c "$COMMAND"


