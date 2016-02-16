#!/usr/bin/env bash
#
# install.sh
# by @picas <http://picas.fr/>
# <http://github.com/e-picas/dotfiles.git>
# package installer script licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
set -e

#######################################################################
# global paths (update here to modify script's behavior)

declare -rx ENV_FILE='.env'
declare -rx DOTFILES_DIR='home'
declare -rx BINARIES_DIR='bin'
declare -rx MODULES_DIR='modules'
declare -rx KEYS_DIR='keys'
declare -rx DATA_DIR='data'
declare -rx MODELS_EXT='model'
declare -rx DIRS_EXT='dir'
declare -rx ENCRYPTED_EXT='enc'
# %TAG_NAME%
declare -rx TAG_MASK='%[A-Za-z0-9\-\_]\+%'
declare -rx TAG_MASK_OPENER='%'
declare -rx TAG_MASK_CLOSER='%'

#declare -rx MODELS_MASK="*.${MODELS_EXT}"
#declare -rx DIRS_MASK="*.${DIRS_EXT}"
#declare -rx ENCRYPTED_MASK="*.${ENCRYPTED_EXT}"

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
# each method must be exported: export -f fctname

# deep error (from functions when they are not used the right way)
die() {
    local msg="${1:-died}"
    echo "[fatal error] > \"${msg}\" thrown at ${BASH_SOURCE[1]}:${FUNCNAME[1]} at line ${BASH_LINENO[0]}" >&2;
    exit 1
}
export -f die

# resolve a link target
resolve_link() {
    $(type -p greadlink readlink | head -1) "$1"
}
export -f resolve_link

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
export -f abs_dirname

# usage and exit
usage() {
    echo "${USAGE}"
    exit "${1:-0}"
}
export -f usage

# version and exit
version() {
    echo "${NAME} ${VERSION} (${REPO})"
    exit "${1:-0}"
}
export -f version

# synopsis and exit
synopsis() {
    echo "${SYNOPSIS}"
    exit "${1:-0}"
}
export -f synopsis

# add a log entry
logger() {
    echo "[$(date +"%Y/%m/%d:%H:%M:%S %z")] [$0] $@" >> "$LOG_FILE";
}
export -f logger

# info string (no exit) - to STDERR
verbose_echo() {
    if $VERBOSE; then
        info "[info]: $@";
    fi
}
export -f verbose_echo

# info string (no exit) - to STDERR
info() {
    {   echo
        echo -e "> $@"
    } >&2;
}
export -f info

# warning string (no exit) - to STDERR
warning() {
    {   echo
        echo -e "!! > [warning]: $@"
    } >&2;
}
export -f warning

# error & exit - to STDERR
error() {
    {   echo
        echo -e "!! > [error]: $@"
        echo
        echo "${SYNOPSIS}"
    }  >&2;
    exit 1
}
export -f error

# prompt user for confirmation
user_confirm() {
    read -p "$@ ? [N/y] " _resp
    _resp="${_resp:-N}"
    if ! [[ "${_resp}" =~ ^([yY][eE][sS]|[yY])$ ]]
    then return 1
    else return 0
    fi
}
export -f user_confirm

# prompt user for its password
get_encryption_password () {
    { read -s -p "your encryption password for file '${1}': " && echo "$REPLY"
    } >&1;
}
export -f get_encryption_password

