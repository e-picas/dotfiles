#
# .bash_logout - <http://github.com/e-picas/dotfiles.git> - licensed under CC BY-NC-SA 4.0
#
# Read more about shells startup files at:
# <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
#

## CUSTOMIZATION
# Personal items to perform on logout









## ALTERNATE LOGOUT FILES
# special inclusion of other `.bash_logout_XXX` files if they exists
for f in $HOME/.bash_logout_*; do
    [ -r "${f}" ] && source "${f}";
done

# vim:ts=4:sw=4
