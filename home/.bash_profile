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

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
