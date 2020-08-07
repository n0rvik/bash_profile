# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH

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

export HISTCONTROL=ignorespace:ignoredups
export HISTIGNORE="pwd:ls:ll"
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

export LS_OPTIONS='--color=auto'

alias og='/usr/bin/ls $LS_OPTIONS -ogrt' 2>/dev/null
alias ls='/usr/bin/ls $LS_OPTIONS' 2>/dev/null
alias ll='/usr/bin/ls $LS_OPTIONS -l' 2>/dev/null
alias lld='/usr/bin/ls $LS_OPTIONS -ld' 2>/dev/null
alias lla='/usr/bin/ls $LS_OPTIONS -lA' 2>/dev/null
alias llh='/usr/bin/ls $LS_OPTIONS -lah --time-style=+%F\ %H:%M' 2>/dev/null
alias llt='/usr/bin/ls $LS_OPTIONS -lah --sort=time' 2>/dev/null
alias llr='/usr/bin/ls $LS_OPTIONS -lah --sort=time --revers' 2>/dev/null
alias la='/usr/bin/ls $LS_OPTIONS -A' 2>/dev/null
alias lt='/usr/bin/ls $LS_OPTIONS -ltr' 2>/dev/null
alias l='/usr/bin/ls $LS_OPTIONS -CF' 2>/dev/null
alias l.='/usr/bin/ls -d .* $LS_OPTIONS' 2>/dev/null
alias lsl='/usr/bin/ls -lhFA | less'
alias lsdate='/usr/bin/ls $LS_OPTIONS -l --time-style="+%d-%m-%Y"' 2>/dev/null

alias grep='/usr/bin/grep --color=auto'
alias fgrep='/usr/bin/grep --color=auto'
alias egrep='/usr/bin/grep --color=auto'

alias h='history 10'

if type vim &>/dev/null; then
    alias vi='vim'
fi

# Defaulst PS1
# PS1="[\u@\h \W]\\$ "
# PS1="[\u@\h:\l \W]\\$ "

PROMPT_COMMAND='history -a;printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
if [ "$(id -u)" == "0" ]; then
    PS1='[\[\033[01;31m\]\u@\h \[\033[01;33m\]\W\[\033[00m\]]\[\033[01;31m\]\$\[\033[00m\] '
else
    PS1='[\[\033[01;32m\]\u@\h \[\033[01;33m\]\W\[\033[00m\]]\[\033[01;32m\]\$\[\033[00m\] '
fi

COWSAY=`/usr/bin/which cowsay 2>/dev/null`
if [ -n "$COWSAY" ]; then
    $COWSAY "Hi, people! Today is $(/usr/bin/date +'%A %d %B %Y')"
else
    echo -e "\nHi, people! Today is $(/usr/bin/date +'%A %d %B %Y')\n\n"
fi

