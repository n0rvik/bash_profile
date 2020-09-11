# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# default path
# user
# PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
# root
# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

pathmunge () {
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

# modern path
# PATH=$HOME/.local/bin:$HOME/bin:$PATH

unset -f pathmunge

export PATH
