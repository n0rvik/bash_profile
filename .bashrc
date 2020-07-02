# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# You may uncomment the following lines if you want `ls' to be colorized:

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# default path
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# modern path
#PATH=$HOME/.local/bin:$HOME/bin:$PATH

export PATH
