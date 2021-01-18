# .bash_aliases

# interactive shell - OK
case $- in
    *i*) ;;
      *) return;;
esac

# Сообщение в строке prompt
export PROMPTMSG=
export PROMPTTIME=1
export PROMPTEXIT=1
export PROMPTJOBS=1
export PROMPTWHO=0
export PROMPTTTY=0
export LONGPATH=0
export EASYPROMPT=0

export TERM=xterm-256color
export COLORTERM=truecolor
export CLICOLOR=1
#export USER_LS_COLORS=1
export LS_OPTIONS=

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

export HISTCONTROL=ignoreboth
# export HISTCONTROL=ignorespace:ignoredups
export HISTSIZE=100000
export HISTFILESIZ=100000
export HISTIGNORE="&:[bf]g:pwd:ls:ls -la:ls -ltr:ll:lld:lla:cd:exit:df:htop:atop:top:ps ax"
export HISTTIMEFORMAT="%d/%h/%y - %H:%M:%S "
# export HISTTIMEFORMAT='%h %d %H:%M:%S '
# export HISTTIMEFORMAT="%d/%m/%y %T %t"

function pathmunge() {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [[ "$2" = "after" ]] ; then
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

# Скопировать файл в файл с расширением ${file}-2020-03-19-130430.bak
function t0bak() {
  local file=$1
  if [ -f "${file}" ]; then
    /usr/bin/cp -v "${file}" "${file}-$(date +%Y-%m-%d-%H%M%S).bak"
  fi
}

# Архивация папки в которой запущена программа в
# папку $HOME/backup/<name_cur_folder>
function __tar_backup()
{
     local __date=`/usr/bin/date +%Y-%m-%d-%H%M%S`
     local full_path=`/usr/bin/pwd`
     local source_dir=`/usr/bin/pwd | /usr/bin/sed -e 's,^\(.*/\)\?\([^/]*\),\2,'`
     local dest_dir="${HOME}/backup/${source_dir}"
     local name_arch="${dest_dir}/${source_dir}_${__date}.tar.gz"
     local recreatesnar=""

     if [ ! -d "$dest_dir" ]; then
         /usr/bin/mkdir -vp "$dest_dir"
     else
        echo -e "\033[0;31mArchive folder exist -> ${dest_dir}, re-create archive files? (y\N) \033[0m"
        read recreatesnar
        if [[ "$recreatesnar" =~ ^(y|yes|Y)$ ]]; then
            /usr/bin/find ${dest_dir} -type f \( -name "${source_dir}_*.tar.gz" \) -exec /usr/bin/rm -i {} \;
        fi
     fi

     echo -e "\n\033[0;33mStart backup ${full_path}\033[0m"

     /usr/bin/tar --create --gzip --verbose --dereference \
                  --file="${name_arch}" \
                  --exclude "${dest_dir}/*" \
                 "."

     if [ "$?" -eq "0" ]; then
         echo -e "\n\033[0;33mFinish backup ${full_path} -> ${name_arch}\033[0m"
     else
         echo -e "\n\033[0;31mError create backup ${full_path}\033[0m"
     fi

}


# ############
# __myprompt
# ############
# Установка PS1 и PROMPT_COMMAND
#
# Используются переменные
#
# CLICOLOR[=0] 1 цветное приглашение 0 бесцветное приглашение
#
# LONGPATH[=0] 1 показать длинный путь 0 показать короткий путь
#              По умолчанию 0, папка HOME всегда заменяется ~
# EASYPROMPT[=0] 1 короткое стандартное приглашение 0 не меняет приглашение
#
# PROMPTMSG[=''] Сообщение в приглашении
#
# Приглашение имеет вид
#   1       2             3         4          5        6
# ┌(*)─(This is MSG)─(Thu Jan 14)─(12:42)─(e0:j0:w1:t1)─(mc)
# └─(root@ov-ansible)─(bin) #
#     7        8        9
# 1 Символ пятницы
# 2 Сообщение в приглашении, перем PROMPTMSG
# 3 Дата - День недели, месяц, число
# 4 Время, 24 часа
# 5 Индикаторы exit code, job, who, tty
# 6 Индикатор работы mc
# 7 Пользователь
# 8 Короткое имя host
# 9 Текущее местоположение

__myprompt() {
  local EXIT=$?

  history -a
  history -c
  history -r

  local sp=
  local numprompt=0

  local Color_Off='\[\e[m\]'
  
  local Green='\[\e[0;32m\]'
  local Yellow='\[\e[0;33m\]'
  local Purple='\[\e[0;35m\]'
  local White='\[\e[0;37m\]'
  
  local IRed='\[\e[0;91m\]'
  local IGreen='\[\e[0;92m\]'
  local IYellow='\[\e[0;93m\]'
  local IBlue='\[\e[0;94m\]'
  local IPurple='\[\e[0;95m\]'
  local ICyan='\[\e[0;96m\]'

  local BBlack='\[\e[1;30m\]'
  local BRed='\[\e[1;31m\]'
  local BGreen='\[\e[1;32m\]'

  local color0=
  local color1=
  # Exit code
  local color2=
  # Color frame
  local color3=

  local pwd1="\\W"

  local WHO=$(/usr/bin/who | /usr/bin/wc -l)
  local TTY=$(/usr/bin/tty | /usr/bin/cut -d/ -f4)
  local JBS=$(/usr/bin/jobs -l | /usr/bin/wc -l)
  

  # Friday
  local EMOJ=

  if [[ ${CLICOLOR:-0} -eq 0 ]]; then
    Green=
    Yellow=
    Purple=
    White=
    IRed=
    IGreen=
    IYellow=
    IBlue=
    IPurple=
    ICyan=
    BBlack=
    BRed=
    BGreen=
  fi

  color3="${Color_off}${BBlack}"

  if [[ "${EXIT}" -eq 0 ]]; then
    color2=${IGreen}
  else
    color2=${IRed}
  fi

  if [[ $(/usr/bin/id -u) -eq 0 ]]; then
    color0=${BRed}
    color1=${IRed}
  else
    color0=${BGreen}
    color1=${IGreen}
    pwd1="\\w"
  fi

  # Show long path
  if [[ "${LONGPATH:-0}" -eq 1 ]]; then
    pwd1="\\w"
  fi

  PS1="${color3}\\n┌"

  # Friday
  if [[ $(/usr/bin/date +%u) -ge 5 ]]; then
    EMOJ=`printf '\U263C'`
    PS1+="(${Yellow}${EMOJ}${color3})"
    numprompt=1
  fi

  # Title message
  if [[ -n "${PROMPTMSG-}" ]]; then
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="( -- ${ICyan}${PROMPTMSG-}${color3} -- )"
    numprompt=1
  fi

  # String 1
  if [[ "${PROMPTTIME-1}" = "1" ]]; then
    #PS1+="(${Blue}\\d${Color_Off})─(${Blue\\A${Color_Off})"
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="(${IBlue}\\d \\A${color3})"
    numprompt=1
  fi
  
  #PS1+="─(e${color2}${EXIT}${Color_Off}:j${Green}\\j${Color_Off}:w${Green}${WHO}${Color_Off}:t${Green}${TTY}${Color_Off})"

  # Exit code
  if [[ ! "${EXIT}" = "0" && "${PROMPTEXIT-1}" = "1" ]]; then
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="(err:${color2}${EXIT}${color3})"
    numprompt=1
  fi

  # Jobs count
  if [[ ! "${JBS}" = "0" && "${PROMPTJOBS-1}" = "1" ]]; then
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="(jobs:${Green}${JBS}${color3})"
    numprompt=1
  fi

  # Who
  if [[ "${PROMPTWHO-0}" = "1" ]]; then
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="(who:${White}${WHO}${color3})"
    numprompt=1
  fi

  # TTY
  if [[ "${PROMPTTTY-0}" = "1" ]]; then
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="(tty:${White}${TTY}${color3})"
    numprompt=1
  fi

  # mc
  if ps $PPID |grep -q mc; then
    if [[ "${numprompt}" -gt 0 ]]; then
      PS1+="─"
    fi
    PS1+="(${IPurple}mc${color3})"
    numprompt=1
  fi

  PS1+="\\n└─"

  PS1+="(${color0}\\u@${Purple}\\h${color3})─(${Yellow}${pwd1}${color3}) ${color1}\\\$ "

  PS1+="${Color_Off}"

  # Title terminal
  case $TERM in
  xterm*|vte*)
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    ;;
  screen*)
    printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"
    ;;
  esac

  # -- ${PROMPTMSG-} --
  # "[\\u@\\h ${pwd1}] \\\$ "
  if [[ "${EASYPROMPT-0}" = '1' ]]; then
    PS1="${color3}"
    if [[ -n "${PROMPTMSG-}" ]] ; then
      PS1+="\\n -- ${ICyan}${PROMPTMSG}${color3} --"
    fi
    PS1+="\\n[${color0}\\u@${Purple}\\h ${Yellow}${pwd1}${color3}] ${color1}\\\$ ${Color_Off}"
  fi

  # [ \\d \\A ${PROMPTMSG-}] 
  # [\\u@\\h ${pwd1}] \\\$ "
  if [[ "${EASYPROMPT-0}" = '2' ]]; then
    if [[ -n "${PROMPTMSG-}" ]] ; then
      sp=' '
    else
      sp=''
    fi
    PS1="${color3}\\n [${IBlue}\\d \\A${sp}${ICyan}${PROMPTMSG}${color3}] [${color0}\\u@${Purple}\\h ${Yellow}${pwd1}${color3}]\\n ${color1}\\\$ ${Color_Off}"
  fi


  # [\\u@\\h] ${PROMPTMSG-} 
  # ${pwd1} \\\$ "
  if [[ "${EASYPROMPT-0}" = '3' ]]; then
    PS1="${color3}\\n [${color0}\\u@${Purple}\\h${color3}]"
    if [[ -n "${PROMPTMSG-}" ]] ; then
      PS1+=" [${ICyan}${PROMPTMSG}${color3}]"
    fi
    PS1+="\\n ${Yellow}${pwd1} ${color1}\\\$ ${Color_Off}"
  fi
  

  # -- ${PROMPTMSG-} --
  # \\u@\\h ${pwd1} \\\$ "
  if [[ "${EASYPROMPT-0}" = '4' ]]; then
    PS1="${color3}"
    if [[ -n "${PROMPTMSG-}" ]] ; then
      PS1+="\\n -- ${ICyan}${PROMPTMSG}${color3} --"
    fi
    PS1+="\\n ${color0}\\u@${Purple}\\h ${Yellow}${pwd1} ${color1}\\\$ ${Color_Off}"
  fi

  
  # "[\\u@\\h ${pwd1}] \\\$ "
  if [[ "${EASYPROMPT-0}" = '5' ]]; then
    PS1="${color3}\\n[${color0}\\u@${Purple}\\h ${Yellow}${pwd1}${color3}] ${color1}\\\$ ${Color_Off}"
  fi


  export PS1
}
# ############
# __myprompt
# ############

