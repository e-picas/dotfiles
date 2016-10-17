#
# .bash_aliases
# by @picas (me at picas dot fr)
# <http://github.com/e-picas/dotfiles.git>
# (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
#
# Read more about Bash startup files at: http://www.linuxfromscratch.org/blfs/view/6.3/postlfs/profile.html
# Read more about Bash programming at: http://www.gnu.org/software/bash/manual/bash.html
# Read more about '.bash_aliases' at: http://ss64.com/bash/syntax-bashrc.html
# Read more about Bash aliases at: http://tldp.org/LDP/abs/html/aliases.html

# interactive filesystem actions by default
alias rm='rm --interactive'
alias rmdir='rm --interactive --recursive'
alias mv='mv --interactive'
alias cp='cp --interactive'

# playing with filesystem renderers
alias l='ls --format=vertical --classify --almost-all'
alias ll='ls --format=long --all --human-readable --classify'
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

# unix device commons
alias diff='diff --unified'
alias less='less --ignore-case --quit-on-intr --LONG-PROMPT'
# current date | run: $ mydate
alias mydate='date +"%Y%m%d-%H%M%S"'
# be sudo as yourself | run: $ sudome
alias sudome='sudo -sE'
# use recursion with grep | run: $ rgrep ...
alias rgrep='grep --recursive'
# visualize all `PATH` entries | run: $ showpath
alias showpath='echo -e ${PATH//:/\\n}'
alias shutdown='sudo shutdown –h now'
alias restart='sudo shutdown –r now'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias rgrep='rgrep --color=auto'
fi
# some more ls aliases
if [ "$(uname)" = 'Linux' ]; then
    alias ls="ls --color=auto"
else
    alias ls="ls --no-group"
fi

# exclude vcs and IDEs internals from grep
alias grep='grep --exclude-dir=\.svn --exclude-dir=\.git --exclude-dir=\.idea --exclude-dir=\.settings --exclude=\*\.project --exclude=\*\.sublime\-\* ';
# special grep for all dev projects
alias grepdev='grep --exclude=\*modules/\* --exclude=\*node_modules/\* --exclude=\*vendor/\* --exclude=\*bower_components/\* --exclude=\*components/\* ';

# lesspipe utility
[ -r "${HOME}/bin/lesspipe.sh" ] && alias lesspipe='$HOME/bin/lesspipe.sh';

# 'wget' emulation if it doesn't exist
[ -z "$(command -v wget)" ] && alias wget='curl --continue-at - --remote-name ';

# special inclusion of other .bashrc_XXX files if they exists
for f in .bash_aliases_osx .bash_aliases_alt; do
    [ -r "${HOME}/${f}" ] && source "${HOME}/${f}";
done

# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh
