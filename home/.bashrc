#
# .bashrc <http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html>
# by @pierowbmstr (me at e-piwi dot fr)
# <http://github.com/piwi/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

# Personal environment variables and startup programs should go in
# `$HOME/.bash_profile`.  System wide environment variables and startup
# programs are in `/etc/profile`.  System wide aliases and functions are
# in `/etc/bashrc`.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# env & LC
[ -r ${HOME}/.environment ] && source ${HOME}/.environment;

# path
[ -d ${HOME}/bin ] && export PATH="${PATH}:${HOME}/bin";

# global external files
[ -r /etc/bashrc ] && source /etc/bashrc;
[ -r /etc/bash_completion ] && ! shopt -oq posix && source /etc/bash_completion;

# force shell on bash
which bash &> /dev/null && export SHELL="$(which bash)";
which less &> /dev/null && export PAGER="$(which less) -i";
which vim &> /dev/null && export EDITOR="$(which vim)";
which emacs &> /dev/null && export VISUAL="$(which emacs)";
which lynx &> /dev/null && export BROWSER="$(which lynx)";
which less &> /dev/null && export MANPAGER="$(which less) -X"; # don't clear the screen after a manpage

# user land
UNAME=$( uname -s )
# strip OS type and version under Cygwin (e.g. CYGWIN_NT-5.1 => Cygwin)
UNAME=${UNAME/CYGWIN_*/Cygwin}

# use colors
export CLICOLOR=1

# history
[ -z $HISTFILE ] && export HISTFILE="${HOME}/.history";
[ -z $MYSQL_HISTFILE ] && export MYSQL_HISTFILE="${HOME}/.mysql_history";
[ -z $SQLITE_HISTFILE ] && export SQLITE_HISTFILE="${HOME}/.sqlite_history";
# ignore duplicate history lines and any command beginning by a space
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=5000
export HISTIGNORE="l:la:ll:clear:pwd:hist:history:tree"

# terminal & env settings
set -o notify       # Report status of terminated bg jobs immediately
set -o emacs        # emacs-style editing

shopt -s extglob    # extended pattern matching features
shopt -s progcomp   # programmable completion
shopt -s cdspell    # correct dir spelling errors on cd
shopt -s lithist    # save multi-line commands with newlines
shopt -s cmdhist        # save multi-line commands in a single hist entry
shopt -s checkwinsize               # check the window size after each command
shopt -s no_empty_cmd_completion    # don't try to complete empty cmds
shopt -s histappend     # append new history entries
if [ "$UNAME" != 'Darwin' ]
then
    shopt -s autocd     # if a command is a dir name, cd to it
    shopt -s checkjobs  # print warning if jobs are running on shell exit
    shopt -s dirspell   # correct dir spelling errors on completion
    shopt -s globstar   # ** matches all files, dirs and subdirs
fi

# coloured man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
#[ -r ${HOME}/bin/lesspipe.sh ] && export LESSOPEN="|$HOME/bin/lesspipe.sh %s"

# define some colours
export GREY=$'\033[1;30m'
export RED=$'\033[1;31m'
export GREEN=$'\033[1;32m'
export YELLOW=$'\033[1;33m'
export BLUE=$'\033[1;34m'
export MAGENTA=$'\033[1;35m'
export CYAN=$'\033[1;36m'
export WHITE=$'\033[1;37m'
export NOCOLOR=$'\033[m'

# random grep color
export GREP_COLOR="1;3$((RANDOM%6+1))"
export GREP_OPTIONS='--color=auto'

# user external files
[ -r ${HOME}/.bash_aliases ] && source ${HOME}/.bash_aliases;           # all bash aliases
[ -r ${HOME}/.bash_completions ] && source ${HOME}/.bash_completions;   # custom completion rules
[ -r ${HOME}/.bash_functions ] && source ${HOME}/.bash_functions;       # custom bash functions
[ -r ${HOME}/.hosts ] && export HOSTFILE="${HOME}/.hosts";              # hosts definitions
[ -r ${HOME}/.inputrc ] && export INPUTRC="${HOME}/.inputrc";           # keyboard & input rules

# bash prompt
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot);

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

if [ "$color_prompt" == yes ]
then 
    if [ "$UNAME" == 'Darwin' ]
    then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *);;
esac

# user per-device external files
[ -r ${HOME}/.bashrc_alt ] && source ${HOME}/.bashrc_alt;

# special inclusion of .bashrc_git if it exists
[ -r ${HOME}/.bashrc_git ] && source ${HOME}/.bashrc_git;

## user directories
# to avoid their creations, define `TMPDIR=''`, `BACKUPDIR=''` and `NOTESDIR=''` in `.bashrc_alt`
# temporary directory: TMPDIR
[ -z $TMPDIR ] && mkdir -p "${HOME}/tmp" && export TMPDIR="${HOME}/tmp";
# backup directory: BACKUPDIR
[ -z $BACKUPDIR ] && mkdir -p "${HOME}/backups" && export BACKUPDIR="${HOME}/backups";
# personal notes directory: NOTESDIR (used by the `notes` and `cheatsheet` functions)
[ -z $NOTESDIR ] && mkdir -p "${HOME}/notes" && export NOTESDIR="${HOME}/notes";

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=off
