#!/usr/bin/env bash



# global web directory
export WEBROOT_DIR=`pwd`

# temporary directory
export WEBTMP_DIR="${WEBROOT_DIR}/tmp/"
if [ ! -d $WEBTMP_DIR ]; then
    mkdir -p $WEBTMP_DIR
fi

# Third-party dependencies installed in 'dependencies/'
export DEPTS_DIR="${WEBROOT_DIR}/dependencies/"
if [ ! -d $DEPTS_DIR ]; then
    mkdir -p $DEPTS_DIR
fi
if [ ! -f $DEPTS_DIR/composer.lock ]; then
    cd $DEPTS_DIR && composer -v install --no-dev
else
    cd $DEPTS_DIR && composer -v update --no-dev
fi

# GitHub projects installed in 'projects/'
export PROJECTS_DIR="${WEBROOT_DIR}/projects/"
if [ ! -d $PROJECTS_DIR ]; then
    mkdir -p $PROJECTS_DIR
fi
if [ ! -f $PROJECTS_DIR/composer.lock ]; then
    cd $PROJECTS_DIR && composer -v install --no-dev
else
    cd $PROJECTS_DIR && composer -v update --no-dev
fi

# DocBook installed in 'docbook/'
export DOCBOOK_DIR="${WEBROOT_DIR}/docbook/"
export DOCBOOK_VERSION="1.3.*@dev"
if [ ! -d $DOCBOOK_DIR ]; then
    mkdir -p $DOCBOOK_DIR
    composer create-project atelierspierrot/docbook $DOCBOOK_DIR $DOCBOOK_VERSION --no-dev
fi

# DocBook contents
declare -a DOCBOOK_CONTENTS=(
    'https://github.com/piwi/mydocbook.git'
    'https://github.com/atelierspierrot/atelierspierrot.git'
    'https://bitbucket.org/pierowbmstr/private-docbook.git'
);
for _repo in "${DOCBOOK_CONTENTS[@]}"; do
    tmpdir="$DOCBOOK_DIR/www/`basename ${_repo}`"
    if [ ! -d $tmpdir ]; then
        cd $DOCBOOK_DIR/www/ && git clone "${_repo}"
    else
        cd $tmpdir && \
            git stash save "automatic stashing before auto-update" \
            git pull --rebase ;
    fi
done


# DEBUG
echo "WEBROOT_DIR=  ${WEBROOT_DIR}"
echo "WEBTMP_DIR=  ${WEBTMP_DIR}"
echo "DEPTS_DIR=  ${DEPTS_DIR}"
echo "PROJECTS_DIR=  ${PROJECTS_DIR}"
echo "DOCBOOK_DIR=  ${DOCBOOK_DIR}"
exit 0


# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
