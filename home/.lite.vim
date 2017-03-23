
set nocompatible

filetype indent plugin on

syntax on

colorscheme base16-default-dark

set showmode
set showcmd
set ruler
set colorcolumn=80
highlight ColorColumn ctermbg=11

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

set list
set showbreak=\\
set listchars=tab:→\ ,trail:_,eol:¬,extends:>,precedes:<,nbsp:~

set splitbelow
set splitright

set path+=..
set wildmenu

set pastetoggle=<F11>

nnoremap ; :
vnoremap ; :

if filereadable(expand('$HOME/.local.vim'))
	source $HOME/.local.vim
endif

set secure
