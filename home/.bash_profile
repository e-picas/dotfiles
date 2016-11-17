#
# .bash_profile
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash profile at: <http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html>
# This should only include `~/.bashrc` and `~/.profile`
#

# load .profile containing login, non-bash related initializations
if [ -r "$HOME/.profile" ]; then source "$HOME/.profile"; fi

# load & define .bashrc as non-login related bash initializations for interactive sessions
case "$-" in *i*)
    if [ -r "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
        export BASH_ENV="$HOME/.bashrc"
        echo "# env:"
        echo "USER        = ${USER}"
        echo "SHELL       = ${SHELL}"
        echo "UNAME       = ${UNAME}"
        echo "HOME        = ${HOME}"
        echo "TMPDIR      = ${TMPDIR}"
        echo "PATH        = ${PATH}"
        echo "MANPATH     = ${MANPATH}"
        echo "CDPATH      = ${CDPATH}"
        echo "HISTCONTROL = ${HISTCONTROL}"
        echo "PAGER       = ${PAGER}"
        echo "EDITOR      = ${EDITOR}"
        echo "VISUAL      = ${VISUAL}"
        echo "BROWSER     = ${BROWSER}"
        echo "# aliases:"
        alias
        echo "# server date:"
        date
    else
        echo "!! .bashrc not found!"
    fi
;; esac

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
