#
# .bash_logout
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

echo "reading > .bash_logout"

# Personal items to perform on logout

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# special inclusion of other .bash_logout_XXX files if they exists
# any `.bash_logout_XXX.silent` will be ignored
shopt -s extglob
for f in $HOME/.bash_logout_!(*.silent); do
    [ -r "${f}" ] && source "${f}";
done

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
