# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment

function pathmunge() {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

if [ -d "$HOME/bin" ] ; then
    pathmunge "$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ] ; then
    pathmunge "$HOME/.local/bin"
fi

export PATH

unset -f pathmunge

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# interactive shell - OK
case $- in
    *i*) ;;
      *) return;;
esac

export TERM=xterm-256color

shopt -s cmdhist
shopt -s histappend
shopt -s checkwinsize

export HISTCONTROL=ignoreboth
export HISTSIZE=100000
export HISTFILESIZ=100000
export HISTTIMEFORMAT="%d/%h/%y - %H:%M:%S "

bind 'set show-all-if-ambiguous On'
bind 'TAB:menu-complete'
bind 'set menu-complete-display-prefix on'
bind 'set completion-ignore-case On'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

LS_OPTIONS='--color=auto'

alias grep="/usr/bin/grep $LS_OPTIONS"
alias fgrep="/usr/bin/grep $LS_OPTIONS"
alias egrep="/usr/bin/grep $LS_OPTIONS"

alias og="/usr/bin/ls $LS_OPTIONS -ogrt" 2>/dev/null
alias ls="/usr/bin/ls $LS_OPTIONS" 2>/dev/null
alias ll="/usr/bin/ls $LS_OPTIONS -l" 2>/dev/null
alias lld="/usr/bin/ls $LS_OPTIONS -ld" 2>/dev/null
alias lla="/usr/bin/ls $LS_OPTIONS -lA" 2>/dev/null
alias llh="/usr/bin/ls $LS_OPTIONS -lah --time-style=+%F\\ %H:%M" 2>/dev/null
alias llt="/usr/bin/ls $LS_OPTIONS -lah --sort=time" 2>/dev/null
alias llr="/usr/bin/ls $LS_OPTIONS -lah --sort=time --revers" 2>/dev/null
alias la="/usr/bin/ls $LS_OPTIONS -A" 2>/dev/null
alias lt="/usr/bin/ls $LS_OPTIONS -ltr" 2>/dev/null
alias l="/usr/bin/ls $LS_OPTIONS -CF" 2>/dev/null
alias l.="/usr/bin/ls -d .* $LS_OPTIONS" 2>/dev/null
alias lsl="/usr/bin/ls -lhFA | less"
alias lsdate="/usr/bin/ls $LS_OPTIONS -l --time-style=+%d-%m-%Y" 2>/dev/null

alias h='history 10'

if type vim &>/dev/null; then
    alias vi='vim'
fi

case $TERM in
  xterm*|vte*)
    PROMPT_COMMAND='history -a;printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
  screen*)
    PROMPT_COMMAND='history -a;printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac
export PROMPT_COMMAND

if [ "$(id -u)" == "0" ]; then
    PS1='[\[\033[01;31m\]\u@\h \[\033[01;33m\]\W\[\033[00m\]]\[\033[01;31m\] \$\[\033[00m\] '
else
    PS1='[\[\033[01;32m\]\u@\h \[\033[01;33m\]\W\[\033[00m\]]\[\033[01;32m\] \$\[\033[00m\] '
fi
export PS1

