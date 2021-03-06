#
# .bashrc_osx
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

# path to use MacPorts
[ -d /opt/local/sbin ]  && export PATH="/opt/local/sbin:${PATH}";
[ -d /opt/local/bin ]   && export PATH="/opt/local/bin:${PATH}";

# paht to the GNU coreutils
[ -d /opt/local/libexec/gnubin ] && export PATH="/opt/local/libexec/gnubin:${PATH}"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# a vlc command workaround
[ -d /Applications/VLC.app ] && alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
