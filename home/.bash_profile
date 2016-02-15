#
# .bash_profile <http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html>
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html
# Read more about Bash programming at: http://www.gnu.org/software/bash/manual/bash.html

# Personal environment variables and startup programs should go in
# `$HOME/.bash_profile`.  System wide environment variables and startup
# programs are in `/etc/profile`.  System wide aliases and functions are
# in `/etc/bashrc`.

# load .profile containing login, non-bash related initializations
[ -f "${HOME}/.profile" ] && source "${HOME}/.profile";
 
# load .bashrc containing non-login related bash initializations
if [ -f "${HOME}/.bashrc" ]; then 
    source "${HOME}/.bashrc"
    export BASH_ENV="${HOME}/.bashrc"
fi

# user per-device external files
[ -r "${HOME}/.bash_profile_alt" ] && source "${HOME}/.bash_profile_alt";

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
