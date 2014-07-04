#!/bin/bash
#
# install.sh
# by @pierowbmstr (me at e-piwi dot fr)
# <http://github.com/piwi/dotfiles.git>
# package installer script licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

#######################################################################
# script infos
declare -rx VERSION="1.0.0"
declare -rx NAME="piwi/dotfiles"
declare -rx REPO="http://github.com/piwi/dotfiles"
declare -rx USAGE=$(cat <<EOT
## ${NAME} installer & updater

This script will try to install or update all dotfiles and binaries of this clone in a directory
(by default, current user 'HOME'). The default behavior is to be fully interactive (the built-in 
'find' command used in this script needs to receive an 'y' answer to process).

usage:
     $0 [-h] [-V] [-f|--force] [-v|--verbose] <install_dir = \$HOME/>

options:
    -f|--force      : force installing all files (NOT interactive)
    -v|--verbose    : increase script verbosity
    -h|--help       : get this help information
    -V|--version    : get the script version

<${REPO}> - ${VERSION}
EOT
);
declare -x _FORCED=false
declare -x _VERBOSE=false
declare -rx DEFUSERDIR=$(cd ~ && pwd)
declare -rx HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
#######################################################################

if [ "$1" == '-h' ]||[ "$1" == '--help' ]||[ "$1" == 'help' ]
then
    echo "${USAGE}"
    exit 0
fi

if [ "$1" == '-V' ]||[ "$1" == '--version' ]||[ "$1" == 'version' ]
then
    echo "${NAME} ${VERSION} (${REPO})"
    exit 0
fi

if [ "$1" == '-f' ]||[ "$1" == '--force' ]
then
    export _FORCED=true
    shift
fi

if [ "$1" == '-v' ]||[ "$1" == '--verbose' ]
then
    export _VERBOSE=true
    shift
fi

# install directory
declare -x INSTALLDIR="${1:-${DEFUSERDIR}}"
if [ ! -d ${INSTALLDIR} ]
then
    echo "!! > unknown installation directory '${INSTALLDIR}'!"
    echo
    echo "${USAGE}"
    exit 1
fi

if $_FORCED
then
    FINDEXECTYPE='-exec '
else
    FINDEXECTYPE='-ok '
fi

# go to the clone directory
cd "${HERE}"

# how-to info
if ! $_FORCED
then
    echo
    echo "The installation process will begin ... Any prompt is waiting for an answer to validate the action or file:"
    echo "      - default answer is ALWAYS 'NO'"
    echo "      - you HAVE to type 'y' to validate a prompt"
    echo
fi

# update of submodules
$_VERBOSE && echo "> updating git sub-modules ..."
git submodule init
git submodule update

# installation of dotfiles
$_VERBOSE && echo "> installing dotfiles in '${INSTALLDIR}/' ..."
# symlink all but models
if $_FORCED
then
    find "$(cd home; pwd)" -maxdepth 1 -name "*.model" -prune -o -type f ${FINDEXECTYPE} ln -fs {} ${INSTALLDIR}/ \;
else
    find "$(cd home; pwd)" -maxdepth 1 -name "*.model" -prune -o -type f ${FINDEXECTYPE} ln -s {} ${INSTALLDIR}/ \;
fi
# copy and edit models
$_VERBOSE && echo "> installing dotfiles models in '${INSTALLDIR}/': first choose models to install then edit them ..."
for f in $(find "$(cd home; pwd)" -maxdepth 1 -name "*.model" -prune -type f ${FINDEXECTYPE} echo {} \;)
do
    ofn=`basename $f`
    tfn="${ofn/.model}"
    cp $f ${INSTALLDIR}/${tfn} && vim ${INSTALLDIR}/${tfn}
done

# installation of binaries
$_VERBOSE && echo "> installing binaries in '${INSTALLDIR}/bin/' ..."
if [ ! -d ${INSTALLDIR}/bin ]
then
    mkdir -p ${INSTALLDIR}/bin
fi
if $_FORCED
then
    find "$(cd bin; pwd)" -maxdepth 1 \( -name "bin" -o -name "*.model" -prune \) -o ${FINDEXECTYPE} ln -fs {} ${INSTALLDIR}/bin/ \;
else
    find "$(cd bin; pwd)" -maxdepth 1 \( -name "bin" -o -name "*.model" -prune \) -o ${FINDEXECTYPE} ln -s {} ${INSTALLDIR}/bin/ \;
fi

# installation of notes
$_VERBOSE && echo "> symlinking notes directory in '${INSTALLDIR}/notes/' ..."
if $_FORCED
then
    ln -fs "${HERE}/notes" ${INSTALLDIR}/
else
    ln -s "${HERE}/notes" ${INSTALLDIR}/
fi

exit 0
# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
