if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim/

if dein#load_state('~/.vim/bundle/')
  call dein#begin('~/.vim/bundle/')
  call dein#add('~/.vim/bundle/repos/github.com/Shougo/dein.vim/')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('edkolev/promptline.vim')
  call dein#add('fatih/vim-go')
  call dein#end()
  call dein#save_state()
endif


let g:airline#extensions#virtualenv#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dark'
let g:promptline_theme = 'airline'
let g:promptline_preset = {
        \'a' : [ promptline#slices#host(), promptline#slices#user() ],
        \'b' : [ promptline#slices#cwd() ],
        \'x' : [ promptline#slices#vcs_branch(), promptline#slices#python_virtualenv() ],
        \'y' : [ '%*' ],
        \'warn' : [ promptline#slices#last_exit_code() ]}

color desert
filetype plugin indent on
syntax enable
set ai
set expandtab
set history=1000
set laststatus=2
set list
set listchars=eol:\^,tab:>\|
set number
set ruler
set si
set smartcase
set smarttab
set sw=4
set t_Co=256
set ts=4
set wrap
hi VertSplit cterm=NONE ctermfg=White ctermbg=NONE
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <C-t> :bp\|bd #<CR>
autocmd FileType python nnoremap <F9> :!clear;python %<CR>
