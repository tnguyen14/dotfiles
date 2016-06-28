" vim-plug {{{
call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mustache/vim-mustache-handlebars'
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
Plug 'othree/html5.vim'
Plug 'wincent/terminus'
Plug 'scrooloose/syntastic'
Plug 'cakebaker/scss-syntax.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'ap/vim-css-color'
Plug 'ryanoasis/vim-devicons'
Plug 'elzr/vim-json'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-surround'
Plug 'moll/vim-bbye'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/gv.vim'
Plug 'lambdatoast/elm.vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'iamcco/markdown-preview.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ternjs/tern_for_vim'
Plug 'ajh17/VimCompletesMe'
Plug 'aklt/plantuml-syntax'
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
call plug#end()
" }}}

" Theming {{{
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace"
colorscheme base16-tomorrow
" }}}
"
" Settings {{{

" regular vim only {{{
if !has('nvim')
	set hlsearch
endif
" }}}
"
" Allow saving of files as sudo when forgot to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

syntax on

" Show what mode you're currently in
set showmode
" Show what commands you're typing
set showcmd
" Allow modelines
set modeline
" Show current line and column position in file
set ruler
" Highlight column at 80
set colorcolumn=80

set scrolloff=5
" Show file title in terminal tab
set title
" Show line numbers
set number
" Highlight current line
set cursorline
" ignore case when searching...
set ignorecase
" ...except if we input a capital letter
set smartcase

" hides buffer instead of closing them
" http://usevim.com/2012/10/19/vim101-set-hidden/
set hidden

" Tab stuff
set tabstop=4
set shiftwidth=4

" Show invisible characters
set list
set listchars=tab:▸\ ,trail:·,eol:¬,extends:→,nbsp:･

" Set split pane direction to be more natural
set splitbelow
set splitright

" wildignore
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" ag grep {{{
if executable('ag')
	set grepprg=ag\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif
"}}}

"}}}

" Mappings {{{
" remap <Leader> key
let mapleader = "\<Space>"

" shortcut to escape insert mode
inoremap jk <esc>

" Meta-tab to insert tab when expandtab is on
inoremap <M-Tab> <C-V><Tab>

