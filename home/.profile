#
# .profile
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html

# system binaries path
if [ -d /usr/local/bin ]; then
    PATH=/usr/local/bin:$PATH;
fi
if [ -d /usr/local/sbin ]; then
    PATH=/usr/local/sbin:$PATH;
fi

# user binaries path
if [ -d $HOME/bin ]; then
    PATH=$HOME/bin:$PATH;
fi
if [ -d $HOME/.local/bin ]; then
    PATH=$HOME/.local/bin:$PATH;
fi

# system manpages path
if [ -d /usr/local/man ]; then
    MANPATH=/usr/local/man:$MANPATH;
fi
if [ -d /usr/local/share/man ]; then
    MANPATH=/usr/local/share/man:$MANPATH;
fi

# be sure to have '$HOME/bin/lib' and '$HOME/lib' in '$LD_LIBRARY_PATH' and '$LD_RUN_PATH'
if [ -d $HOME/bin/lib ]; then
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/bin/lib;
    LD_RUN_PATH=$LD_RUN_PATH:$HOME/bin/lib;
fi
if [ -d $HOME/lib ]; then
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/lib;
    LD_RUN_PATH=$LD_RUN_PATH:$HOME/lib;
fi

# user 'cd' path
if [ -z $CDPATH ]; then
    CDPATH=~:/mnt:/usr/lib:/usr/local:/software
fi
if [ -d $HOME/Documents ]; then
    CDPATH=$CDPATH:$HOME/Documents;
fi
if [ -d $HOME/www ]; then
    CDPATH=$CDPATH:$HOME/www;
fi

# export all variables
export PATH
export MANPATH
export CDPATH
export LD_LIBRARY_PATH
export LD_RUN_PATH

# source .bashrc and infos
if [ -n $BASH_VERSION ]; then
    [ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc";
    if [ ! -z "${PS1:-}" ]; then
        if [ -r "$HOME/.bashrc" ]; then
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
    fi
fi

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
