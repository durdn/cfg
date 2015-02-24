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
# durdn/cfg related commands {{{
function dur {
  case $1 in
  create|cr)
    echo "disabled"
    ;;
  list|li)
    curl --user $2:$3 https://api.bitbucket.org/1.0/user/repositories 2> /dev/null | grep "name" | sed -e 's/\"//g' | col 2 | sort | uniq | column
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
  key|k)
    #track all remote branches of a project
    ssh $2 'mkdir -p .ssh && cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub
    ;;
  fun|f)
    #list all custom bash functions defined
    typeset -F | col 3 | grep -v _ | xargs | fold -sw 60
    ;;
  def|d)
    #show definition of function $1
    typeset -f $2
    ;;
  help|h|*)
    echo "[dur]dn shell automation tools - (c) 2011 Nicola Paolucci nick@durdn.com"
    echo "commands available:"
    echo " [cr]eate, [li]st, [cl]one"
    echo " [i]nstall,[m]o[v]e, [re]install"
    echo " [f]fun lists all bash functions defined in .bashrc"
    echo " [def] <fun> lists definition of function defined in .bashrc"
    echo " [k]ey <host> copies ssh key to target host"
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
#alias go='git checkout '
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
  paste -d\  <(git svn log --oneline --show-commit $1 $2 $3 $4 | col 1) <(git log --pretty=format:"%C(yellow)%h %Cgreen%ad%Cred%d %Creset%s%Cblue [%cn]" --date=short $1 $2 $3 $4)
}

function f {
  find . -type f | grep -v .svn | grep -v .git | grep -i $1
}

function gr {
  find . -type f | grep -v .svn | grep -v .git | xargs grep -i $1 | grep -v Binary
}

# print only column x of output
function col {
  awk -v col=$1 '{print $col}'
}

# skip first x words in line
function skip {
    n=$(($1 + 1))
    cut -d' ' -f$n-
}

# global search and replace OSX
function sr {
    find . -type f -exec sed -i '' s/$1/$2/g {} +
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

# shows last modification dat for trunk and $1 branch
function glm {
  echo master $(git fl master $2 | grep -m1 Date:)
  echo $1 $(git fl $1 $2 | grep -m1 Date:)
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

#autocomplete list of possible files and ask which one to open
function gv {
  search_count=1
  search_command="git f"
  search_result=$($search_command $1)
  editor=gvim

  for f in $search_result; do echo $search_count. $f;search_count=$(($search_count+1)); done

  arr=($search_result)
  case "${#arr[@]}" in
    0)
       ;;
    1) nohup $editor ${search_result} 2>/dev/null &
       ;;
    *) echo "enter file number:"
       read fn
       nohup $editor ${arr[fn-1]} 2>/dev/null &
       ;;
  esac
}

#open a scratch file in Dropbox
function sc {
  gvim ~/Dropbox/$(openssl rand -base64 10 | tr -dc 'a-zA-Z').txt
}
function scratch {
  gvim ~/Dropbox/$(openssl rand -base64 10 | tr -dc 'a-zA-Z').txt
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

  if [ -d $HOME/.rbenv ]; then
    export RBENV_ROOT=/usr/local/var/rbenv
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)";
  fi

  #PATH=$PATH:$HOME/dev/apps/node/bin
fi


