#!/bin/bash
#
# niximp - *NIX in my pocket
# Copyleft (c) 2013 Pierre Cassat and contributors
# <www.ateliers-pierrot.fr> - <contact@ateliers-pierrot.fr>
# License GPL-3.0 <http://www.opensource.org/licenses/gpl-3.0.html>
# Sources <http://github.com/atelierspierrot/niximp>
# 

#@!
#
# Variables to be public are prefixed by 'NIXIMP_'
# Variables to be private are prefixed by 'NIXIMPP_'
#
#@!

################################
#! script identity
declare -rx NIXIMP_NAME="NIXIMP"
declare -rx NIXIMP_VERSION="0.0.0"
declare -rx NIXIMP_DD=true

################################
#! flags
declare -x NIXIMP_FV=false
declare -x NIXIMP_FQ=false
declare -x NIXIMP_FI=false
declare -x NIXIMP_FF=false
declare -x NIXIMP_FD=false
#! cmd options
declare -rx NIXIMPP_OS=' enc -aes-256-cbc -a -salt'
#! niximp pass
declare -x NIXIMPP_P
declare -x NIXIMP_I
declare -x NIXIMP_TMP="tmp"
#! various
declare -x NIXIMP_OF="${NIXIMP_TMP}/`date +%s`.enc"
declare -x NIXIMP_IF="${NIXIMP_TMP}/`date +%s`.dec"
declare -x NIXIMPP_TEST

################################
# required piwi bash library
LIBFILE="./vendor/piwi-bash-library.sh"
if [ -f "$LIBFILE" ]; then source "$LIBFILE"; else
    PADDER=$(printf '%0.1s' "#"{1..1000})
    printf "\n### %*.*s\n    %s\n    %s\n%*.*s\n\n" 0 $(($(tput cols)-4)) "ERROR! $PADDER" \
        "Unable to find required library file '$LIBFILE'!" \
        "Sent in '$0' line '${LINENO}' by '`whoami`' - pwd is '`pwd`'" \
        0 $(tput cols) "$PADDER";
    exit 1
fi

################################
#! infos
USAGE=$(cat <<EOT
    $0  [-h | --help | help]  [-i | --usage | usage]
          [-x | --dry-run]  [-v | --verbose]  [-q | --quiet]  [-V]
EOT
);
HELP=$(cat <<EOT
## $NIXIMP_NAME ($NIXIMP_VERSION) - help

usage:
    $USAGE

options:
    -v | --verbose          Increase script's verbosity
    -q | --quiet            Decrease script's verbosity (no output except errors)
    -x | --dry-run          Make a dry run (nothing is done)
    -i | --usage            Show simple usage info
    -h | --help             Show this help info

You MUST use the equal sign for long options: '--long-option="my value"'.
EOT
);

#! lib overloading
OPTIONS_ALLOWED="p:t:${COMMON_OPTIONS_ALLOWED}"
LONG_OPTIONS_ALLOWED="pass:,test:,${COMMON_LONG_OPTIONS_ALLOWED}"

#! aliasing

