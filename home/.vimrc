" vim-plug {{{
call plug#begin('~/.vim/plugged')

" look and feel
Plug 'chriskempson/base16-vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

Plug 'Raimondi/delimitMate'
Plug 'moll/vim-bbye'
Plug 'scrooloose/syntastic'
Plug 'editorconfig/editorconfig-vim'
Plug 'ciaranm/detectindent'

" languages
Plug 'pangloss/vim-javascript'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'elzr/vim-json'
Plug 'mustache/vim-mustache-handlebars'
Plug 'iamcco/markdown-preview.vim'
Plug 'ap/vim-css-color'
Plug 'flowtype/vim-flow'
Plug 'tmux-plugins/vim-tmux'

" tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-obsession'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()
" }}}

" Theming {{{
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
" }}}
"
" Settings {{{

" regular vim only {{{
if !has('nvim')
	set hlsearch
	set mouse=a
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
set listchars=tab:▸\ ,trail:·,eol:¬,extends:→,precedes:←,nbsp:･
set showbreak=↪\

" Set split pane direction to be more natural
set splitbelow
set splitright

" wildignore
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" find - look in nested folders
set path+=..
set wildmenu

" rg grep {{{
if executable('rg')
	set grepprg=rg\ --vimgrep
	" filename:line number:column number:message
	set grepformat=%f:%l:%c:%m
endif
"}}}

" :Find {{{
" Create a :Find command with ripgrep and fzf
" see https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.h8394n3c5

"" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
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

" Easier vim split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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
	call NERDTreeHighlightFile('java', '141', 'none', '#af87ff', '#151515')
augroup END
" }}}

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
	" eslintrc files could have json or yml suffix, or no suffix
	if HasConfig('.eslintrc*', expand('<amatch>:h'))
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
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_style_warning_symbol = '≈'

let g:syntastic_html_tidy_ignore_errors = ["proprietary attribute", "trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]
" remove html/tidy checker from handlebars files, see https://github.com/scrooloose/syntastic/issues/1904
let g:syntastic_filetype_map = { "html.handlebars": "handlebars"}

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
" obsession {{{
augroup vimobsession
	autocmd!
	autocmd VimEnter * nested
		\ if !argc() && empty(v:this_session) && !&modified |
		\   if filereadable('Session.vim') |
		\     source Session.vim |
		\   else |
		\     Obsession |
		\   endif |
		\ endif
augroup END
" }}}

" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1
" }}}

" vim-flow {{{
let g:flow#autoclose = 1
" }}}
"}}}
"
" add folding for vimscripts {{{
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
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

	" crontab
	autocmd filetype crontab setlocal nobackup nowritebackup
	autocmd BufReadPost * DetectIndent
augroup END

" local (gitignored) settings
if filereadable(expand('$HOME/.local.vim'))
	source $HOME/.local.vim
endif
" }}}

set secure
