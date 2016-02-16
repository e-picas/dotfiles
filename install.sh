#!/usr/bin/env bash
#
# install.sh
# by @picas <http://picas.fr/>
# <http://github.com/e-picas/dotfiles.git>
# package installer script licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
set -e

#######################################################################
# script info
declare -rx VERSION="1.0.1"
declare -rx NAME="picas/dotfiles"
declare -rx REPO="http://github.com/e-picas/dotfiles"
declare -rx SYNOPSIS=$(cat <<EOT
usage:  $0 [-hVu] [-fv] <install_dir> <type=all> <mode=symlinks>
        $0 [-hVu] [-fv] <encrypt/decrypt> <file_path>
e.g.:   $0 \$HOME
        $0 -v \$HOME data
help:   $0 help
EOT
);
declare -rx USAGE=$(cat <<EOT
## ${NAME} installer & updater

This script will try to install or update all dotfiles, binaries and sub-directories of this clone
in a directory (for instance current user '\$HOME'). The default behavior is to be fully interactive
(the built-in 'find' command used in this script needs to receive an 'y' answer to process).

usage:
     $0 [-hVu]
     $0 [-fv] <install_dir> <type=all> <mode=symlinks>
     $0 [-fv] <encrypt/decrypt> <file_path>

e.g.:
     $0 \$HOME
     $0 -v \$HOME data

arguments:
    <install_dir>               : installation target directory
    <type>        = all         : installation type in 'all', 'bin', 'home', 'data'
    <mode>        = symlinks    : define the copy mode:
                                    - 'symlinks' to symlink files from repository
                                    - 'hard-copies' to copy files as new hard files
     <encrypt/decrypt>          : only process an encryption/decryption of a file contents
     <file_path>                : path of the file to encrypt/decrypt

options:
    -f|--force      : force installing all files (NOT interactive)
    -v|--verbose    : increase script verbosity
    -h|--help       : get this help information (alias: $0 help)
    -u|--usage      : get command synopsis (alias: $0)
    -V|--version    : get the script version (alias: $0 version)

Options must be written before any argument and must not be grouped.

<${REPO}> - version ${VERSION}
EOT
);

#######################################################################
## library

# resolve a link target
resolve_link() {
    $(type -p greadlink readlink | head -1) "$1"
}

# get an absolute dir path
abs_dirname() {
    local cwd="$(pwd)"
    local path="$1"
    while [ -n "$path" ]; do
        cd "${path%/*}"
        local name="${path##*/}"
        path="$(resolve_link "$name" || true)"
    done
    pwd
    cd "$cwd"
}

# usage and exit
usage() {
    echo "${USAGE}"
    exit "${1:-0}"
}

# version and exit
version() {
    echo "${NAME} ${VERSION} (${REPO})"
    exit "${1:-0}"
}

# synopsis and exit
synopsis() {
    echo "${SYNOPSIS}"
    exit "${1:-0}"
}

# add a log entry
logger() {
    echo "[$(date +"%Y/%m/%d:%H:%M:%S %z")] [$0] $@" >> "$LOG_FILE";
}

# info string (no exit) - to STDERR
verbose_echo() {
    $VERBOSE && info "[info]: $@";
}

# info string (no exit) - to STDERR
info() {
    {   echo
        echo -e "> $@"
    } >&2 ;
}

# warning string (no exit) - to STDERR
warning() {
    {   echo
        echo -e "> [warning]: $@"
    } >&2 ;
}

# error & exit - to STDERR
error() {
    {   echo
        echo -e "> [error]: $@"
        echo
        echo "${SYNOPSIS}"
    }  >&2
    exit 1
}

# prompt user for confirmation
user_confirm() {
    read -p "$@ ? [N/y] " _resp
    _resp="${_resp:-N}"
    if ! [[ "${_resp}" =~ ^([yY][eE][sS]|[yY])$ ]]
    then return 1
    else return 0
    fi
}

