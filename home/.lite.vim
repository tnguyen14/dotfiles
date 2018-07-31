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

" see https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

" make eol, extends and precedes color gray
highlight NonText ctermfg=8 guifg=DarkGray
" make nbsp, tab and trail color gray
highlight SpecialKey ctermfg=8 guifg=DarkGray
" change ColorColumn color to dark gray
highlight ColorColumn ctermbg=235
" make vertical split less bright
highlight VertSplit cterm=NONE ctermbg=239 ctermfg=248
" highlight cursorline with light gray
highlight CursorLine cterm=NONE ctermbg=237
" LineNr - default color value was 130
highlight LineNr ctermfg=240
highlight CursorLineNr ctermfg=250
" StatusLine     xxx term=bold,reverse cterm=bold,reverse gui=bold,reverse
highlight StatusLine cterm=NONE ctermbg=238
" StatusLineNC   xxx term=reverse cterm=reverse gui=reverse
highlight StatusLineNC cterm=NONE ctermbg=235 ctermfg=248
" make Search less bright
highlight Search ctermbg=223 ctermfg=233

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
