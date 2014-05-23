#
# .profile
# by @pierowbmstr (me at picas dot fr)
# <http://github.com/pierowbmstr/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

# source .bashrc and infos
if [ -r ~/.bashrc ]; then
    source ~/.bashrc
    echo "# env:"
    echo "UNAME = ${UNAME}"
    echo "HOME = ${HOME}"
    echo "TMPDIR = ${TMPDIR}"
    echo "PATH = ${PATH}"
    echo "HISTCONTROL = ${HISTCONTROL}"
    echo "# aliases:"
    alias
else
    echo "!! bashrc not found!"
fi

# set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH";

# files base perms: 666  (- 022 = 644)
# dirs base perms:  777  (- 022 = 755)
umask 022
