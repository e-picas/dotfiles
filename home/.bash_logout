#
# .bash_logout
# by @pierowbmstr (me at e-piwi dot fr)
# <http://github.com/piwi/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash dotfiles at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html

# Personal items to perform on logout

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# user per-device external files
[ -r "${HOME}/.bash_logout_alt" ] && source "${HOME}/.bash_logout_alt";

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
