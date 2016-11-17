#
# .bashrc.d/bash_completions.sh
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
# and: <http://ss64.com/bash/syntax-bashrc.html>
# Read more about Bash programming at: <http://www.gnu.org/software/bash/manual/bash.html>
# Read the official Bash manual page at: <http://man7.org/linux/man-pages/man1/bash.1.html>
# Read more about Bash completion at: <http://www.tldp.org/LDP/abs/html/tabexpansion.html>
#

# turn on extended globbing and programmable completion
shopt -s extglob progcomp

# make directory commands see only directories
complete -d pushd

# the note/cheatsheet completions
if [ "$(type -t _note_completion)" = 'function' ]; then
    complete -o nospace -F _note_completion note
    complete -o nospace -F _note_completion cheatsheet
fi

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
