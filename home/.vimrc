set nocompatible

" Vundle
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-commentary'
Plugin 'wincent/command-t'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'pangloss/vim-javascript'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'Raimondi/delimitMate'
Plugin 'Yggdroot/indentLine'
Plugin 'othree/html5.vim'
call vundle#end()

set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace"
colorscheme base16-tomorrow
" Allow saving of files as sudo when forgot to start vim using sudo
cmap w!! w !sudo tee > /dev/null %
syntax on

" File type based indentation
filetype plugin indent on
" Show what mode you're currently in
set showmode
" Show what commands you're typing
set showcmd
" Allow modelines
set modeline
" Show current line and column position in file
set ruler
" Show file title in terminal tab
set title
" Show line numbers
set number
" Always display the status line
set laststatus=2
" Highlight current line
set cursorline
" Highlight search results as we type
set incsearch
" ignore case when searching...
set ignorecase
" ...except if we input a capital letter
set smartcase

" Tab stuff
set tabstop=4
set shiftwidth=4

" Show invisible characters
set list
set listchars=tab:→\ ,trail:·,eol:˧
" vim-gitgutter stuff
let g:gitgutter_max_signs = 1000

" Navigate panes with g
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
" Alias capitalized commands, because : requries Shift
command W w
command Q q

" Set split pane direction to be more natural
set splitbelow
set splitright

" Buffer navigation
map gb :bnext<CR>
map gB :bprev<CR>

" NERDTree
let NERDTreeShowHidden=1