# decrypt an encrypted file
decrypt_file() {
    [ $# -lt 1 ] && die 'usage: `decrypt_file <filepath>`';
    local f="$1"
    [ ! -f "$f" ] && die "file '$f' not found!";
    local ofd="$(dirname "$f")"
    local ofn="$(basename "$f")"
    local tfn="${ofn/.${ENCRYPTED_EXT}}"
    local p="$(get_encryption_password "${tfn}" < /dev/tty; echo)"
    openssl enc -aes-256-cbc -a -salt -pass "pass:$p" -in "$f" -out "${ofd}/${tfn}" -d 2> /dev/null && rm -f "$f";
}
export -f decrypt_file

# encrypt a file
encrypt_file() {
    [ $# -lt 1 ] && die 'usage: `encrypt_file <filepath>`';
    local f="$1"
    [ ! -f "$f" ] && die "file '$f' not found!";
    local ofd="$(dirname "$f")"
    local ofn="$(basename "$f")"
    local tfn="${ofn}.${ENCRYPTED_EXT}"
    local p="$(get_encryption_password "${ofn}" < /dev/tty; echo)"
    openssl enc -aes-256-cbc -a -salt -pass "pass:$p" -in "$f" -out "${ofd}/${tfn}" 2> /dev/null && rm -f "$f";
}
export -f encrypt_file

path_exists() {
    local p="$1"
    if [ -f "$p" ]||[ -d "$p" ]||[ -h "$p" ]; then
        return 0
    fi
    return 1;
}
export -f path_exists

get_relative_source_path() {
    [ $# -lt 1 ] && die 'usage: `get_relative_source_path <filepath>`';
    echo "${1//${INSTALL_DIR}\//}";
}
export -f get_relative_source_path

get_relative_target_path() {
    [ $# -lt 1 ] && die 'usage: `get_relative_target_path <filepath>`';
    echo "${1//${TARGET}\//}";
}
export -f get_relative_target_path

copy_file() {
    [ $# -lt 2 ] && die 'usage: `copy_file <source_path> <target_path>`';
    local source="$1"
    path_exists "$source" || die "source path '$source' not found!";
    local target="$2"
    cp ${CMDOPTS_CP} -r "${source}" "${target}";
    return $?;
}
export -f copy_file

symlink_file() {
    [ $# -lt 2 ] && die 'usage: `symlink_file <source_path> <target_path>`';
    local source="$1"
    path_exists "$source" || die "path '$source' not found!";
    local target="$2"
    ln ${CMDOPTS_LN} "${source}" "${target}";
    return $?;
}
export -f symlink_file

# parse tags like `%TAGNAME%` in a file
parse_tags_in_file() {
    local f="$1"
    [ ! -f "$f" ] && die "file '$f' not found!";
    tags=($(grep -o "${TAG_MASK}" "$f"))
    for tag in "${tags[@]}"; do
        varname="${tag:${#TAG_MASK_OPENER}:-${#TAG_MASK_CLOSER}}"
        [ -n "${!varname}" ] && sed -i "s/${tag}/${!varname}/g" "$f";
    done
}
export -f parse_tags_in_file

# copy and edit a model
process_model() {
    local f="$1"
    [ ! -f "$f" ] && die "file '$f' not found!";
    local ofn="$(basename "$f")"
    local tfn="${ofn/.${MODELS_EXT}}"
    cp ${CMDOPTS_CP} "${f}" "${INSTALL_DIR}/${tfn}";
    parse_tags_in_file "${INSTALL_DIR}/${tfn}";
    vim "${INSTALL_DIR}/${tfn}" < /dev/tty;
}
export -f process_model

# symlink or copy any file
process_default() {
    local f="$1"

    echo "$(path_exists "$f")";

    path_exists "$f" || die "path '$f' not found!";
    if [ "${INSTALL_MODE}" == 'hard-copies' ]
    then
        copy_file "${f}" "${INSTALL_DIR}/$(get_relative_source_path "$f")";
    else
        symlink_file "${f}" "${INSTALL_DIR}/$(get_relative_source_path "$(dirname "$f")")";
    fi
}
export -f process_default

# copy and decrypt an encrypted file
process_encrypted() {
    local f="$1"
    path_exists "$f" || die "path '$f' not found!";
    local ofn="$(basename "$f")"
    cp ${CMDOPTS_CP} "${f}" "${INSTALL_DIR}/${ofn}";
    decrypt_file "${INSTALL_DIR}/${ofn}"
}
export -f process_encrypted

# installation of a binary
process_binary() {
    local f="$1"
    path_exists "$f" || die "path '$f' not found!";
    [ ! -d "${INSTALL_DIR}/${BINARIES_DIR}" ] && mkdir -p "${INSTALL_DIR}/${BINARIES_DIR}";
    process_default "$f"
    chmod a+x "${INSTALL_DIR}/$(get_relative_source_path "$f")"
}
export -f process_binary

# installation of a sub-directory
process_subdir() {
    local f="$1"
    [ ! -d "$f" ] && error "directory '$f' not found!";
    local odn="$(basename "$f")"
    process_default "${SOURCE_DIR}/${odn}"
}
export -f process_subdir

treat_directory() {
    local f="$1"
    [ ! -d "$f" ] && die "source directory '$f' not found!";
    local rf="$(get_relative_source_path "$f")"

    # copy and edit models
    verbose_echo "installing model files from '${f}' to '${rf}/' ; first choose models to install then edit them ..."
    find "$(cd "$f"; pwd)" -path "*.${DIRS_EXT}/*" -o \
        \( -name "*.${MODELS_EXT}" -prune \) -type f \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_model "$0"' {} \;

    # copy and decrypt encrypted files
    verbose_echo "installing encrypted files from '${f}' to '${rf}/' ; your password will be required for each file ..."
    find "$(cd "$f"; pwd)" -path "*.${DIRS_EXT}/*" -o \
        \( -name "*.${ENCRYPTED_EXT}" -prune \) -type f \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_encrypted "$0"' {} \;

    # copy or link sub-directories
    verbose_echo "installing sub-directories from '${f}' to '${rf}/' ..."
    find "$(cd "$f"; pwd)" -name "*.${DIRS_EXT}" -type d \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_subdir "$0"' {} \;

    # symlink all the rest
    verbose_echo "installing default files from '${f}' to '${rf}/' ..."
    find "$(cd "$f"; pwd)" -path "*.${DIRS_EXT}/*" -o \
        \( -name "*.${MODELS_EXT}" -o -name "*.${ENCRYPTED_EXT}" -prune \) -o -type f \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_default "$0"' {} \;
}
export -f treat_directory

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

elif [ "$1" == '-V' ]||[ "$1" == '--version' ]||[ "$1" == 'version' ]; then
    version

elif [ "$1" == '-u' ]||[ "$1" == '--usage' ]||[ "$1" == 'usage' ]; then
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

elif [ "$1" == 'encrypt' ]||[ "$1" == 'c' ]||[ "$1" == 'e' ]; then
    INSTALL_TYPE='encrypt'

    # target path
    TARGET="${2:-}"

else
    # install directory
    INSTALL_DIR="${1%/}"

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

    # go to the source directory
    verbose_echo "source directory is '${SOURCE_DIR}'"
    cd "${SOURCE_DIR}"

    # check if the target directory exists
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

    # update of submodules if required
    if [ -d .git ] && [ -f .gitmodules ]; then
        info "current directory seems to embed GIT sub-modules."
        if user_confirm 'do you want to update them'; then
            verbose_echo "updating git sub-modules ...";
            git submodule init
            git submodule sync
            git submodule update
        fi
    fi

    # load any .env file
    if [ -f "${ENV_FILE}" ]; then
        verbose_echo "loading environment file '${SOURCE_DIR}/${ENV_FILE}'"
        source "${ENV_FILE}"

        # if you have to check some programs
        if [ "${#REQUIRED_PROGS[@]}" -gt 0 ]; then
            for _prog in "${REQUIRED_PROGS[@]}"; do
                verbose_echo "checking that program '${_prog}' exists"
                type -P "$_prog" 1>&/dev/null || error "program '${_prog}' is required but is not installed!";
            done
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
    treat_directory "${SOURCE_DIR}/${DOTFILES_DIR}"
fi

# installation of binaries
if [ "${INSTALL_TYPE}" == 'bin' ]||[ "${INSTALL_TYPE}" == 'all' ]; then
    verbose_echo  "installing binaries in '${INSTALL_DIR}/${BINARIES_DIR}/' ..."
    find "$(cd "${BINARIES_DIR}"; pwd)" -maxdepth 1 \( -name "${BINARIES_DIR}" -o -name "*.${MODELS_EXT}" -prune \) -o \
        ${CMDOPTS_FINDEXECTYPE} bash -c 'process_binary "$0"' {} \;
fi

# installation of data sub-directories
if [ "${INSTALL_TYPE}" == 'data' ]||[ "${INSTALL_TYPE}" == 'all' ]; then
    treat_directory "${SOURCE_DIR}/${DATA_DIR}"
fi

# done
! $FORCED && verbose_echo "_ done";

exit 0

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