" inside parens
onoremap p i(

" Faster vsplit resizing (+,-)
" split resize can still be achieved with <C-W>+, <C-W>-
if bufwinnr(1)
	nnoremap + <C-W>>
	nnoremap - <C-W><
endif

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

" Plugins Settings {{{
" vim-gitgutter {{{
let g:gitgutter_max_signs = 1000
" }}}

" vim-jsx {{{
let g:jsx_ext_required = 0
" }}}

" vim multiple cursor {{{
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
" }}}

" airline {{{
let g:airline#extensions#tabline#enabled = 1
" show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" uniquify buffers names with similar filename, suppressing common parts of paths
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" disable showing a summary of changed hunks under source control
let g:airline#extensions#hunks#enabled = 0
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
let NERDTreeIgnore = ['\.pyc$', '\.DS_Store$', '\.swp$', '\.swo$']
" open NERDTree with `Ctrl-n`
noremap <C-n> :NERDTreeToggle<CR>

" NERDTress File highlighting
" https://github.com/scrooloose/nerdtree/issues/433#issuecomment-92590696
" https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
	exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

augroup nerdtree
	autocmd!
	" open NERDTree automatically on vim start, even if no file is specified
	" focus back on main window after
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree |
		\ wincmd p | endif

	call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('properties', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('rc', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('ignore', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('yml', '177', 'none', '#d787ff', '#151515')
	call NERDTreeHighlightFile('md', '135', 'none', '#af5fff', '#151515')
	call NERDTreeHighlightFile('html', '202', 'none', '#ff5f00', '#151515')
	call NERDTreeHighlightFile('hbs', '203', 'none', '#ff5f5f', '#151515')
	call NERDTreeHighlightFile('css', '159', 'none', '#afffff', '#151515')
	call NERDTreeHighlightFile('js', '172', 'none', '#d78700', '#151515')
	call NERDTreeHighlightFile('php', '027', 'none', '#005fff', '#151515')
	call NERDTreeHighlightFile('log', '240', 'none', '#585858', '#151515')
	call NERDTreeHighlightFile('sh', '117', 'none', '#87d7ff', '#151515')
	call NERDTreeHighlightFile('xml', '158', 'none', '#afffd7', '#151515')
	call NERDTreeHighlightFile('java', '141', 'none', '$af87ff', '#151515')
augroup END
" }}}
"
" delimitMate {{{
" auto expand carriage return <CR>
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
" }}}

" Syntastic {{{
function! HasConfig(file, dir)
	return findfile(glob(a:file), escape(a:dir, ' ') . ';') !=# ''
endfunction

function! HasConfigJs()
	let checkers = []
	" eslintrc files could have json or yml suffix
	if HasConfig('.eslintrc.*', expand('<amatch>:h'))
		call add(checkers, 'eslint')
	endif
	if HasConfig('.jshintrc', expand('<amatch>:h'))
		call add(checkers, 'jshint')
	endif
	if HasConfig('.jscsrc', expand('<amatch>:h'))
		call add(checkers, 'jscs')
	endif
	" default to standard
	if !len(checkers)
		call add(checkers, 'standard')
	endif
	return checkers
endfunction

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_style_warning_symbol = '≈'

let g:syntastic_html_tidy_ignore_errors = ["proprietary attribute", "trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]

let g:syntastic_javascript_checkers = ['standard']
let g:syntastic_javascript_standard_exec = 'happiness'
let g:syntastic_javascript_standard_generic = 1
augroup syntasticjs
	autocmd!
	autocmd BufNewFile,BufReadPre *.js let b:syntastic_checkers = HasConfigJs()
augroup END
" }}}

" vim-json {{{
" Disable JSON quote concealing
let g:vim_json_syntax_conceal = 0
" }}}

" markdown-preview {{{
let g:mkdp_path_to_chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
" }}}

" VimCompletesMe {{{
augroup vimcompletesme
	autocmd!
	" auto close preview window after completion
	" https://github.com/ajh17/VimCompletesMe/issues/29
	autocmd InsertLeave * if bufname('%') != "[Command Line]" | pclose | endif
augroup END
" }}}

" fzf {{{
nnoremap <C-P> :GitFiles<CR>
nnoremap <C-O> :Files<CR>
" }}}

" vim-devicons {{{
if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif
" }}}
"
" emmet.vim {{{
augroup emmet
	autocmd!
	autocmd BufNewFile,BufRead *.html,*.hbs inoremap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
augroup END
" }}}
"
" obsession {{{
augroup vimobsession
	autocmd!
	autocmd VimEnter * nested
		\ if !argc() && empty(v:this_session) && !&modified|
		\   if filereadable('Session.vim') |
		\     source Session.vim |
		\   elseif |
		\     Obsession |
		\   endif |
		\ endif
augroup END
" }}}
"}}}
"
" add folding for vimscripts {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Demandware {{{
augroup demandware
	autocmd!
	autocmd BufNewFile,BufRead *.isml setfiletype xml
	autocmd BufNewFile,BufRead *.isml let g:syntastic_xml_xmllint_quiet_messages = { "regex": ['Extra content', 'Double hyphen', 'Opening and ending tag'] }
	autocmd BufNewFile,BufRead *.ds set filetype=javascript
augroup END
" }}}

" Misc {{{
augroup misc
	autocmd!
	" resize windows on terminal size change
	autocmd VimResized * wincmd =
	" don't create swap files for files in the Dropbox folder
	" taken from https://gist.github.com/frangio/985684
	autocmd BufNewFile,BufRead *
		\ if expand('%:~') =~ '^\~/Dropbox' |
		\   set noswapfile |
		\ else |
		\   set swapfile |
		\ endif
augroup END

" local (gitignored) settings
if filereadable(expand('$HOME/local.vim'))
	source $HOME/local.vim
endif
" }}}

set secure
