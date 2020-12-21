# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

DIR_COLORS=
if [ -e "$HOME/.dir_colors" ]; then
   DIR_COLORS="$HOME/.dir_colors"
else
   case $TERM in
     xterm-256color)
         DIR_COLORS=/etc/DIR_COLORS.256color
         ;;
     xterm*)
         DIR_COLORS=/etc/DIR_COLORS
         ;;
   esac
fi
eval "`dircolors -b ${DIR_COLORS}`"

export LS_OPTIONS='--color=auto'

alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

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


# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -d "$HOME/bin" ] ; then
    pathmunge "$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ] ; then
    pathmunge "$HOME/.local/bin"
fi

export PATH

unset -f pathmunge