if [[ -x /usr/bin/mcedit ]]; then
    export EDITOR=/usr/bin/mcedit
fi

if type most &>/dev/null ; then
    export PAGER=most
fi

echo 'SELECTED_EDITOR="/usr/bin/mcedit"' > ~/.selected_editor

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GREP_COLORS='ms=01;42;93:mc=01;42:sl=:cx=:fn=01;35:ln=32:bn=32:se=36'

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

# ######
# COLORS
# ######

if [[ -n "${LS_COLORS}" ]]; then
  export LS_COLORS="${LS_COLORS:+$LS_COLORS*.conf=38;5;149:*.cfg=38;5;149:*.key=38;5;141:*.cer=38;5;141:*.crt=38;5;141:*.pem=38;5;141:*.bash_aliases=38;5;134:*.bash_history=38;5;134:*.bash_logout=38;5;134:*.bash_profile=38;5;134:*.bashrc=38;5;134:*.dir_colors=38;5;134:*.patch=38;5;105:*.diff=38;5;105:}"
fi

#if [[ -r /etc/profile.d/colorls.sh ]]; then
#    . /etc/profile.d/colorls.sh
#fi

if [[ -n "${CLICOLOR-}" ]]; then
  export LS_OPTIONS='--color=auto'
fi

alias grep='/usr/bin/grep --color=auto' 2>/dev/null
alias fgrep='/usr/bin/grep --color=auto' 2>/dev/null
alias egrep='/usr/bin/grep --color=auto' 2>/dev/null

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
alias lsdate="/usr/bin/ls $LS_OPTIONS -l --time-style='+%d-%m-%Y'" 2>/dev/null

