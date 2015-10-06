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
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'pangloss/vim-javascript'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'Raimondi/delimitMate'
Plugin 'Yggdroot/indentLine'
Plugin 'othree/html5.vim'
Plugin 'wincent/terminus'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rking/ag.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'ap/vim-css-color'
Plugin 'ryanoasis/vim-devicons'
Plugin 'elzr/vim-json'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tpope/vim-surround'
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

" hides buffer instead of closing them
" http://usevim.com/2012/10/19/vim101-set-hidden/
set hidden

set encoding=utf-8

" When a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again.
" When the file has been deleted this is not done.
set autoread

" Tab stuff
set tabstop=4
set shiftwidth=4
set autoindent

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

" remap : to ; to avoid pressing Shift
nnoremap ; :
vnoremap ; :

" Set split pane direction to be more natural
set splitbelow
set splitright

" Buffer navigation
map gb :bnext<CR>
map gB :bprev<CR>

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMapOpenSplit = '<C-x>'
let NERDTreeMapOpenVSplit = '<C-v>'
let NERDTreeMapOpenInTab = '<C-t>'
" open NERDTree automatically on vim start, even if no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open NERDTree with `Ctrl-n`
map <C-n> :NERDTreeToggle<CR>

" Syntastic recommended settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]

" remap <Leader> key
let mapleader = ','

" make ESC key work for command-t
if &term =~ "xterm" || &term =~ "screen"
	let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif

" Disable JSON quote concealing
let g:vim_json_syntax_conceal = 0

" ctrlp
" show hidden files
let g:ctrlp_show_hidden = 1

" ycm
" <Enter>
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']

