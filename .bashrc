# .bashrc
# Author: Nicola Paolucci <nick@durdn.com>
# Source: http://github.com/durdn/cfg/.bashrc

#Global options {{{
export HISTFILESIZE=999999
export HISTSIZE=999999
export HISTCONTROL=ignoredups:ignorespace
shopt -s checkwinsize
shopt -s progcomp

#!! sets vi mode for shell
set -o vi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# }}}
# durdn/cfg related commands {{{
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
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
alias vimo='vim -O '
alias dpaste="curl -F 'content=<-' https://dpaste.de/api/"
# }}}
# Global functions (aka complex aliases) {{{
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

# shows last modification date for trunk and $1 branch
function glm {
  echo master $(git log -u master $2 | grep -m1 Date:)
  echo $1 $(git log -u $1 $2 | grep -m1 Date:)
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

# Convert a Confluence page on EAC to markdown
function markdowneac {
curl -Lks -u npaolucci https://@extranet.atlassian.com/rest/prototype/1/content/$1  | xmlstarlet sel -I -t -v "/content/body" | xmlstarlet unesc | pandoc -f html -t markdown --atx-headers --no-wrap --reference-links
}
# link all Go folders into projects folder
function lngo {
  ls -1 | xargs -I{} ln -s $(pwd)/{} /Users/np/p/
}
# cd into go source libraries
gocd() {
    cd `go list -f '{{.Dir}}' $1`
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

  #rbenv setup
  if [ -d $HOME/.rbenv ]; then
    export RBENV_ROOT=/usr/local/var/rbenv
    export PATH="/usr/local/var/rbenv/shims:$PATH"
    eval "$(rbenv init -)";
  fi
fi


# }}}
# OSX specific config {{{
if [ $(uname) == "Darwin" ]; then
  export TERM=xterm-256color
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
  alias dm='docker-machine'
  alias dc='docker-compose'
  alias dk='docker'
  alias dn='docker network'

  #open macvim
  function gvim {
    if [ -e $1 ];
      then open -a MacVim $@;
      else touch $@ && open -a MacVim $@;
    fi
  }

  #setup rbenv {{{
  if which rbenv > /dev/null; then
    export RBENV_ROOT=/usr/local/var/rbenv
    eval "$(rbenv init -)";
    #export PATH="$HOME/.rbenv/shims:$PATH"
    export PATH="/usr/local/var/rbenv/shims:$PATH"
  fi
  # }}}
  #homebrew git autocompletions {{{
  if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    . `brew --prefix`/etc/bash_completion.d/git-completion.bash
  fi
  #}}}

  #Pipe2Eval folder for vim extension
  export PIP2EVAL_TMP_FILE_PATH=/tmp/shms

  export WORKON_HOME="/Users/npaolucci/dev/envs"
#  export VIRTUALENV_USE_DISTRIBUTE=1
#  [[ -n "/usr/local/bin/virtualenvwrapper.sh" ]] && source virtualenvwrapper.sh

# golang setup {{{
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
  #export PATH=$HOME/dev/apps/go_appengine:$PATH
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
# Specific systems configs {{{
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
if [[ $(hostname | cut -d. -f1) == "reborn" ]]; then
  export PATH="$HOME/dev/apps/maven2/bin:$PATH"
  MAVEN_OPTS="-Xms256m -Xmx1g -XX:PermSize=128m -XX:MaxPermSize=256m -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"
  export MAVEN_OPTS
  source $HOME/.atlassian
  export VIRTUAL_ENV_DISABLE_PROMPT=1
  function new_post {

    NEW_POST_TITLE="$(echo $@ | sed -e "s/ /-/g")"
    NEW_POST_DIR="$HOME/p/developer.atlassian.com/app/posts/$(date +"%Y/%m")/$NEW_POST_TITLE"
    mkdir -p  $NEW_POST_DIR
    cat >> $NEW_POST_DIR/index.md << "EOF"
---
title: "Title"
date: "2016-12-31 06:00"
author: "npaolucci"
categories: ["Docker","Git"]
---

## Conclusions

In any case if you found this interesting at all and want more why not follow
me at [@durdn] or my awesome team at [@atlassiandev]?

[@atlassiandev]: https://www.twitter.com/atlassiandev
[@durdn]: https://www.twitter.com/durdn
EOF
    echo "Created: $NEW_POST_DIR/index.md"
    git checkout develop
    git checkout -b blog/$NEW_POST_TITLE
    git add $NEW_POST_DIR/index.md
  }

  function new_post_worktree {

    NEW_POST_TITLE="$(echo $@ | sed -e "s/ /-/g")"
    cd $HOME/p/developer.atlassian.com
    git checkout master
    git worktree add -b blog/$NEW_POST_TITLE $NEW_POST_TITLE 
    cd $NEW_POST_TITLE
    NEW_POST_DIR="app/posts/$(date +"%Y/%m")/$NEW_POST_TITLE"
    mkdir -p  $NEW_POST_DIR
    cat >> $NEW_POST_DIR/index.md << "EOF"
---
title: "Title"
date: "2016-12-31 06:00"
author: "npaolucci"
categories: ["Docker","Git"]
---

## Conclusions

In any case if you found this interesting at all and want more why not follow
me at [@durdn] or my awesome team at [@atlassiandev]?

[@atlassiandev]: https://www.twitter.com/atlassiandev
[@durdn]: https://www.twitter.com/durdn
EOF
    echo "Created: $NEW_POST_DIR/index.md"
    git add $NEW_POST_DIR/index.md
  }
fi
# }}}
# }}}
# Liquid Prompt {{{
LP_ENABLE_SVN=0
LP_ENABLE_FOSSIL=0
LP_ENABLE_BZR=0
LP_ENABLE_BATT=0
LP_ENABLE_LOAD=0
LP_ENABLE_PROXY=0
LP_USER_ALWAYS=0
LP_HOSTNAME_ALWAYS=0
source $HOME/.liquidprompt
#make sure the history is updated at every command
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# }}}
# Java setup {{{
# export PATH=$HOME/jdk1.8.0_31/bin:$PATH
# export JAVA_HOME=$HOME/jdk1.8.0_31/
# }}}
# Set .bin in PATH and it should be first {{{
export PATH=$HOME/.bin:$PATH
# }}}