alias ffile='/usr/bin/find . -type f -name '
alias fhere='/usr/bin/find . -name '
alias psg='/usr/bin/ps aux | /usr/bin/grep -v grep | /usr/bin/grep -i -e VSZ -e'
alias mkdir='/usr/bin/mkdir -pv'
alias wget='/usr/bin/wget -c'
alias histg='history | /usr/bin/grep'
alias hostip='/usr/bin/curl http://ipecho.net/plain; echo'
alias net='/usr/bin/netstat -ntulp'
alias j='/usr/bin/jobs -l'
alias ports='/usr/bin/netstat -tulanp'

### Set default interfaces for sys admin related commands

## All of our servers eth1 is connected to the Internets via vlan / router etc  ##
alias dnstop='/usr/bin/dnstop -l 5 ens160'
alias vnstat='/usr/bin/vnstat -i ens160'
alias iftop='/usr/sbin/iftop -i ens160'
alias tcpdump='/usr/sbin/tcpdump -i ens160'
alias ethtool='/usr/sbin/ethtool ens160'

# work on wlan0 by default #
# Only useful for laptop as all servers are without wireless interface
alias iwconfig='/usr/bin/iwconfig wlan0'

### Get system memory, cpu usage, and gpu memory info quickly
## pass options to free ##
alias meminfo='/usr/bin/free -m -l -t'