################################
#! error ( str , status )
niximp_a () {
    echo "${1:-error} [$BASH_SOURCE:${FUNCNAME[1]}:${BASH_LINENO[0]}]" && exit "${2:-1}";
}
#! error & usage ( str , status )
niximp_b () {
    echo "${1:-error} [$BASH_SOURCE:${FUNCNAME[1]}:${BASH_LINENO[0]}]" && niximp_u "${2:-1}";
}
#! encrypt str ( str )
niximp_c () {
    [ $# -gt 0 ] && local s="$1" || niximp_a 'not enough arguments (1 expected)' 255;
    niximp_p && local p=$NIXIMPP_P
    echo "$s" | openssl $NIXIMPP_OS -pass pass:$p 2> /dev/null;
}
#! decrypt str ( str )
niximp_d () {
    [ $# -gt 0 ] && local s="$1" || niximp_a 'not enough arguments (1 expected)' 255;
    niximp_p && local p=$NIXIMPP_P
    echo "$s" | openssl $NIXIMPP_OS -d -pass pass:$p 2> /dev/null;
    [ $? -eq 0 ] || niximp_a 'wrong password';
}
#! encrypt file ( path , output )
niximp_e () {
    [ $# -gt 0 ] && local ifile="$1" || niximp_a 'not enough arguments (at least 1 expected)' 255;
    local ofile="${2:-${NIXIMP_OF}}";
    niximp_p && local p=$NIXIMPP_P
    if [ -f "$ifile" ]; then
        openssl $NIXIMPP_OS -pass pass:$p -in "$ifile" -out "$ofile" 2> /dev/null;
    else niximp_a "input file '$ifile' not found"
    fi
    $NIXIMP_V && echo "encrypted '$ifile' to '$ofile'" || echo "$ofile";
}
#! decrypt file ( path , output )
niximp_f () {
    [ $# -gt 0 ] && local ifile="$1" || niximp_a 'not enough arguments (at least 1 expected)' 255;
    local ofile="${2:-${NIXIMP_IF}}";
    niximp_p && local p=$NIXIMPP_P
    if [ -f "$ifile" ]; then
        openssl $NIXIMPP_OS -pass pass:$p -in "$ifile" -out "$ofile" -d 2> /dev/null;
        [ $? -eq 0 ] || niximp_a 'wrong password';
    else niximp_a "input file '$ifile' not found"
    fi
    $NIXIMP_V && echo "decrypted '$ifile' to '$ofile'" || echo "$ofile";
}
#! help ( status )
niximp_h () {
    echo "$HELP" && exit "${1:-0}";
}
#! init ( home , system , niximp_basedir )
niximp_i () {
    mkdir -p $NIXIMP_TMP
    export NIXIMP_PH="${1:-${HOME}}"
    export NIXIMP_PB=$NIXIMP_PH/bin
    export NIXIMP_PL=$NIXIMP_PH/bin/lib
    export NIXIMP_PC=$NIXIMP_PH/etc
    export NIXIMP_PW=$NIXIMP_PH/www
    export NIXIMP_PSH="${2:-/usr}"
    export NIXIMP_PSB=$NIXIMP_PSH/sbin
    export NIXIMP_PSL=$NIXIMP_PSH/share
    export NIXIMP_PSC=$NIXIMP_PSH/etc
    export NIXIMP_PSW=/var/www
    export NIXIMP_BD="${3:-.niximp}"
    export NIXIMP_ID=$NIXIMP_BD/ids
}
#! get passwd
niximp_p () {
    while [ -z $NIXIMPP_P ]; do
        read -s -p "niximp password: " answer;
        export NIXIMPP_P=$(echo $answer);
        echo 
    done
}


#! test
niximp_t () {
#    niximp_c "${1:-testouille}"
    niximp_d "${1:-U2FsdGVkX1++ksmzbD8NY1nhJjZ9qKngEVZv7hmQjIo=}"
}
#! usage ( status )
niximp_u () {
    echo "$USAGE" && exit "${1:-0}";
}
#! version ( status )
niximp_v () {
    $NIXIMP_FV && [ -n $(which git) ] && (
        echo "$NIXIMP_NAME $NIXIMP_VERSION `git rev-parse --abbrev-ref HEAD`@`git rev-parse HEAD`"
    ) || (
        $NIXIMP_FQ && echo "$NIXIMP_VERSION" || echo "$NIXIMP_NAME $NIXIMP_VERSION";
    ); exit "${1:-0}";
}

#! debug
niximp_x () {
    echo "## $NIXIMP_NAME $NIXIMP_VERSION `git rev-parse --abbrev-ref HEAD`@`git rev-parse HEAD`"
    echo "## $0 $*"
    printenv | grep 'NIXIMP_';
    if $NIXIMP_DD; then printenv | grep 'NIXIMPP_'; fi
    echo "##"
    exit 0
}


################################

#! front controller ( "$*" )
niximp_ctrl () {
    case $ARGUMENT in
        help) niximp_h && exit 0;;
        usage) niximp_u && exit 0;;
        version) niximp_v && exit 0;;
        debug) niximp_x "$*" && exit 0;;
        test) niximp_t;;
        crypt)
            getnextargument
            if [ -n "$ARGUMENT" ]; then
                [ -f "$ARGUMENT" ] && niximp_e "$ARGUMENT" || niximp_c "$ARGUMENT";
            else niximp_a 'no input found to encrypt!';
            fi
            ;;
        decrypt)
            getnextargument
            if [ -n "$ARGUMENT" ]; then
                [ -f "$ARGUMENT" ] && niximp_f "$ARGUMENT" || niximp_d "$ARGUMENT";
            else niximp_a 'no input found to decrypt!';
            fi
            ;;
    esac
}

