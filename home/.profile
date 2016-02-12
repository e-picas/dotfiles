#
# .profile
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash dotfiles at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html

# MacOSX special for completion
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`;
fi

# source .bashrc and infos
if [ -n "$BASH_VERSION" ]; then
    if [ -r "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc";
        echo "# env:"
        echo "UNAME       = ${UNAME}"
        echo "HOME        = ${HOME}"
        echo "TMPDIR      = ${TMPDIR}"
        echo "PATH        = ${PATH}"
        echo "HISTCONTROL = ${HISTCONTROL}"
        echo "# aliases:"
        alias
        echo "# server date:"
        date
    else
        echo "!! .bashrc not found!"
    fi
fi

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH";

# files base perms: 666  (- 022 = 644)
# dirs base perms:  777  (- 022 = 755)
umask 022

# be sure to have '$HOME/bin/lib' and '$HOME/lib' in '$LD_LIBRARY_PATH' and '$LD_RUN_PATH'
if [ -d "$HOME/bin/lib" ]; then
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/bin/lib";
    export LD_RUN_PATH="$LD_RUN_PATH:$HOME/bin/lib";
fi
if [ -d "$HOME/lib" ]; then
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib";
    export LD_RUN_PATH="$LD_RUN_PATH:$HOME/lib";
fi

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
