# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit is-at-least
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd nomatch notify
unsetopt beep extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
source ~/.zshprompt
source ~/.zshplugins

alias vim=nvim
export EDITOR=nvim
export VISUAL=nvim
export PAGER=nvimpager
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$GOPATH/bin
