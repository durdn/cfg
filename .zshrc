# .zshrc
# Author: Nicola Paolucci <nick@durdn.com>
# Source: http://github.com/durdn/cfg/.zshrc

# zsh/oh-my-zsh global setup {{{
ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="durdn"
DISABLE_AUTO_TITLE="true"
DISABLE_AUTO_UPDATE="true"
# COMPLETION_WAITING_DOTS="true"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# }}}
# Theme Prompt {{{
PROMPT='%{$fg[black]%}[%n]%{$reset_color%}[%{$fg_bold[blue]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%2~%{$reset_color%}]$(git_prompt_info)%{$reset_color%}
%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"

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
