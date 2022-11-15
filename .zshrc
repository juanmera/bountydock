#zmodload zsh/zprof
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit is-at-least
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=SAVEHIST=10000
setopt sharehistory
setopt extendedhistory
setopt autocd notify
unsetopt beep extended_glob
bindkey -v
# End of lines configured by zsh-newuser-install
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin
source ~/.zshprompt
source ~/.zshplugins