#! options
rearrangescriptoptions "$@"
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -eq 0 ] && set -- "${SCRIPT_OPTS[@]}";
[ "${#SCRIPT_ARGS[@]}" -gt 0 -a "${#SCRIPT_OPTS[@]}" -eq 0 ] && set -- "${SCRIPT_ARGS[@]}";
[ "${#SCRIPT_OPTS[@]}" -gt 0 -a "${#SCRIPT_ARGS[@]}" -gt 0 ] && set -- "${SCRIPT_OPTS[@]}" -- "${SCRIPT_ARGS[@]}";

OPTIND=1
while getopts ":${OPTIONS_ALLOWED}" OPTION; do
    OPTARG="${OPTARG#=}"
#    echo "$OPTION : $OPTARG"
    case $OPTION in
#! common options
        h) SCRIPT_ARGS=('help' "${SCRIPT_ARGS[@]}");;
        i) NIXIMP_FI=true; NIXIMP_FQ=false;;
        f) NIXIMP_FF=true;;
        q) NIXIMP_FV=false; NIXIMP_FI=false; NIXIMP_FQ=true;;
        p) NIXIMPP_P="$OPTARG";;
        t) SCRIPT_ARGS=('test' "${SCRIPT_ARGS[@]}"); NIXIMP_TEST="$OPTARG";;
        v) NIXIMP_FV=true; NIXIMP_FQ=false;;
        V) SCRIPT_ARGS=('version' "${SCRIPT_ARGS[@]}");;
        x) NIXIMP_FD=true;;
        -)  LONGOPT="`getlongoption \"${OPTARG}\"`";
            LONGOPTARG="`getlongoptionarg \"${OPTARG}\"`";
            case $LONGOPT in
#! common options
                debug) SCRIPT_ARGS=('debug' "${SCRIPT_ARGS[@]}");;
                dry-run) NIXIMP_FD=true;;
                force) NIXIMP_FF=true;;
                help) SCRIPT_ARGS=('help' "${SCRIPT_ARGS[@]}");;
                interactive) NIXIMP_FI=true; NIXIMP_FQ=false;;
                man) SCRIPT_ARGS=('man' "${SCRIPT_ARGS[@]}");;
                quiet) NIXIMP_FV=false; NIXIMP_FI=false; NIXIMP_FQ=true;;
                pass*) NIXIMPP_P="$LONGOPTARG";;
                usage) SCRIPT_ARGS=('usage' "${SCRIPT_ARGS[@]}");;
                verbose) NIXIMP_FV=true; NIXIMP_FQ=false;;
                vers|version) SCRIPT_ARGS=('version' "${SCRIPT_ARGS[@]}");;
#! dev
                test*) SCRIPT_ARGS=('test' "${SCRIPT_ARGS[@]}"); NIXIMP_TEST="$OPTARG";;
#! '--' means the end of script options
                -) break;;
#! error for others
                *)  if [ -n "$LONGOPTARG" -a "`which $OPTARG`" ]
                    then SCRIPT_PROGRAMS+=( "${OPTARG}" )
                    else niximp_b "unknown option or missing argument"
                    fi;;
            esac ;;
        *)  niximp_b "unknown option or missing argument";;
    esac
done
export NIXIMP_FV NIXIMP_FI NIXIMP_FQ NIXIMP_FF NIXIMP_FD NIXIMPP_TEST NIXIMPP_P SCRIPT_PROGRAMS
niximp_i
getnextargument

#! action
if [ -n "$ARGUMENT" ]
then niximp_ctrl "$*";
else niximp_u && exit 0;
fi

# Enfile
