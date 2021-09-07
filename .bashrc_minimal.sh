# interactive shell - OK
case $- in
    *i*) ;;
      *) return;;
esac

export TERM=xterm-256color

bind 'set show-all-if-ambiguous On'
bind 'TAB:menu-complete'
bind 'set menu-complete-display-prefix on'
bind 'set completion-ignore-case On'

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%F %T: "

shopt -s histappend
shopt -s cdspell
shopt -s cmdhist

if [[ $(/usr/bin/id -u) -eq 0 ]]; then
  PS1='\[\e]0;\u@\h: \w\a\]\[\033[00m\][\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]]\$'
elif
  PS1='\[\e]0;\u@\h: \w\a\]\[\033[00m\][\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\$'
fi

export PS1

alias ll="/usr/bin/ls -l" 2>/dev/null
alias lld="/usr/bin/ls -ld" 2>/dev/null
alias lla="/usr/bin/ls -lA" 2>/dev/null
alias llh="/usr/bin/ls -lah --time-style=+%F\\ %H:%M" 2>/dev/null
alias h='history 10'

