#
# .bashrc <http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html>
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html
# Read the official Bash programming manual at: http://www.gnu.org/software/bash/manual/bash.html
# Read the official Bash manual page at: http://man7.org/linux/man-pages/man1/bash.1.html

# If not running interactively, don't do anything
[ -z "${PS1:-}" ] && return

# global system files
[ -r /etc/bashrc ] && source /etc/bashrc;
[ -r /etc/bash.bashrc ] && source /etc/bash.bashrc;
[ -r /etc/bash_completion ] && ! shopt -oq posix && source /etc/bash_completion;
[ -d /usr/local/etc/bash_completion.d/ ] && [ "$(ls /usr/local/etc/bash_completion.d/ 2>/dev/null)" ] && ! shopt -oq posix && { for f in /usr/local/etc/bash_completion.d/*; do source $f; done; };
[ -d /opt/local/etc/bash_completion.d/ ] && [ "$(ls /opt/local/etc/bash_completion.d/ 2>/dev/null)" ] && ! shopt -oq posix && { for f in /opt/local/etc/bash_completion.d/*; do source $f; done; };

# force shell on bash
[ -z "$SHELL" ] && command -v bash > /dev/null && export SHELL="$(which bash)";
command -v less > /dev/null     && export PAGER="$(which less) -i";
command -v vim > /dev/null      && export EDITOR="$(which vim)";
command -v gedit > /dev/null    && export VISUAL="$(which gedit)";
command -v emacs > /dev/null    && export VISUAL="$(which emacs)";
command -v lynx > /dev/null     && export BROWSER="$(which lynx)";
command -v less > /dev/null     && export MANPAGER="$(which less) -X"; # don't clear the screen after a manpage

# user land
UNAME="$(uname -s)"

# history
[ -z "$HISTFILE" ]          && export HISTFILE="${HOME}/.history";
[ -z "$MYSQL_HISTFILE" ]    && export MYSQL_HISTFILE="${HOME}/.mysql_history";
[ -z "$SQLITE_HISTFILE" ]   && export SQLITE_HISTFILE="${HOME}/.sqlite_history";

# ignore duplicate history lines and any command beginning by a space
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=5000
export HISTIGNORE="ls:l:la:ll:clear:pwd:hist:history:tree"

# terminal & env settings
set -o notify                       # report status of terminated bg jobs immediately
shopt -s extglob                    # extended pattern matching features
shopt -s progcomp                   # programmable completion
shopt -s cdspell                    # correct dir spelling errors on cd
shopt -s lithist                    # save multi-line commands with newlines
shopt -s cmdhist                    # save multi-line commands in a single hist entry
shopt -s checkwinsize               # check the window size after each command
shopt -s no_empty_cmd_completion    # don't try to complete empty cmds
shopt -s histappend                 # append new history entries
if [ "$UNAME" != 'Darwin' ]; then
    shopt -s autocd                 # if a command is a dir name, cd to it
    shopt -s checkjobs              # print warning if jobs are running on shell exit
    shopt -s dirspell               # correct dir spelling errors on completion
    shopt -s globstar               # ** matches all files, dirs and subdirs
fi

# use colors
export CLICOLOR=1

# colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# define some colors
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
# the GREP_OPTIONS is deprecated, this one is defined as an alias in .bash_alias
#export GREP_OPTIONS='--color=auto'

# user external files
[ -z "$HOSTFILE" ] && [ -r "${HOME}/.hosts" ]   && export HOSTFILE="${HOME}/.hosts";        # hosts definitions
[ -z "$INPUTRC" ] && [ -r "${HOME}/.inputrc" ]  && export INPUTRC="${HOME}/.inputrc";       # keyboard & input rules

# bash prompt
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ] && debian_chroot="$(cat /etc/debian_chroot)";
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi
if [ "$color_prompt" == yes ]; then 
    if [ "$UNAME" == 'Darwin' ]
    then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *);;
esac

# files base perms: 666  (- 022 = 644)
# dirs base perms:  777  (- 022 = 755)
umask 022

# Other definitions and customizations.
# You may want to put all your additions into separate files instead of adding them here directly.
# This will load any *.sh file present in the $HOME/.bashrc.d/ directory.
for f in $HOME/.bashrc.d/*.sh!(*~); do
    [ -r "${f}" ] && source "${f}";
done

# remove duplicates in MANPATH
export MANPATH="$(printf "%s" "${MANPATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')"

# remove duplicates in CDPATH
export CDPATH="$(printf "%s" "${CDPATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')"

# remove duplicates in PATH
export PATH="$(printf "%s" "${PATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')"

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
