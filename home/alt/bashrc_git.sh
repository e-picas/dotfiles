#
# .bashrc_git
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Special `.bashrc` file to embed the GIT completion tools below:
# Copyright (C) 2006,2007 Shawn O. Pearce <spearce@spearce.org>
# Conceptually based on gitcompletion (http://gitweb.hawaga.org.uk/).
# Distributed under the GNU General Public License, version 2.0.
#
# To use this file, copy the `git-completion` script at ~/.git-completion
# The command line prompt is redraw but REQUIRES to include the common `home/.bashrc`
#

if [ -f "$BASHRCDIR/git-completion" ]; then
    # GIT settings
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM=auto

    # include completion
    source "$BASHRCDIR/git-completion";

    # add GIT status of current directory in terminal prompt
    if [ "$color_prompt" = yes ]
    then
        if [ "$(uname -s)" = 'Darwin' ]
        then
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[01;31m\] $(__git_ps1 " (%s)")\[\033[00m\]\$ '
        else
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(__git_ps1 " (%s)")\[\033[00m\]\$ '
        fi
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(__git_ps1 " (%s)")\$ '
    fi
fi

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
