#!/bin/bash
#
# install.sh
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# package installer script licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

#######################################################################
# script infos
declare -rx VERSION="1.0.1"
declare -rx NAME="piwi/dotfiles"
declare -rx REPO="http://github.com/piwi/dotfiles"
declare -rx USAGE=$(cat <<EOT
## ${NAME} installer & updater

This script will try to install or update all dotfiles, binaries and sub-directories of this clone 
in a directory (by default, current user 'HOME'). The default behavior is to be fully interactive 
(the built-in 'find' command used in this script needs to receive an 'y' answer to process).

usage:
     $0 [-hV]
     $0 [-fv] <install_dir=\$HOME/> <type=all> <mode=symlinks>

arguments:
    install_dir = \$HOME      : installation target directory
    type        = all        : installation type in 'all', 'bin', 'home', 'subdirs' or any sub-directory name
    mode        = symlinks   : define the copy mode:
                                - 'symlinks' to symlink files from repository
                                - 'hard-copies' to copy files as new hard files

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
declare -rx AUTOINSTALLER='auto-install.sh'
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

# type of installation
declare -x INSTALLTYPE="${2:-all}"

# mode of installation
declare -x INSTALLMODE="${3:-symlinks}"

# no interaction in FORCED mode
LNOPTS='-s'
CPOPTS=''
if $_FORCED
then
    FINDEXECTYPE='-exec '
    LNOPTS+=' -f'
    CPOPTS+=' -f'
else
    FINDEXECTYPE='-ok '
fi

# go to the clone directory
cd "${HERE}"

# test if we are in a GIT clone
if [ ! -d .git ]
then
    export INSTALLMODE='hard-copies'
    echo "!! > current directory doesn't seem to be a clone of a GIT repository ... Installation mode automatically set on 'hard-copies'."
    read -p "do you want to continue ? [N/y] " _resp
    _resp="${_resp:-N}"
    if [ "${_resp}" != 'y' ]&&[ "${_resp}" != 'Y' ]
    then
        echo "_ abort"
        exit 0
    fi
fi

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
if [ -d .git ]
then
    $_VERBOSE && echo "> updating git sub-modules ..."
    git submodule init
    git submodule update
fi

# installation of dotfiles
if [ "${INSTALLTYPE}" == 'dotfiles' ]||[ "${INSTALLTYPE}" == 'home' ]||[ "${INSTALLTYPE}" == 'all' ]
then
    $_VERBOSE && echo "> installing dotfiles in '${INSTALLDIR}/' ..."
    # symlink all but models
    for f in $(find "$(cd home; pwd)" -maxdepth 1 -name "*.model" -prune -o -type f ${FINDEXECTYPE} echo {} \;)
    do
        if [ "${INSTALLMODE}" == 'hard-copies' ]
        then
            cp ${CPOPTS} ${f} ${INSTALLDIR}/
        else
            ln ${LNOPTS} ${f} ${INSTALLDIR}/
        fi
    done
    # copy and edit models
    $_VERBOSE && echo "> installing dotfiles models in '${INSTALLDIR}/': first choose models to install then edit them ..."
    for f in $(find "$(cd home; pwd)" -maxdepth 1 -name "*.model" -prune -type f ${FINDEXECTYPE} echo {} \;)
    do
        ofn=`basename $f`
        tfn="${ofn/.model}"
        cp ${CPOPTS} ${f} ${INSTALLDIR}/${tfn} && vim ${INSTALLDIR}/${tfn}
    done
fi

# installation of binaries
if [ "${INSTALLTYPE}" == 'bin' ]||[ "${INSTALLTYPE}" == 'binaries' ]||[ "${INSTALLTYPE}" == 'all' ]
then
    $_VERBOSE && echo "> installing binaries in '${INSTALLDIR}/bin/' ..."
    for f in $(find "$(cd bin; pwd)" -maxdepth 1 \( -name "bin" -o -name "*.model" -prune \) -o ${FINDEXECTYPE} echo {} \;)
    do
        [ ! -d ${INSTALLDIR}/bin ] && mkdir -p ${INSTALLDIR}/bin;
        if [ "${INSTALLMODE}" == 'hard-copies' ]
        then
            cp ${CPOPTS} ${f} ${INSTALLDIR}/bin/
        else
            ln ${LNOPTS} ${f} ${INSTALLDIR}/bin/
        fi
    done
fi

# installation of sub-directories
if [ "${INSTALLTYPE}" == 'subdirs' ]||[ "${INSTALLTYPE}" == 'subdirs' ]||[ "${INSTALLTYPE}" == 'all' ]
then
    $_VERBOSE && echo "> linking sub-directory in '${INSTALLDIR}/%s' ..."
    for d in $(find "$(pwd)" -mindepth 1 -maxdepth 1 \( -name ".git" -o -name "bin" -o -name "home" -o -name "modules" -prune \) -o -type d ${FINDEXECTYPE} echo {} \;)
    do
        odn=`basename $d`
        installer="${d}/${AUTOINSTALLER}"
        if [ ! -f "${installer}" ]
        then
            $_VERBOSE && echo "> linking '${odn}' directory in '${INSTALLDIR}/${odn}/' ..."
            if [ "${INSTALLMODE}" == 'hard-copies' ]
            then
                cp ${CPOPTS} -r "${HERE}/${odn}" ${INSTALLDIR}/
            else
                ln ${LNOPTS} "${HERE}/${odn}" ${INSTALLDIR}/
            fi
        else
            $_VERBOSE && echo "> calling internal installer in '${odn}' directory ..."
            mkdir -p ${INSTALLDIR}/${odn} && cd ${odn} && ${installer} "${INSTALLDIR}/${odn}";
        fi
    done
fi

exit 0

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
