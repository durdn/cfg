# .zshrc
# Author: Nicola Paolucci <nick@durdn.com>
# Source: http://github.com/durdn/cfg/.zshrc

# zsh/oh-my-zsh global setup {{{
ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="durdn"
DISABLE_AUTO_TITLE="true"
DISABLE_AUTO_UPDATE="true"
# COMPLETION_WAITING_DOTS="true"
plugins=()

source $ZSH/oh-my-zsh.sh
bindkey -M menuselect '^M' .accept-line

# }}}
# Theme Prompt {{{
PROMPT='%{$fg[black]%}[%n]%{$reset_color%}[%{$fg_bold[blue]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%2~%{$reset_color%}]$(git_prompt_info)%{$reset_color%}
%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"

# }}}
#Global git aliases  {{{
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


# }}}
# Linux specific config {{{
if [ $(uname) = "Linux" ]; then
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi

  alias assumed="git ls-files -v | grep ^h | sed -e 's/^h\ //'"
  # Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  #apt aliases
  alias apt='sudo apt-get'
  alias cs='sudo apt-cache search'

  alias la='ls -al --color'
  alias less='less -R'

fi


# }}}
# OSX specific config {{{
if [ $(uname) = "Darwin" ]; then
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
