#!/usr/bin/env bash
#
# auto-install.sh | auto-installer
# 
# This script will be called like:
#
#       mkdir TARGET_INSTLLATION_DIRECTORY_PATH/subdir
#       cd subdir
#       ./auto-install.sh TARGET_INSTALLATION_DIRECTORY_PATH/subdir
#

# do nothing if no argument (may be an error)
[ $# -eq 0 ] && return 0;

# the target directory is the only argument
TARGET_DIR="$1"

# global web directory
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
WEBROOT_DIR="$(get_absolute_path "${BASH_SOURCE[0]}")"

# the PHP binary
_PHP="$(which php) -d memory_limit=-1"

# the composer binary
_COMPOSER="$(which composer)"
if [ "$_COMPOSER" == '' ]; then
    cd "${TARGET_DIR}/../bin/"
    if [ -f "composer.phar" ]; then
        _COMPOSER="$(pwd)/composer.phar"
    elif [ -f "installers/getcomposer.sh" ]; then
        bash "installers/getcomposer.sh" "$(pwd)"
        _COMPOSER="$(pwd)/composer.phar"
    else
        echo "> 'composer.phar' binary not found !"
        exit 1
    fi
fi
_COMPOSER="${_PHP} ${_COMPOSER}"

# required files
to_install=( composer.json bower.json package.json phpinfo.php bootstrap.php projects-manager.php )
for _f in "${to_install[@]}"; do
    cp "${WEBROOT_DIR}/${_f}" "$TARGET_DIR";
done

# required dirs
to_install=( cgi-scripts vhosts )
for _f in "${to_install[@]}"; do
    cp --dereference -r "${WEBROOT_DIR}/${_f}" "$TARGET_DIR";
done

# projects installed in 'projects/'
cp "${WEBROOT_DIR}/../etc/projects.ini" "$TARGET_DIR";
cd "$TARGET_DIR"
${_PHP} projects-manager.php || exit 1;
cd "$WEBROOT_DIR"

# Third-party dependencies installed in 'dependencies/'
$_VERBOSE && echo "> installing Composer dependencies ..."
cd "$TARGET_DIR" && ${_COMPOSER} -v install || exit 1;
cd "$WEBROOT_DIR"

# DocBook installed in 'docbook/'
DOCBOOK_DIR="${TARGET_DIR}/docbook/"
DOCBOOK_VERSION="1.3.*@dev"
$_VERBOSE && echo "> installing docbook in '${DOCBOOK_DIR}' ..."
if [ ! -d "$DOCBOOK_DIR" ]; then
    cd "$TARGET_DIR"
    ${_COMPOSER} create-project atelierspierrot/docbook "$DOCBOOK_DIR" "$DOCBOOK_VERSION" --no-dev || exit 1;
fi

# DocBook contents
declare -a DOCBOOK_CONTENTS=(
    'https://gitlab.com/e-picas/mydocbook.git'
    'https://github.com/atelierspierrot/atelierspierrot.git'
    'https://gitlab.com/e-picas/private-docbook.git'
);
$_VERBOSE && echo "> installing docbook contents ..."
for _repo in "${DOCBOOK_CONTENTS[@]}"; do
    tmpdir="$DOCBOOK_DIR/www/$(basename ${_repo})"
    if [ ! -d "$tmpdir" ]; then
        cd "$DOCBOOK_DIR/www/" && git clone "${_repo}" || exit 1;
    else
        cd "$tmpdir" && \
            git stash save "automatic stashing before auto-update" \
            git pull --rebase || exit 1;
    fi
done

return 0
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
