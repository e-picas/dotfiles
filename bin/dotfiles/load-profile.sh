#!/usr/bin/env bash
#
# bash script model
#
#set -e

#######################################################################
# get_absolute_path()
get_absolute_path() {
    local cwd="$(pwd)"
    local path="$1"
    while [ -n "$path" ]; do
        cd "${path%/*}" 2>/dev/null;
        local name="${path##*/}"
        path="$($(type -p greadlink readlink | head -1) "$name" || true)"
    done
    pwd
    cd "$cwd"
}
# usage ()
usage () {
    echo "${USAGE}"
}
# error ( str='' )
error () {
    {   echo "> $*"
        echo '---'
        usage
    } >&2
    exit 1
}

string_to_upper() {
    echo "$@" | tr '[:lower:]' '[:upper:]';
    return 0
}

_timestamp="$(date +"%s")"
make_backup() {
    local _f="$1"
    mv "$_f" "${_f}.${_timestamp}"
}


#######################################################################
# library dir
BASEDIR="$(get_absolute_path "${BASH_SOURCE[0]}")"
PROFILES_BASEDIR="$(cd "$HOME/.profiles" 2>/dev/null && pwd)"

# script infos
USAGE="usage:  $0 <profile_name> [profiles_base_dir=$PROFILES_BASEDIR]
  i.e.  $0 default
        $0 default /home/alt/my-profiles/";

# arguments

# -h or --help : usage
if [ $# -eq 0 ] || [[ "$1" =~ ^--?h(elp)?$ ]]; then
    usage
    exit 0
fi

# user args
PROFILETOLOAD="$1"
PROFILES_DIR="${2:-${PROFILES_BASEDIR}}"

if [ ! -d "$PROFILES_DIR" ]; then
    error "profiles directory '$PROFILES_DIR' not found !"
fi
if [ ! -d "${PROFILES_DIR}/${PROFILETOLOAD}" ]; then
    error "profile '$PROFILETOLOAD' not found in '$PROFILES_DIR' !"
fi

#######################################################################


# generate proxy settings
TARGET="${HOME}/.bashrc_proxy"
echo '' > "$TARGET"

#Acquire::http::Proxy “http://LOGIN:PASSWORD@IP:PORT”;
for _type in http https ftp socks rsync; do
    varn="${_type}_proxy"
    declare "$varn"="$(cat "${PROFILES_DIR}/${PROFILETOLOAD}/${_type}-proxy")"
    echo "export ${varn}=\"${!varn}\"" >> "$TARGET"
    echo "export $(string_to_upper "${varn}")=\"\$${varn}\"" >> "$TARGET"
done

declare -a noproxydata=()
while IFS='' read -r line || [[ -n "$line" ]]; do
    noproxydata+=( "$line" )
done < "${PROFILES_DIR}/${PROFILETOLOAD}/no-proxy"
counter=1
_noproxy=''
for item in "${noproxydata[@]}"; do
    if [ $counter -lt "${#noproxydata[@]}" ]
    then
        _noproxy+="${item}, "
    else
        _noproxy+="${item}"
    fi
    let counter=counter+1
done
echo "export no_proxy=\"${_noproxy}\"" >> "$TARGET"
echo "export NO_PROXY=\"\$no_proxy\"" >> "$TARGET"

source "$TARGET"
echo "> file '$TARGET' generated and loaded"

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
