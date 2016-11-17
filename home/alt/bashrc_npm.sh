#
# .bashrc.d/bashrc_npm.sh
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
# and: <http://ss64.com/bash/syntax-bashrc.html>
#
# Special `.bashrc` file to configure node usage
#

# 'npm' user config
# - packages are installed in $NODE_PREFIX/lib/node_modules/
# - binary files are linked into $NODE_PREFIX/bin/
# - manpages are linked into $NODE_PREFIX/share/man/
if [ -d /usr/local/lib/node_modules/ ]; then
    export NODE_PREFIX=/usr/local
    export NODE_HOME="$NODE_PREFIX/lib/node_modules/"
    export PATH="$NODE_HOME:$PATH"
fi

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