# prompt user for its password
get_encryption_password () {
    { read -s -p "your encryption password for file '${1}': " && echo "$REPLY"
    } >&1;
}
export -f get_encryption_password

# decrypt an encrypted file
decrypt_file() {
    local f="$1"
    [ ! -f "$f" ] && error "file '$f' not found!";
    local ofd="$(dirname "$f")"
    local ofn="$(basename "$f")"
    local tfn="${ofn/.encrypted}"
    local p="$(get_encryption_password "${tfn}" < /dev/tty; echo)"
    openssl enc -aes-256-cbc -a -salt -pass "pass:$p" -in "$f" -out "${ofd}/${tfn}" -d 2> /dev/null && rm -f "$f";
}
export -f decrypt_file

# encrypt a file
encrypt_file() {
    local f="$1"
    [ ! -f "$f" ] && error "file '$f' not found!";
    local ofd="$(dirname "$f")"
    local ofn="$(basename "$f")"
    local tfn="${ofn}.encrypted"
    local p="$(get_encryption_password "${ofn}" < /dev/tty; echo)"
    openssl enc -aes-256-cbc -a -salt -pass "pass:$p" -in "$f" -out "${ofd}/${tfn}" 2> /dev/null && rm -f "$f";
}
export -f encrypt_file

# symlink or copy any file but a model
process_dotfile() {
    local f="$1"
    [ ! -f "$f" ] && error "file '$f' not found!";
    if [ "${INSTALL_MODE}" == 'hard-copies' ]
    then
        cp ${CMDOPTS_CP} "${f}" "${INSTALL_DIR}/";
    else
        ln ${CMDOPTS_LN} "${f}" "${INSTALL_DIR}/";
    fi
}
export -f process_dotfile

# copy and edit a model
process_model() {
    local f="$1"
    [ ! -f "$f" ] && error "file '$f' not found!";
    local ofn="$(basename "$f")"
    local tfn="${ofn/.model}"
    cp ${CMDOPTS_CP} "${f}" "${INSTALL_DIR}/${tfn}" && vim "${INSTALL_DIR}/${tfn}" < /dev/tty;
}
export -f process_model

# copy and decrypt an encrypted file
process_encrypted() {
    local f="$1"
    [ ! -f "$f" ] && error "file '$f' not found!";
    local ofn="$(basename "$f")"
    cp ${CMDOPTS_CP} "${f}" "${INSTALL_DIR}/${ofn}";
    decrypt_file "${INSTALL_DIR}/${ofn}"
}
export -f process_encrypted

# installation of a binary
process_binary() {
    local f="$1"
    [ ! -e "$f" ] && error "path '$f' not found!";
    [ ! -d "${INSTALL_DIR}/bin" ] && mkdir -p "${INSTALL_DIR}/bin";
    if [ "${INSTALL_MODE}" == 'hard-copies' ]
    then
        cp ${CMDOPTS_CP} -r "${f}" "${INSTALL_DIR}/bin/";
    else
        ln ${CMDOPTS_LN} "${f}" "${INSTALL_DIR}/bin/";
    fi
}
export -f process_binary

# installation of a sub-directory
process_subdir() {
    local f="$1"
    [ ! -d "$f" ] && error "directory '$f' not found!";
    local odn="$(basename "$f")"
    local installer="${d}/${AUTOINSTALLER}"
    if [ ! -f "${installer}" ]
    then
        if [ "${INSTALL_MODE}" == 'hard-copies' ]
        then
            cp ${CMDOPTS_CP} -r "${SOURCE_DIR}/${odn}" "${INSTALL_DIR}/";
        else
            ln ${CMDOPTS_LN} "${SOURCE_DIR}/${odn}" "${INSTALL_DIR}/";
        fi
    else
        $VERBOSE && echo "> calling internal installer in '${odn}' directory ..."
        mkdir -p "${INSTALL_DIR}/${odn}" && cd "${odn}" && "${installer}" "${INSTALL_DIR}/${odn}";
    fi
}
export -f process_subdir

#######################################################################
## arguments

