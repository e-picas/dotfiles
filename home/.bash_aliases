#
# .bash_aliases
# by @pierowbmstr (me at picas dot fr)
# <http://github.com/pierowbmstr/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

# paths
[ -z `which home` ] && alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# interactive by default
alias rm='rm -i'
alias rmdir='rm -r'
alias mv='mv -i'
alias cp='cp -i'

# exclude csv internals from grep
alias grep='grep --color=auto --exclude-dir=\.svn  --exclude-dir=\.git'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
if [ $(uname) = "Linux" ]; then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi
alias lll='ls -alFh'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ldir='ll -d */'

# various
alias diff='diff -u'        # use unified diff format
alias less='less -iMFR'
alias _echo='echo -e'
alias cl='clear'
alias d='date +%Y%m%d-%H%M%S'
alias hn='hostname -a'
alias fullps='ps -auxwww'

# Add an "alert" alias for long running commands
# usage: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias showpath='echo -e ${PATH//:/\\n}'

# 'wget' emulation if it doesn't exist
if [ -z $(which wget) ]; then
    alias wget='curl -C - -O '
fi

# dotfiles shortcuts
alias editbashrc='vim ~/.bashrc'
alias reloadbashrc='source ~/.bashrc'
alias editbashfct='vim ~/.bash_functions'
alias reloadbashfct='source ~/.bash_functions'
alias editbashalias='vim ~/.bash_aliases'
alias reloadbashalias='source ~/.bash_aliases'

# user per-device external files
[ -r ${HOME}/.bash_aliases_alt ] && source ${HOME}/.bash_aliases_alt;

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=off