# }}}
# OSX specific config {{{
if [ $(uname) == "Darwin" ]; then
  #set the terminal type to 256 colors
  export TERM=xterm-256color

  #export PATH=/usr/local/mysql/bin:$HOME/bin:/opt/local/sbin:/opt/local/bin:$PATH
  #export PATH=/Users/nick/.clj/bin:$PATH
  export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/Cellar/python3/3.4.1/bin:$HOME/bin:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH

  #aliases 
  alias ls='ls -G'
  alias ll='ls -ltrG'
  alias la='ls -alG'
  alias less='less -R'
  alias fnd='open -a Finder'
  alias gitx='open -a GitX'
  alias grp='grep -RIi'
  alias assumed="git ls-files -v | grep ^[a-z] | sed -e 's/^h\ //'"

  #open macvim
  function gvim {
    if [ -e $1 ];
      then open -a MacVim $@;
      else touch $@ && open -a MacVim $@; 
    fi
  }

  #setup sqlplus
  #export DYLD_LIBRARY_PATH="/opt/local/lib/oracle:/Users/nick/dev/apps/sqlplus-ic-10.2"
  #export TNS_ADMIN="/Users/nick/dev/apps/sqlplus-ic-10.2"
  #export PATH=/Users/nick/dev/apps/sqlplus-ic-10.2:$PATH

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
  if which rbenv > /dev/null; then
    export RBENV_ROOT=/usr/local/var/rbenv
    eval "$(rbenv init -)";
    export PATH="$HOME/.rbenv/bin:$PATH"
  fi

  #homebrew git autocompletions
  if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    . `brew --prefix`/etc/bash_completion.d/git-completion.bash
  fi

  #Java home setting
  export JAVA_HOME=$(/usr/libexec/java_home)
  #Pipe2Eval folder for vim extension
  export PIP2EVAL_TMP_FILE_PATH=/tmp/shms

  export WORKON_HOME="/Users/npaolucci/dev/envs"
#  export VIRTUALENV_USE_DISTRIBUTE=1
#  [[ -n "/usr/local/bin/virtualenvwrapper.sh" ]] && source virtualenvwrapper.sh

  # golang setup {{{
  # export GOPATH=$HOME/dev/projects/go/
  # export PATH=$PATH:$GOPATH/bin
  export GOPATH=/usr/local/opt/go/libexec
  export PATH=$PATH:$GOPATH/bin
  export PATH=$HOME/dev/apps/go_appengine:$PATH
  # }}}
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
# Boot2docker specific config {{{
if [[ $(uname -a | col 2) == "boot2docker" ]]; then
  export TERM=xterm
fi
# }}}
# Clients configs {{{
# Delixl config {{{
if [[ $(uname -n) == "ubuntu" && $(whoami) == "developer" ]]; then
  source ~/.delixl-aliases
fi
if [[ -e /etc/resolv.conf && $(cat /etc/resolv.conf | grep domain | col 2 | head -1) == 'delixl.ext' && $(uname) == "Darwin" ]]; then
  echo "Setting route at DeliXL office";
  sudo route add -net 145.7.5.0 -netmask 255.255.255.0 10.33.88.1
  sudo route add -net 145.7.0.0 -netmask 255.255.255.0 10.33.88.1
  sudo route add -net 10.33.0.0 -netmask 255.255.0.0   10.33.88.1
fi
# }}}
# Atlassian config {{{
if [[ $(hostname | cut -d. -f1) == "pother" ]]; then
  export PATH="$HOME/dev/apps/maven2/bin:$PATH"
  MAVEN_OPTS="-Xms256m -Xmx1g -XX:PermSize=128m -XX:MaxPermSize=256m -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"
  export MAVEN_OPTS
  source $HOME/.atlassian
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  #source $HOME/dev/envs/generic/bin/activate
fi
# }}}
# }}}
# rvm setup {{{
if [ -e $HOME/.rvm/scripts/rvm ]; then 
  source $HOME/.rvm/scripts/rvm
  PATH=$PATH:$HOME/.rvm/bin
fi
# }}}
# liquid prompt {{{
LP_ENABLE_SVN=0
LP_ENABLE_FOSSIL=0
LP_ENABLE_BZR=0
LP_ENABLE_BATT=0
LP_ENABLE_LOAD=0
LP_ENABLE_PROXY=0
LP_USER_ALWAYS=0
LP_HOSTNAME_ALWAYS=0
source $HOME/.liquidprompt
# }}}
export PATH=$HOME/jdk1.8.0_31/bin:$PATH
export JAVA_HOME=$HOME/jdk1.8.0_31/
