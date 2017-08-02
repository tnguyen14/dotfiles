
set nocompatible

filetype indent plugin on

syntax on

set showmode
set showcmd
set ruler
set colorcolumn=80

set title

set hlsearch
set backspace=indent,eol,start

set autoindent

set mouse=a
set number

set cursorline

set ignorecase
set smartcase

set hidden

set tabstop=4
set shiftwidth=4

set list
set showbreak=\\
set listchars=tab:>\ ,trail:_,extends:>,precedes:<,nbsp:~
" make eol, extends and precedes color gray
highlight NonText ctermfg=8 guifg=DarkGray
" make nbsp, tab and trail color gray
highlight SpecialKey ctermfg=8 guifg=DarkGray

set splitbelow
set splitright

set path+=..
set wildmenu

set pastetoggle=<F11>

" always show statusline
set laststatus=2
" show filename in statusline
set statusline=%F


nnoremap ; :
vnoremap ; :

let g:vimlite = 1

if filereadable(expand('$HOME/.local.vim'))
	source $HOME/.local.vim
endif

set secure
