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
#make sure the history is updated at every command
export PROMPT_COMMAND="history -a; history -n;"

#!! sets vi mode for shell
set -o vi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#path should have durdn config bin folder
export PATH=$HOME/.cfg/bin:$PATH
#set the terminal type to 256 colors
export TERM=xterm-256color


# }}}
# Tmux startup {{{
#if which tmux 2>&1 >/dev/null; then
    ## if no session is started, start a new session
    #test -z ${TMUX} && tmux

    ## when quitting tmux, try to attach
    #while test -z ${TMUX}; do
        #tmux attach || break
    #done
#fi
# }}}
#Prompt customisation {{{
function git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\]/'
}

hg_branch() {
    hg branch 2> /dev/null | \
        awk '{ printf "[\033[1;31m" $1 "]"}'
    hg bookmarks 2> /dev/null | \
        awk '/\*/ { printf "[\033[0;32m" $2 "]" }'
}
# Prompt ir_black {{{
function prompt-irblack {
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
$LIGHT_GRAY2[$LIGHT_BLUE\h$LIGHT_GRAY2:$BLUE\w$LIGHT_GRAY2]$RED\$(git_branch)\$(hg_branch)$LIGHT_GRAY2\
$LIGHT_GRAY\n\$ "
PS2='> '
PS4='+ '
}
# }}}
# Prompt solarized {{{
function prompt-solarized {
  local WHITE="\[\033[1;37m\]"
  local BLACK="\[\033[0;30m\]"
  local BLUE="\[\033[0;34m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local CYAN="\[\033[0;36m\]"
  local RED="\[\033[1;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local GREEN2="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local WHITE="\[\033[1;37m\]"
  local LIGHT_GRAY="\[\033[1;37m\]"
  local MAGENTA="\[\033[1;35m\]"
  local LIGHT_GRAY2="\[\033[1;36m\]"
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
$WHITE[$GREEN\u$WHITE]\
$LIGHT_GRAY2[$LIGHT_BLUE\h$LIGHT_GRAY2:$BLUE\w$LIGHT_GRAY2]$RED\$(git_branch)$LIGHT_GRAY2\
$WHITE\n\$ "
PS2='> '
PS4='+ '
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export LS_COLORS="di=34:ln=1;35:so=32:pi=33:ex=1;31:bd=34:cd=34:su=0;41:sg=0;46:tw=0;42:ow=0;43:fi=1;37:"
}
# }}}
prompt-irblack

# }}}
# durdn/cfg related commands {{{
function dur {
  case $1 in
  create|cr)
    echo "disabled"
    ;;
  list|li)
    echo "disabled"
    ;;
  clone|cl)
    git clone git@bitbucket.org:durdn/$2.git
    ;;
  install|i)
    $HOME/.cfg/install.sh
    ;;
  reinstall|re)
    curl -Ls https://raw.github.com/durdn/cfg/master/install.sh | bash
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
alias hla="cat ~/.hgrc | grep -m1 -A10000 alias | tail -n +2 | grep -m1 -B10000 '^\[' | sed '\$d'"
alias stashup='git stash && git svn rebase && git stash apply'
alias vimo='vim -O '
alias laste='tail -1000 ~/.bash_history | grep ^vim | col 2'
function list-patch {
  git log --oneline --decorate --numstat -1 $1 | tail -n +2 | awk {'print $3'}
}

function svnlnc {
  paste -d\  <(git svn log --oneline --show-commit $1 $2 $3 $4 | col 1) <(git log --pretty=format:%h\ %s\ [%cn] $1 $2 $3 $4)
}

function svnl {
  paste -d\  <(git svn log --oneline --show-commit $1 $2 $3 $4 | col 1) <(git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" $1 $2 $3 $4)
}

function f {
  find . -type f | grep -v .svn | grep -v .git | grep -i $1
}

function gr {
  find . -type f | grep -v .svn | grep -v .git | xargs grep -i $1 | grep -v Binary
}

function col {
  awk -v col=$1 '{print $col}'
}

function xr {
  case $1 in
  1)
    xrandr -s 1680x1050
    ;;
  2)
    xrandr -s 1440x900
    ;;
  3)
    xrandr -s 1024x768
    ;;
  esac
}

# shows last modification dat for trunk and r1.2.0 branch
function glm {
  echo master $(git fl master $1 | grep -m1 Date:)
  echo r1.2.0 $(git fl r12 $1 | grep -m1 Date:)
}

# git rename current branch and backup if overwritten
function gmb {
  curr_branch_name=$(git branch | grep \* | cut -c 3-);
  if [ -z $(git branch | cut -c 3- | grep -x $1) ]; then
    git branch -m $curr_branch_name $1
  else 
    temp_branch_name=$1-old-$RANDOM;
    echo target branch name already exists, renaming to $temp_branch_name
    git branch -m $1 $temp_branch_name
    git branch -m $curr_branch_name $1
  fi
}

# git search for extension $1 and occurrence of string $2
function gfe {
  git f \.$1 | xargs grep -i $2 | less
}

#open with vim from a list of files, nth one (vim file number x)
function vfn {
  last_command=$(history 2 | head -1 | cut -d" " -f2- | cut -c 2-);
  vim $($last_command | head -$1 | tail -1)
}

# }}}
# Linux specific config {{{
if [ $(uname) == "Linux" ]; then
  shopt -s autocd
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
  alias pacman='sudo pacman'
  alias pac='sudo pacman'

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
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
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
# Clients configs {{{
# Delixl config {{{
if [ $(uname -n) == "ubuntu" ] && [ $(whoami) == "developer" ]; 
  then source ~/.delixl-aliases
fi
if [ $(cat /etc/resolv.conf | grep domain | col 2) == 'delixl.ext' ] && [ $(uname) == "Darwin" ]; then
  echo "Setting route at DeliXL office";
  sudo route add -net 145.7.5.0 -netmask 255.255.255.0 10.33.88.1
  sudo route add -net 10.33.0.0 -netmask 255.255.0.0   10.33.88.1
fi
# }}}
# }}}
# rvm setup {{{
if [ -e $HOME/.rvm/scripts/rvm ]; then 
  source $HOME/.rvm/scripts/rvm
  PATH=$PATH:$HOME/.rvm/bin
fi
# }}}
