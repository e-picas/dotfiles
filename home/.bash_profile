#
# .bash_profile <http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html>
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# this should only include `~/.bashrc` and `~/.profile`
# the `~/.bashrc` is actually included in `~/.profile`

# load .profile containing login, non-bash related initializations
[ -f $HOME/.profile ] && source $HOME/.profile;
 
# define .bashrc as non-login related bash initializations
if [ -f $HOME/.bashrc ]; then
    export BASH_ENV=$HOME/.bashrc
fi

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