## get top process eating memory
alias psmem='/usr/bin/ps auxf | /usr/bin/sort -nr -k 4'
alias psmem10='/usr/bin/ps auxf | /usr/bin/sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='/usr/bin/ps auxf | /usr/bin/sort -nr -k 3'
alias pscpu10='/usr/bin/ps auxf | /usr/bin/sort -nr -k 3 | head -10'

#  15 процессов, которые больше всего потребляют памяти
alias top15='/usr/bin/top -b -o +%MEM | /usr/bin/head -n 22'

## Get server cpu info ##
alias cpuinfo='/usr/bin/lscpu'

## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##

## get GPU ram on desktop / laptop##
alias gpumeminfo='/usr/bin/grep -i --color memory /var/log/Xorg.0.log'

alias h='history 10'
alias mc='. /usr/libexec/mc/mc-wrapper.sh'

alias myip="/usr/bin/ip a | /usr/bin/grep inet | /usr/bin/grep 'scope global'"

if type -P vim &>/dev/null; then
    alias vi=/usr/bin/vim
fi

# https://github.com/garabik/grc
if type grc &>/dev/null; then
   if [[ -r ~/.grc.bashrc ]]; then
       . ~/.grc.bashrc
   elif [[ -r /etc/grc.bashrc ]]; then
       . /etc/grc.bashrc
   fi
fi

# Set the Less input preprocessor.
if type lesspipe.sh &>/dev/null; then
    export LESS_ADVANCED_PREPROCESSOR=1
    export LESSOPEN="|$(type -p lesspipe.sh) %s"
fi

if type pygmentize &>/dev/null; then
    export LESSCOLORIZER=`type -p pygmentize`
fi

# [[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

if type colordiff &>/dev/null ; then
    alias diff=`type -p colordiff`
fi

#if [[ -r /etc/profile.d/bash_completion.sh ]]; then
#    . /etc/profile.d/bash_completion.sh
#fi

export PROMPT_COMMAND='__myprompt'
export PS1='[\u@\h \W] \$ '
