# .bashrc
# Author: Nicola Paolucci <nick@durdn.com>
# Source: http://github.com/durdn/cfg/.bashrc

#Global options {{{
export HISTFILESIZE=999999
export HISTSIZE=999999
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s checkwinsize
shopt -s progcomp
shopt -s autocd

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# }}}
#Prompt customisation {{{
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\]/'
}

function proml {
  local WHITE="\[\033[1;37m\]"
  local BLACK="\[\033[0;30m\]"
  local BLUE="\[\033[0;34m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local CYAN="\[\033[0;36m\]"
  local RED="\[\033[0;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local GREEN2="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local WHITE="\[\033[1;37m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local MAGENTA="\[\033[1;35m\]"
  local LIGHT_GRAY2="\[\033[0;37m\]"
  local DARK_GRAY="\[\033[1;30m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

PS1="${TITLEBAR}\
$LIGHT_GRAY2[$DARK_GRAY\u$LIGHT_GRAY2]\
$LIGHT_GRAY2[$LIGHT_BLUE\h$LIGHT_GRAY2:$BLUE\w$LIGHT_GRAY2]$RED\$(parse_git_branch)$LIGHT_GRAY2\
$LIGHT_GRAY\n\$ "
PS2='> '
PS4='+ '
}
proml

# }}}
# durdn/cfg related commands {{{
function dur {
  case $1 in
  create|cr)
    ssh durdn@durdn.com "cd /home/durdn/git && mkdir $2.git && cd $2.git && git --bare init-db"
    ;;
  list|li)
    ssh durdn@durdn.com "cd /home/durdn/git && ls -C"
    ;;
  clone|cl)
    git clone ssh://durdn@durdn.com/~/git/$2.git
    ;;
  install|i)
    /usr/bin/env python $HOME/.cfg/install.py
    ;;
  reinstall|re)
    curl https://raw.github.com/durdn/cfg/master/install.py -o - | python
    ;;
  move|mv)
    git remote add bitbucket git@bitbucket.org:durdn/$(basename $(pwd)).git
    git push --all bitbucket
    ;;
  trackall|tr)
    #track all remote branches of a project
    for remote in $(git branch -r | grep -v master ); do git checkout --track $remote ; done
    ;;
  help|h|*)
    echo "[dur]dn shell automation tools - (c) 2011 Nicola Paolucci nick@durdn.com"
    echo "commands available:"
    echo " [cr]eate, [li]st, [cl]one"
    echo " [i]nstall,[m]o[v]e, [re]install"
    echo " [tr]ackall], [h]elp"
    ;;
  esac
}

# }}}
# Bashmarks from https://github.com/huyng/bashmarks (see copyright there) {{{

# USAGE:
# s bookmarkname - saves the curr dir as bookmarkname
# g bookmarkname - jumps to the that bookmark
# g b[TAB] - tab completion is available
# l - list all bookmarks

# save current directory to bookmarks
touch ~/.sdirs
function s {
  cat ~/.sdirs | grep -v "export DIR_$1=" > ~/.sdirs1
  mv ~/.sdirs1 ~/.sdirs
  echo "export DIR_$1=$PWD" >> ~/.sdirs
}

# jump to bookmark
function g {
  source ~/.sdirs
  cd $(eval $(echo echo $(echo \$DIR_$1)))
}

# list bookmarks with dirnam
function l {
  source ~/.sdirs
  env | grep "^DIR_" | cut -c5- | grep "^.*="
}
# list bookmarks without dirname
function _l {
  source ~/.sdirs
  env | grep "^DIR_" | cut -c5- | grep "^.*=" | cut -f1 -d "="
}

# completion command for g
function _gcomp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_l`' -- $curw))
    return 0
}

# bind completion command for g to _gcomp
complete -F _gcomp g
# }}}
# Fixes hg/mercurial {{{
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# }}}
#Global aliases  {{{
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit '
alias gd='git diff '
alias go='git checkout '
alias stashup='git stash && git svn rebase && git stash apply'
function list-patch {
  git log --oneline --decorate --numstat -1 $1 | tail -n +2 | awk {'print $3'}
}

function f {
  find . -type f | grep -v .svn | grep -v .git | grep -i $1
}

function gr {
  find . -type f | grep -v .svn | grep -v .git | xargs grep -i $1 | grep -v Binary
}


# }}}
# Linux specific config {{{
if [ $(uname) == "Linux" ]; then
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi

  #alias assumed="git ls-files -v | grep ^[a-z] | sed -e 's/^h\ //'"
  alias assumed="git ls-files -v | grep ^h | sed -e 's/^h\ //'"
  # Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  #apt aliases
  alias apt='sudo apt-get'
  alias cs='sudo apt-cache search'

  alias ls='ls --color'
  alias ll='ls -l --color'
  alias la='ls -al --color'
  alias less='less -R'

  #project aliases
  #alias tarot="screen -c ./screen-tarot.config"

  #PATH=$PATH:$HOME/dev/apps/node/bin
fi


# }}}
# OSX specific config {{{
if [ $(uname) == "Darwin" ]; then
  #export PATH=/usr/local/mysql/bin:$HOME/bin:/opt/local/sbin:/opt/local/bin:$PATH
  #export PATH=/Users/nick/.clj/bin:$PATH
  export PATH=/usr/local/bin:/usr/local/Cellar/python/2.7.2/bin:/usr/local/share/python:$HOME/bin:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH

  #aliases 
  alias ls='ls -G'
  alias ll='ls -lG'
  alias la='ls -alG'
  alias less='less -R'
  alias fnd='open -a Finder'
  alias gitx='open -a GitX'
  alias grp='grep -RIi'
  alias assumed="git ls-files -v | grep ^[a-z] | sed -e 's/^h\ //'"

  #open macvim
  function gvim {
    if [ -e $1 ];
      then open -a MacVim $1;
      else touch $1 && open -a MacVim $1; 
    fi
  }

  #setup sqlplus
  export DYLD_LIBRARY_PATH="/opt/local/lib/oracle:/Users/nick/dev/apps/sqlplus-ic-10.2"
  export TNS_ADMIN="/Users/nick/dev/apps/sqlplus-ic-10.2"
#  export PATH=/Users/nick/dev/apps/sqlplus-ic-10.2:$PATH

  #project aliases
  alias tarot="screen -c ./screen-tarot.config"
  alias atg="screen -c ./screen-atg.config"

  #sourcing

  #source /Users/nick/dev/envs/boi-env/bin/activate
  #source /Users/nick/.philips
  #source git bash completion from homebrew on OSX
  #source /usr/local/etc/bash_completion.d/git-completion.bash

  #setup RVM on OSX
  #[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

  #setup rbenv
  #export PATH="$HOME/.rbenv/bin:$PATH"
  #eval "$(rbenv init -)"
fi

# }}}
# MINGW32_NT-5.1 (winxp) specific config {{{
if [ $(uname) == "MINGW32_NT-5.1" ]; then
  alias ls='ls --color'
  alias ll='ls -l --color'
  alias la='ls -al --color'
  alias less='less -R'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# }}}
