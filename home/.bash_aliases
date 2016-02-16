# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more aliases
alias ll='ls -al'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias rmdir='rm -ir'
alias cp='cp -i'
alias mv='mv -i'
alias shutdown='sudo shutdown –h now'
alias restart='sudo shutdown –r now'
alias grep='grep --color=auto --exclude-dir=\.svn  --exclude-dir=\.git --exclude-dir=\.idea --exclude-dir=\.settings --exclude=\*\.project --exclude=\*\.sublime\-\* '
alias rgrep='grep -R'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh