# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

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
