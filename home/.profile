#
# .profile
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about shells startup files at: <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
#

#
# The `.profile` is loaded at startup of most of UNIX shells.
# This is the right place to put environment variables you want to be available/assigned
# globally in your user's environment.
# So it MUST be portable enough to not break on old/non-POSIX shells.
#

## TEST SHELL TYPE

# if we are running csh or ksh, just go away from here
# these shells should normally not load this file but maybe a user mistake could include it on startup
if [ -n "$shell" ]; then return 0; fi

## PATHS

# system binaries path
if [ -d /usr/local/bin ]; then
    PATH="/usr/local/bin:$PATH";
fi
if [ -d /usr/local/sbin ]; then
    PATH="/usr/local/sbin:$PATH";
fi

# user binaries path
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH";
fi
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH";
fi

# system manpages path
if [ -d /usr/local/man ]; then
    MANPATH="/usr/local/man:$MANPATH";
fi
if [ -d /usr/local/share/man ]; then
    MANPATH="/usr/local/share/man:$MANPATH";
fi

# be sure to have '$HOME/bin/lib' and '$HOME/lib' in '$LD_LIBRARY_PATH' and '$LD_RUN_PATH'
if [ -d "$HOME/bin/lib" ]; then
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/bin/lib";
    LD_RUN_PATH="$LD_RUN_PATH:$HOME/bin/lib";
fi
if [ -d "$HOME/lib" ]; then
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib";
    LD_RUN_PATH="$LD_RUN_PATH:$HOME/lib";
fi

# user 'cd' path
# commented because it mess a lot of scripts
#if [ -z "$CDPATH" ]; then
#    CDPATH=".:$HOME:/mnt:/usr/lib:/usr/local:/software";
#fi
#if [ -d "$HOME/Documents" ]; then
#    CDPATH="$CDPATH:$HOME/Documents";
#fi
#if [ -d "$HOME/www" ]; then
#    CDPATH="$CDPATH:$HOME/www";
#fi

# deduplicate PATHs variables
# @see <http://unix.stackexchange.com/a/40755>

# remove duplicates in MANPATH
MANPATH="$(printf "%s" "${MANPATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')";

# remove duplicates in CDPATH
#CDPATH="$(printf "%s" "${CDPATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')";

# remove duplicates in PATH
PATH="$(printf "%s" "${PATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')";

# export all variables
export PATH
export MANPATH
#export CDPATH
export LD_LIBRARY_PATH
export LD_RUN_PATH

## SYSTEM VARIABLES

# force shell on bash
if [ -z "$SHELL" ] && command -v bash > /dev/null; then
    SHELL="$(type -p bash)";
    export SHELL
fi
if command -v less > /dev/null; then
    PAGER="$(type -p less) -i";
    export PAGER
fi
if command -v vim > /dev/null; then
    EDITOR="$(type -p vim)";
    export EDITOR
fi
if command -v gedit > /dev/null; then
    VISUAL="$(type -p gedit)";
    export VISUAL
fi
if command -v emacs > /dev/null; then
    VISUAL="$(type -p emacs)";
    export VISUAL
fi
if command -v lynx > /dev/null; then
    BROWSER="$(type -p lynx)";
    export BROWSER
fi
if command -v less > /dev/null; then
    MANPAGER="$(type -p less) -X"; # don't clear the screen after a manpage
    export MANPAGER
fi

# user land
UNAME="$(uname -s)"
export UNAME

# env & LC
if [ -r "$HOME/.environment" ]; then
    source "$HOME/.environment";
fi

# history
if [ -z "$HISTFILE" ]; then
    HISTFILE="$HOME/.history";
    export HISTFILE
fi
if [ -z "$MYSQL_HISTFILE" ]; then
    MYSQL_HISTFILE="$HOME/.mysql_history";
    export MYSQL_HISTFILE
fi
if [ -z "$SQLITE_HISTFILE" ]; then
    SQLITE_HISTFILE="$HOME/.sqlite_history";
    export SQLITE_HISTFILE
fi

# ignore duplicate history lines and any command beginning by a space
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=5000
HISTIGNORE="ls:l:la:ll:clear:pwd:hist:history:tree"
export HISTCONTROL
export HISTSIZE
export HISTFILESIZE
export HISTIGNORE

# user external files
if [ -z "$HOSTFILE" ] && [ -r "$HOME/.hosts" ]; then
    HOSTFILE="$HOME/.hosts"; # hosts definitions
    export HOSTFILE
fi
if [ -z "$INPUTRC" ] && [ -r "$HOME/.inputrc" ]; then
    INPUTRC="$HOME/.inputrc"; # keyboard & input rules
    export INPUTRC
fi

## ALTERNATE PROFILES FILES

# this will load any `profile_XX` alternative file found in user's $HOME
for f in $HOME/.profile_*; do
    if [ -r "$f" ]; then source "$f"; fi;
done

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
