# .bash_aliases

# interactive shell - OK
case $- in
    *i*) ;;
      *) return;;
esac

export TERM=xterm-256color
export COLORTERM=truecolor
export CLICOLOR=1
export USE_LS_COLORS=1

myprompt() {
    history -a ; history -c ; history -r
    if [ "$CLICOLOR" == "1" ]; then
        if [ "$(id -u)" == "0" ]; then
            PS1='\[\e[m\][\[\e[1;31m\]\u@\h\[\e[m\] \[\e[0;33m\]\W\[\e[m\]]\[\e[1;31m\]\$\[\e[m\] '
        else
            PS1='\[\e[m\][\[\e[1;32m\]\u@\h\[\e[m\] \[\e[0;33m\]\W\[\e[m\]]\[\e[1;32m\]\$\[\e[m\] '
        fi
    else
        PS1='\[\e[m\][\u@\h \W]\$ '
    fi
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
}

shopt -s cmdhist
shopt -s histappend
shopt -s cdspell
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar

export HISTCONTROL=ignorespace:ignoredups
export HISTSIZE=10000
export HISTFILESIZ=10000
export HISTIGNORE="&:[bf]g:pwd:ls:ls -la:ls -ltr:ll:cd:exit:df:htop:atop:top:ps ax"

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

bind 'set show-all-if-ambiguous On'
bind 'TAB:menu-complete'
bind 'set menu-complete-display-prefix on'
bind 'set completion-ignore-case On'

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

export LS_OPTIONS='--color=auto'

alias og='ls $LS_OPTIONS -ogrt' 2>/dev/null
alias ls='ls $LS_OPTIONS' 2>/dev/null
alias ll='ls $LS_OPTIONS -l' 2>/dev/null
alias lld='ls $LS_OPTIONS -ld' 2>/dev/null
alias lla='ls $LS_OPTIONS -lA' 2>/dev/null
alias la='ls $LS_OPTIONS -A' 2>/dev/null
alias lt='ls $LS_OPTIONS -ltr' 2>/dev/null
alias l='ls $LS_OPTIONS -CF' 2>/dev/null
alias l.='ls -d .* $LS_OPTIONS' 2>/dev/null
alias lsl='ls -lhFA | less'
alias lsdate='ls $LS_OPTIONS -l --time-style="+%d-%m-%Y"' 2>/dev/null

alias ffile='find . -type f -name '
alias fhere='find . -name '
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias histg='history | grep'
alias hostip='curl http://ipecho.net/plain; echo'
alias net='netstat -ntulp'
alias j='jobs -l'
alias ports='netstat -tulanp'

alias grep='grep --color=auto'
alias fgrep='grep --color=auto'
alias egrep='grep --color=auto'
alias diff='diff --color=auto'

alias h='history 5'
alias mc='. /usr/libexec/mc/mc-wrapper.sh'

export PROMPT_COMMAND=myprompt
