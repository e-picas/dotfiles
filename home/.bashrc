#
# .bashrc - <http://github.com/e-picas/dotfiles.git> - licensed under CC BY-NC-SA 4.0
#
# Read more about shells startup files at:
# <http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html>
#

# If not running interactively, don't do anything
[ -z "${PS1:-}" ] && return;

# global system files
[ -r /etc/bashrc ] && source /etc/bashrc;
[ -r /etc/bash.bashrc ] && source /etc/bash.bashrc;
[ -r /etc/bash_completion ] && ! shopt -oq posix && source /etc/bash_completion;
[ -d /usr/local/etc/bash_completion.d/ ] && [ "$(ls /usr/local/etc/bash_completion.d/ 2>/dev/null)" ] && ! shopt -oq posix && { for f in /usr/local/etc/bash_completion.d/*; do source $f; done; };
[ -d /opt/local/etc/bash_completion.d/ ] && [ "$(ls /opt/local/etc/bash_completion.d/ 2>/dev/null)" ] && ! shopt -oq posix && { for f in /opt/local/etc/bash_completion.d/*; do source $f; done; };

## CUSTOMIZATION
# Personal items to load with Bash shell








## ALTERNATE Bash-rc FILES

# You may want to put all your additions into separate files instead of adding them here directly.
# This will load any `*.sh` file present in the `$HOME/.bashrc.d/` directory.
# You can control the order of that loading by using numerical prefixes in file names.
export BASHRCDIR="$HOME/.bashrc.d"
if [ -d "$BASHRCDIR" ]; then
    for f in $BASHRCDIR/*.sh!(*~); do
        [ -r "${f}" ] && source "${f}";
    done
fi

# vim:ts=4:sw=4
