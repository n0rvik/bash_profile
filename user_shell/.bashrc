# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# Отображение списка соответствующих файлов
bind 'set show-all-if-ambiguous on'
# Если есть несколько совпадений для завершения, Tab должен циклически перебирать их
bind 'TAB:menu-complete'
# Выполните частичное завершение на первом нажатии вкладки,
# только начните циклировать полные результаты на втором нажатии вкладки
bind 'set menu-complete-display-prefix on'
bind 'set completion-ignore-case on'

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT="%F %T: "

# Сохранять все строки многострочной команды в одной записи списка истории
shopt -s cmdhist
shopt -s histappend
# bash начнёт понимать опечатки и будет переносить вас в папку, название которой вы набрали с ошибкой
shopt -s cdspell
shopt -s checkwinsize
# активирует функции, которые чаще ассоциируются с регулярными выражениями.
shopt -s extglob
# оболочка покажет рекурсивно все каталоги и подкаталоги.
shopt -s globstar
# bash подставляет имена директорий из переменной во время автодополнения.
shopt -s direxpand
# bash будет пытаться исправлять имена каталогов
shopt -s dirspell

LS_OPTIONS='--color=auto'

alias grep="/usr/bin/grep $LS_OPTIONS" 2>/dev/null

alias h='history 10'
alias vi='/usr/bin/vim'

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
alias lsl="/usr/bin/ls -lhFA | /usr/bin/less"
alias lsdate="/usr/bin/ls $LS_OPTIONS -l --time-style=+%d-%m-%Y" 2>/dev/null

if [[ $(id -u) -eq 0 ]]; then
  PS1='\[\e]0;\u@\h \w\a\]\[\033[00m\][\[\033[01;31m\]\u@\h\[\033[00m\] \[\033[0;33m\]\W\[\033[00m\]]\[\033[01;31m\]\$\[\033[00m\] '
else
  PS1='\[\e]0;\u@\h \w\a\]\[\033[00m\][\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[0;33m\]\w\[\033[00m\]]\[\033[01;32m\]\$\[\033[00m\] '
fi

export PS1
