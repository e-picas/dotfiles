#!/usr/bin/env bash

#
# auto-install.sh | auto-installer
# 
# This script will be called like:
#
#       mkdir TARGET_INSTLLATION_DIRECTORY_PATH/subdir
#       cd subdir
#       ./install.sh TARGET_INSTALLATION_DIRECTORY_PATH/subdir
#

# do nothing if no argument (may be an error)
[ $# -eq 0 ] && return 0;

# the target directory is the only argument
TARGET_DIR=$1

# global web directory
WEBROOT_DIR=`pwd`

# the composer binary
_COMPOSER=$(which composer)
if [ "${_COMPOSER}" == '' ]; then
	$_VERBOSE && echo "> installing the 'composer.phar' binary ..."
	cd $WEBROOT_DIR
	./getcomposer.sh
	_COMPOSER="${WEBROOT_DIR}/composer.phar"
fi

# temporary directory
WEBTMP_DIR="${TARGET_DIR}/tmp/"
if [ ! -d $WEBTMP_DIR ]; then
	$_VERBOSE && echo "> creating 'tmp' sub-directory ..."
	mkdir -p $WEBTMP_DIR
fi

# Third-party dependencies installed in 'dependencies/'
DEPTS_DIR="${TARGET_DIR}/dependencies/"
$_VERBOSE && echo "> installing dependencies in '${DEPTS_DIR}' ..."
if [ ! -d $DEPTS_DIR ]; then
	ln -s "`pwd`/dependencies" $TARGET_DIR/
fi
if [ ! -f $DEPTS_DIR/composer.lock ]; then
	cd $DEPTS_DIR && ${_COMPOSER} -v install --no-dev
else
	cd $DEPTS_DIR && ${_COMPOSER} -v update --no-dev
fi
cd $WEBROOT_DIR

# GitHub projects installed in 'projects/'
PROJECTS_DIR="${TARGET_DIR}/projects/"
$_VERBOSE && echo "> installing projects in '${PROJECTS_DIR}' ..."
if [ ! -d $PROJECTS_DIR ]; then
	ln -s "`pwd`/projects" $TARGET_DIR/
fi
if [ ! -f $PROJECTS_DIR/composer.lock ]; then
	cd $PROJECTS_DIR && ${_COMPOSER} -v install --no-dev
else
	cd $PROJECTS_DIR && ${_COMPOSER} -v update --no-dev
fi
cd $WEBROOT_DIR

# DocBook installed in 'docbook/'
DOCBOOK_DIR="${TARGET_DIR}/docbook/"
DOCBOOK_VERSION="1.3.*@dev"
$_VERBOSE && echo "> installing docbook in '${DOCBOOK_DIR}' ..."
if [ ! -d $DOCBOOK_DIR ]; then
	ln -s "`pwd`/docbook" $TARGET_DIR/
	${_COMPOSER} create-project atelierspierrot/docbook $DOCBOOK_DIR $DOCBOOK_VERSION --no-dev
fi

# DocBook contents
declare -a DOCBOOK_CONTENTS=(
	'https://github.com/piwi/mydocbook.git'
	'https://github.com/atelierspierrot/atelierspierrot.git'
	'https://bitbucket.org/pierowbmstr/private-docbook.git'
);
$_VERBOSE && echo "> installing docbook contents ..."
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
return 0


# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
