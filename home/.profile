#
# .profile - <http://github.com/e-picas/dotfiles.git> - licensed under CC BY-NC-SA 4.0
#
# The `.profile` is loaded at startup of most of UNIX shells.
# This is the right place to put environment variables you want to be
# available/assigned globally in your user's environment.
# So it MUST be portable enough to not break on old/non-POSIX shells.
#
# Read more about shells startup files at:
# <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
#

## TEST SHELL TYPE
# if we are running csh or ksh, just go away from here
if [ -n "$shell" ]; then return 0; fi

## CUSTOMIZATION
# Personal items to perform on login for ALL shells

PATH="$HOME/bin:$PATH"
export PATH


## ALTERNATE PROFILES FILES
# this will load any `.profile_XX` alternative file found in user's $HOME
for f in $HOME/.profile_*; do
    if [ -r "$f" ]; then source "$f"; fi;
done

# vim:ts=4:sw=4
