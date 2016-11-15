#
# .profile - <http://github.com/e-picas/dotfiles.git> - licensed under CC BY-NC-SA 4.0
#
# The `.profile` is loaded at startup of most of UNIX shells.
# This is the right place to put environment variables you want to be
# available/assigned globally in your user's environment.
# So it MUST be portable enough to not break on old/non-POSIX shells.
#
# Read more about shells startup files at:
# <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
#

## TEST SHELL TYPE
# if we are running csh or ksh, just go away from here
if [ -n "$shell" ]; then return 0; fi

## CUSTOMIZATION
# Personal items to perform on login for ALL shells

PATH="$HOME/bin:$PATH"
export PATH

# ignore duplicate history lines and any command beginning by a space
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=5000
HISTIGNORE="ls:l:la:ll:clear:pwd:hist:history:tree"
export HISTCONTROL
export HISTSIZE
export HISTFILESIZE
export HISTIGNORE

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

## ALTERNATE PROFILES FILES
# this will load any `.profile_XX` alternative file found in user's $HOME
for f in $HOME/.profile_*; do
    if [ -r "$f" ]; then source "$f"; fi;
done

# vim:ts=4:sw=4