declare -x TARGET=''
declare -x INSTALL_DIR=''
declare -x INSTALL_TYPE='null'
declare -x INSTALL_MODE=''
declare -x FORCED=false
declare -x VERBOSE=false
declare -rx SOURCE_DIR="$(pwd)"
declare -rx AUTOINSTALLER='auto-install.sh'
declare -rx LOG_FILE="${SOURCE_DIR}/installer.log"
declare -x CMDOPTS_FINDEXECTYPE=''
declare -x CMDOPTS_LN=''
declare -x CMDOPTS_CP=''
declare -x CMDOPTS_SSL=''

if [ "$1" == '-h' ]||[ "$1" == '--help' ]||[ "$1" == 'help' ]; then
    usage
fi

if [ "$1" == '-V' ]||[ "$1" == '--version' ]||[ "$1" == 'version' ]; then
    version
fi

if [ "$1" == '-u' ]||[ "$1" == '--usage' ]||[ "$1" == 'usage' ]; then
    synopsis
fi

if [ "$1" == '-f' ]||[ "$1" == '--force' ]; then
    FORCED=true
    shift
fi

if [ "$1" == '-v' ]||[ "$1" == '--verbose' ]; then
    VERBOSE=true
    shift
fi

# prepare command options
# no interaction in FORCED mode
CMDOPTS_CP+='-L'
CMDOPTS_LN+='-s'
CMDOPTS_SSL+='enc -aes-256-cbc -a -salt'
if $FORCED
then
    CMDOPTS_FINDEXECTYPE+='-exec '
    CMDOPTS_LN+=' -f'
    CMDOPTS_CP+=' -f'
else
    CMDOPTS_FINDEXECTYPE+='-ok '
fi

