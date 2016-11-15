#
# .bashrc - <http://github.com/e-picas/dotfiles.git> - licensed under CC BY-NC-SA 4.0
#
# Read more about shells startup files at:
# <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
#

# If not running interactively, don't do anything
[ -z "${PS1:-}" ] && return;

# global system files
[ -r /etc/bashrc ] && source /etc/bashrc;
[ -r /etc/bash.bashrc ] && source /etc/bash.bashrc;
[ -r /etc/bash_completion ] && ! shopt -oq posix && source /etc/bash_completion;
[ -d /usr/local/etc/bash_completion.d/ ] && [ "$(ls /usr/local/etc/bash_completion.d/ 2>/dev/null)" ] && ! shopt -oq posix && { for f in /usr/local/etc/bash_completion.d/*; do source $f; done; };
[ -d /opt/local/etc/bash_completion.d/ ] && [ "$(ls /opt/local/etc/bash_completion.d/ 2>/dev/null)" ] && ! shopt -oq posix && { for f in /opt/local/etc/bash_completion.d/*; do source $f; done; };

## CUSTOMIZATION
# Personal items to load with Bash shell

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
[ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot);

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# bash prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi
if [ "$color_prompt" == yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

#### bash aliases

# playing with filesystem renderers
alias l='ls --format=vertical --classify --almost-all'
alias ll='ls --format=long --all --human-readable --classify'
alias ld='ll --directory */'
alias le='l --sort=extension'
alias lt='l --sort=time'
alias lr='l --recursive'

## ALTERNATE Bash-rc FILES

# You may want to put all your additions into separate files instead of adding them here directly.
# This will load any `*.sh` file present in the `$HOME/.bashrc.d/` directory.
# You can control the order of that loading by using numerical prefixes in file names.
export BASHRCDIR="$HOME/.bashrc.d"
if [ -d "$BASHRCDIR" ]; then
    for f in $BASHRCDIR/*.sh!(*~); do
        [ -r "${f}" ] && source "${f}";
    done
fi

# vim:ts=4:sw=4
