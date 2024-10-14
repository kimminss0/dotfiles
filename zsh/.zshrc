# History
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS

# Completion
zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

bindkey -e

# Prompt
cUSR="%F{cyan}%B"
cPWD="%F{magenta}%B"
cSTD="%b%f"
PROMPT="%m ${cUSR}%n${cSTD} ${cPWD}%~${cSTD}
%# "
unset cUSR cPWD cSTD