# action to do
if [ $# -eq 0 ]; then
    synopsis 1

elif [ "$1" == 'decrypt' ]||[ "$1" == 'd' ]; then
    INSTALL_TYPE='decrypt'

    # target path
    TARGET="${2:-}"

elif [ "$1" == 'encrypt' ]||[ "$1" == 'c' ]; then
    INSTALL_TYPE='encrypt'

    # target path
    TARGET="${2:-}"

else
    # install directory
    INSTALL_DIR="${1}"

    # type of installation
    INSTALL_TYPE="${2:-all}"
    [ "${INSTALL_TYPE}" == 'dotfiles' ] && INSTALL_TYPE='home';
    [ "${INSTALL_TYPE}" == 'binaries' ] && INSTALL_TYPE='bin';
    [ "${INSTALL_TYPE}" == 'subdirs' ]  && INSTALL_TYPE='data';

    # mode of installation
    INSTALL_MODE="${3:-symlinks}"
    [ "${INSTALL_MODE}" == 'copy' ]     && INSTALL_TYPE='hard-copies';
    [ "${INSTALL_MODE}" == 'copies' ]   && INSTALL_TYPE='hard-copies';
    [ "${INSTALL_MODE}" == 'hard' ]     && INSTALL_TYPE='hard-copies';

fi

# export current variables
export  FORCED VERBOSE SOURCE_DIR AUTOINSTALLER LOG_FILE \
        TARGET INSTALL_DIR INSTALL_TYPE INSTALL_MODE \
        CMDOPTS_FINDEXECTYPE CMDOPTS_LN CMDOPTS_CP CMDOPTS_SSL;

#######################################################################
## process

# known install type?
if  [ "${INSTALL_TYPE}" != 'encrypt' ] && [ "${INSTALL_TYPE}" != 'decrypt' ] \
    && [ "${INSTALL_TYPE}" != 'home' ] && [ "${INSTALL_TYPE}" != 'bin' ] \
    && [ "${INSTALL_TYPE}" != 'data' ] && [ "${INSTALL_TYPE}" != 'all' ];
then
    synopsis
fi

# process encryption
if [ "${INSTALL_TYPE}" == 'encrypt' ]||[ "${INSTALL_TYPE}" == 'decrypt' ]; then
    if [ -z "${TARGET}" ]||[ ! -e "${TARGET}" ]; then
        error "path '${TARGET}' not found!"
    fi
    if [ "${INSTALL_TYPE}" == 'encrypt' ]
    then
        verbose_echo "encrypting file '${TARGET}'"
        encrypt_file "${TARGET}"

    else
        verbose_echo "decrypting file '${TARGET}'"
        decrypt_file "${TARGET}"

    fi
fi

# prepare installation
if [ "${INSTALL_TYPE}" == 'home' ]||[ "${INSTALL_TYPE}" == 'bin' ]||[ "${INSTALL_TYPE}" == 'data' ]||[ "${INSTALL_TYPE}" == 'all' ]; then

    # go to the clone directory
    verbose_echo "source directory is '${SOURCE_DIR}'"
    cd "${SOURCE_DIR}"

    # check if install directory exists
    if [ ! -d "${INSTALL_DIR}" ]
    then
        error "unknown installation directory '${INSTALL_DIR}'!"
    else
        verbose_echo "installation directory is '${INSTALL_DIR}'"
    fi

    # test if we are in a GIT clone
    if [ ! -d .git ]; then
        export INSTALL_MODE='hard-copies'
        info "current directory doesn't seem to be a clone of a GIT repository ... Installation mode automatically set on 'hard-copies'."
        if ! user_confirm 'do you want to continue'; then
            verbose_echo "user abort"
            exit 0
        fi
    fi

    # update of submodules
    if [ -d .git ] && [ -f .gitmodules ]; then
        info "current directory seems to embed GIT sub-modules."
        if user_confirm 'do you want to update them'; then
            verbose_echo "updating git sub-modules ...";
            git submodule init
            git submodule sync
            git submodule update
        fi
    fi

    # how-to info
    ! $FORCED && {
        info "The installation process will start ... Any prompt is waiting for an answer to validate the action or file:\n\
          - default answer is ALWAYS 'NO',\n\
          - you HAVE to type 'y' to validate a prompt.\n\
        ";
    };

fi

# installation of dotfiles
if [ "${INSTALL_TYPE}" == 'home' ]||[ "${INSTALL_TYPE}" == 'all' ]; then

    # symlink all but models
    verbose_echo "installing dotfiles in '${INSTALL_DIR}/' ..."
    find "$(cd home; pwd)" -maxdepth 1 \( -name "*.model" -o -name "*.encrypted" -prune \) -o -type f \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_dotfile "$0"' {} \;

    # copy and edit models
    verbose_echo  "installing dotfiles models in '${INSTALL_DIR}/': first choose models to install then edit them ..."
    find "$(cd home; pwd)" -maxdepth 1 -name "*.model" -prune -type f \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_model "$0"' {} \;

    # copy and decrypt encrypted files
    verbose_echo  "installing encrypted files in '${INSTALL_DIR}/' ; your password will be required ..."
    find "$(cd home; pwd)" -maxdepth 1 -name "*.encrypted" -prune -type f \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_encrypted "$0"' {} \;
fi

# installation of binaries
if [ "${INSTALL_TYPE}" == 'bin' ]||[ "${INSTALL_TYPE}" == 'all' ]; then
    verbose_echo  "installing binaries in '${INSTALL_DIR}/bin/' ..."
    find "$(cd bin; pwd)" -maxdepth 1 \( -name "bin" -o -name "*.model" -prune \) -o \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_binary "$0"' {} \;
fi

# installation of data sub-directories
if [ "${INSTALL_TYPE}" == 'data' ]||[ "${INSTALL_TYPE}" == 'all' ]; then
    verbose_echo  "linking sub-directory in '${INSTALL_DIR}/%s' ..."
    find "$(pwd)" -mindepth 1 -maxdepth 1 \( -name ".git" -o -name "bin" -o -name "home" -o -name "modules" -prune \) -o -type d \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_subdir "$0"' {} \;
fi

# done
! $FORCED && verbose_echo "_ done";

exit 0

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
