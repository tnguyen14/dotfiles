" Vundle {{{
" http://stackoverflow.com/questions/5845557/in-a-vimrc-is-set-nocompatible-completely-useless
set nocompatible

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
Plugin 'mxw/vim-jsx'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
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
Plugin 'moll/vim-bbye'
Plugin 'vim-scripts/gitignore'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'junegunn/gv.vim'
Plugin 'neovimhaskell/haskell-vim'
call vundle#end()
" }}}

" Theming {{{
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace"
colorscheme base16-tomorrow
" }}}
"
" Settings {{{
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

set scrolloff=5
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
set smarttab
set autoindent

" Show invisible characters
set list
set listchars=tab:▸\ ,trail:·,eol:¬,extends:→,nbsp:･

" Set split pane direction to be more natural
set splitbelow
set splitright
"}}}

" Mappings {{{
" remap <Leader> key
let mapleader = "\<Space>"

" shortcut to escape insert mode
inoremap jk <esc>

" Shift tab to insert tab when expandtab is on
inoremap <S-Tab> <C-V><Tab>

" inside parens
onoremap p i(

" Navigate panes with control
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" shortcut to edit and source .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" shortcut for going to begining and end of line
nnoremap H ^
nnoremap L $

" remap : to ; to avoid pressing Shift
nnoremap ; :
vnoremap ; :

" Buffer navigation
noremap <Leader>] :bnext<CR>
noremap <Leader>[ :bprev<CR>

" Save and quit buffer
noremap <Leader>s :write<CR>
noremap <Leader>q :quit<CR>

" bbye remap to <Leader>d
noremap <Leader>d :Bdelete<CR>

noremap <Leader>x :x<CR>

" vim-commentary
nnoremap <Leader>, :Commentary<CR>

" lnext and lprevious
nnoremap <Leader>l :lnext<CR>
nnoremap <Leader>L :lprevious<CR>
" }}}

" Plugins {{{
" vim-gitgutter stuff
let g:gitgutter_max_signs = 1000

" vim-jsx
let g:jsx_ext_required = 0

" vim multiple cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" airline {{{
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline#extensions#syntastic#enabled = 1

let g:airline_theme = 'base16'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
" }}}

" NERDTree {{{
let NERDTreeShowHidden = 1
let NERDTreeMapOpenSplit = '<C-x>'
let NERDTreeMapOpenVSplit = '<C-v>'
let NERDTreeMapOpenInTab = '<C-t>'
" open NERDTree automatically on vim start, even if no file is specified
augroup open_nerdtree
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
augroup END
" open NERDTree with `Ctrl-n`
noremap <C-n> :NERDTreeToggle<CR>
" }}}
"
" delimitMate
" auto expand carriage return <CR>
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

" Syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_html_tidy_ignore_errors = ["proprietary attribute", "trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]

let g:syntastic_javascript_checkers = ['standard']
let g:syntastic_javascript_standard_exec = 'happiness'
let g:syntastic_javascript_standard_generic = 1

function! HasConfig(file, dir)
    return findfile(a:file, escape(a:dir, ' ') . ';') !=# ''
endfunction

function! HasConfigJs()
	let checkers = []
	if HasConfig('.eslintrc', expand('<amatch>:h'))
		call add(checkers, 'eslint')
	endif
	if HasConfig('.jshintrc', expand('<amatch>:h'))
		call add(checkers, 'jshint')
	endif
	if HasConfig('.jscsrc', expand('<amatch>:h'))
		call add(checkers, 'jscs')
	endif
	" default to standard (happiness)
	if !len(checkers)
		call add(checkers, 'standard')
	endif
	return checkers
endfunction

augroup syntastic
	autocmd!
	autocmd BufNewFile,BufReadPre *.js let b:syntastic_checkers = HasConfigJs()
augroup END

" }}}

" make ESC key work for command-t
if &term =~ "xterm" || &term =~ "screen"
	let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif

" Disable JSON quote concealing
let g:vim_json_syntax_conceal = 0

" ctrlp
" show hidden files
let g:ctrlp_show_hidden = 1
" }}}

" add folding for vimscripts
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" Demandware
augroup demandware
	autocmd!
	autocmd BufNewFile,BufRead *.isml setfiletype xml
	autocmd BufNewFile,BufRead *.isml let g:syntastic_xml_xmllint_quiet_messages = { "regex": ['Extra content', 'Double hyphen', 'Opening and ending tag'] }
	autocmd BufNewFile,BufRead *.ds set filetype=javascript
augroup END

set secure
