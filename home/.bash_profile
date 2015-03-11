#
# .bash_profile <http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html>
# by @pierowbmstr (me at e-piwi dot fr)
# <http://github.com/piwi/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

# Personal environment variables and startup programs should go in
# `$HOME/.bash_profile`.  System wide environment variables and startup
# programs are in `/etc/profile`.  System wide aliases and functions are
# in `/etc/bashrc`.

# load .profile containing login, non-bash related initializations
if [ -f ~/.profile ]; then source ~/.profile; fi
 
# load .bashrc containing non-login related bash initializations
if [ -f ~/.bashrc ]; then 
    source ~/.bashrc
    export BASH_ENV="$HOME/.bashrc"
fi

# user per-device external files
[ -r "${HOME}/.bash_profile_alt" ] && source "${HOME}/.bash_profile_alt";

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
