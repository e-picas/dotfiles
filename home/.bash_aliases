#
# .bash_aliases
# by @pierowbmstr (me at e-piwi dot fr)
# <http://github.com/piwi/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#

# paths
[ -z "$(which home)" ] && alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# interactive by default
alias rm='rm --interactive'
alias rmdir='rm --interactive --recursive'
alias mv='mv --interactive'
alias cp='cp --interactive'

# unix device commons
alias shutdown='sudo shutdown –h now'
alias restart='sudo shutdown –r now'

# exclude vcs internals from grep
alias grep='grep --color=auto --exclude-dir=\.svn  --exclude-dir=\.git'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
if [ "$(uname)" = 'Linux' ]; then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi
alias l='ls --format=vertical --classify --almost-all'
alias ll='ls --format=long --all --classify'
alias lh='ls --format=long --all --human-readable --classify'
alias ld='ll --directory */'
alias lld='ld'
alias le='l --sort=extension'
alias lt='l --sort=time'
alias lr='l --recursive'
alias lle='ll --sort=extension'
alias llt='ll --sort=time'
alias llr='ll --recursive'
alias lhe='lh --sort=extension'
alias lht='lh --sort=time'
alias lhr='lh --recursive'
alias ldt='ld --sort=time'
alias ldr='ld --recursive'

# various
alias diff='diff --unified'
alias less='less --ignore-case --quit-on-intr --LONG-PROMPT'
alias _echo='echo -e'
alias d='date "+%Y%m%d-%H%M%S"'
alias hn='hostname -a'
alias fullps='ps -auxwww'

# sudo with current user env
alias sudome='sudo -sE'

# special grep for PHP packages
alias grepcomposer='grep --exclude-dir=vendor --exclude-dir=phpdoc --exclude-dir=.idea'

# summary of LXC with IPs and status
alias lxc-list='sudo lxc-ls -1f'

# Add an "alert" alias for long running commands
# usage: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# visualize all `PATH` entries
alias showpath='echo -e ${PATH//:/\\n}'

# lesspipe utility
[ -r "${HOME}/bin/lesspipe.sh" ] && alias lesspipe='$HOME/bin/lesspipe.sh';

# 'wget' emulation if it doesn't exist
[ -z "$(command -v wget)" ] && alias wget='curl -C - -O ';

# user per-device external files
[ -r "${HOME}/.bash_aliases_alt" ] && source "${HOME}/.bash_aliases_alt";

# Endfile
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
