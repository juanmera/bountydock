#!/bin/bash
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
antibody bundle < ~/.zshplugins.txt > ~/.zshplugins

mkdir -p ~/.vim/bundle
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ~/.vim/installer_dein.sh
sh ~/.vim/installer_dein.sh ~/.vim/bundle
