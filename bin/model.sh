#!/bin/bash

#######################################################################
# script infos
VERSION="0.0.1-dev"
NAME="$0"
PRESENTATION="This script is a bash script model."
COMMONOPTS="hiqvxV"
USAGE="usage:  ${0}  [-${COMMONOPTS}]  [options [=value]]  <arguments>"
#HELP=

# library dir
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# use the smooth library
LIBFILE="$BASEDIR/piwi-bash-library.sh"
if [ -f "${LIBFILE}" ]; then source "${LIBFILE}"; else
    PADDER=$(printf '%0.1s' "#"{1..1000})
    printf "\n### %*.*s\n    %s\n    %s\n%*.*s\n\n" 0 $(($(tput cols)-4)) "ERROR! ${PADDER}" \
        "Unable to find required library file '${LIBFILE}'!" \
        "Sent in '$0' line '${LINENO}' by '`whoami`' - pwd is '`pwd`'" \
        0 $(tput cols) "${PADDER}";
    exit 1
fi
#######################################################################

echo 'YO'

exit 0
