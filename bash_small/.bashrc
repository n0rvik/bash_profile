# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

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

export PATH

unset -f pathmunge

# User Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -d ~/.config/bashrc.d ]; then
  for i in `/usr/bin/ls ~/.config/bashrc.d/`; do
    if [[ -f ~/.config/bashrc.d/${i} ]]; then
      . ~/.config/bashrc.d/${i}
    fi
  done
  unset i
fi
