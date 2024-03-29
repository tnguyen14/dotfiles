" vim-plug {{{

" Automatically install vim-plug and run PlugInstall if vim-plug not found
" see https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" look and feel
Plug 'chriskempson/base16-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-vinegar'
if has('nvim')
	Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/defx.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

Plug 'Raimondi/delimitMate'
Plug 'moll/vim-bbye'
Plug 'w0rp/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/VimCompletesMe'
Plug 'mbbill/undotree'
" Plug 'terryma/vim-multiple-cursors'
Plug 'machakann/vim-highlightedyank'
Plug 'powerman/vim-plugin-AnsiEsc'

" languages
Plug 'sheerun/vim-polyglot'
Plug 'ap/vim-css-color'
" disabling vim-flow until https://github.com/flowtype/vim-flow/issues/49
" is resolved - currently it opens too many flow processes.
" Plug 'flowtype/vim-flow'

Plug 'tmux-plugins/vim-tmux'

" tpope
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-eunuch'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'github/copilot.vim'
call plug#end()
" }}}

let base16colorspace=256
colorscheme base16-default-dark

" Settings {{{

" regular vim only {{{
if !has('nvim')
	set hlsearch

	" Enable mouse mode working past 220th column
	" https://stackoverflow.com/questions/7000960/in-vim-why-doesnt-my-mouse-work-past-the-220th-column
	if has("mouse_sgr")
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	end
endif
" }}}
"
set mouse=a

" Allow saving of files as sudo when forgot to start vim using sudo
cnoremap w!! execute 'write !sudo tee % >/dev/null' <bar> edit!

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

set foldlevel=5
" rg grep {{{
if executable('rg')
	set grepprg=rg\ --vimgrep
	" filename:line number:column number:message
	set grepformat=%f:%l:%c:%m
endif

if has("persistent_undo")
	set undodir=/tmp
	set undofile
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
" horizontal split resize can still be achieved with <C-W>+, <C-W>-, <C-W> [n] +
if bufwinnr(1)
	nnoremap <Leader>+ <C-W>>
	nnoremap <Leader>- <C-W><
endif

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

"Reload buffer
nnoremap <Leader>e :e!<CR>
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
nnoremap <Leader>j :lnext<CR>
nnoremap <Leader>k :lprevious<CR>

" copy to/ from tmp file
vmap <Leader>y :w! /tmp/vim<CR>
nmap <Leader>p :r! cat /tmp/vim<CR>

" }}}

" Plugins Settings {{{
" vim-gitgutter {{{
let g:gitgutter_max_signs = 1000
" }}}

" airline {{{
let g:airline#extensions#tabline#enabled = 1
" show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" uniquify buffers names with similar filename, suppressing common parts of paths
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" integrate with ale
let g:airline#extensions#ale#enabled = 1
" disable showing a summary of changed hunks under source control
let g:airline#extensions#hunks#enabled = 0

" https://github.com/vim-airline/vim-airline/wiki/FAQ#how-can-i-remove-those-angle-at-the-end
let g:airline_skip_empty_sections = 1
" default is
" let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'spell', 'capslock', 'xkblayout', 'iminsert'])
" remove 'mode', as it's already indicated by vim
let g:airline_section_a = airline#section#create_left(['crypt', 'paste', 'spell', 'capslock', 'xkblayout', 'iminsert'])
" hide git branch/ hunks info (section b) to give section_c more space
" it would be great to add the git branch info on NERDTree status line
" https://github.com/vim-airline/vim-airline/issues/271#issuecomment-305244298
let g:airline_section_b = ''

" hide file encoding
" default is let g:airline_section_y = airline#section#create_right(['ffenc'])
let g:airline_section_y = ''
" default is
" let g:airline_section_z = airline#section#create(['windowswap', 'obsession', '%3p%%'.spc, 'linenr', 'maxlinenr', spc.':%3v'])
" https://github.com/vim-airline/vim-airline/blob/7813a5491223befd80f798c86802488613908b58/autoload/airline/init.vim
" removing the percentage
let g:airline_section_z = airline#section#create(['windowswap', 'obsession', 'linenr', 'maxlinenr', '%3v'])

function! AirlineUI()
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
endfunction
" call g:AirlineUI()
" }}}

" NERDTree{{{
let NERDTreeShowHidden = 1
" auto delete the buffer of the file you just deleted with NERDTree
let NERDTreeAutoDeleteBuffer = 1
" disable display of the 'Bookmarks' label and 'Press ? for help' text
let NERDTreeMinimalUI = 1
let NERDTreeMapOpenSplit = '<C-x>'
let NERDTreeMapOpenVSplit = '<C-v>'
let NERDTreeMapOpenInTab = '<C-t>'
let NERDTreeIgnore = ['\.pyc$', '\.DS_Store$', '\.swp$', '\.swo$']
" open NERDTree with `Ctrl-n`
nnoremap <Leader>n :NERDTreeToggle<CR>

" NERDTress File highlighting
" https://github.com/scrooloose/nerdtree/issues/433#issuecomment-92590696
" https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
	exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

augroup nerdtree
	autocmd!

	" open NERDTree automatically on vim start, even if no file is specified
	" focus back on main window after

	" autocmd StdinReadPre * let s:std_in=1
	" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree |
	" 	\ wincmd p | endif

	call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('properties', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('rc', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('ignore', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('yml', '177', 'none', '#d787ff', '#151515')
	call NERDTreeHighlightFile('yaml', '177', 'none', '#d787ff', '#151515')
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


" vim-json {{{
" Disable JSON quote concealing
let g:vim_json_syntax_conceal = 0
" }}}

" vim-markdown {{{
" Disable Markdown syntax concealing
" https://github.com/plasticboy/vim-markdown#syntax-concealing
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" }}}

" fzf {{{
" :Rg
" Create a :Rg command with ripgrep and fzf
" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration

"" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --color: Search color options
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow --glob "!.git/*" -- %s || true'
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* Gg
	\ call fzf#vim#grep(
	\	 'git grep --line-number --ignore-case --color=always '.shellescape(<q-args>), 0,
	\	 { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

command! -bang -nargs=? -complete=dir Files
	\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? GitFiles
	\ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

nnoremap <C-f> :Files<CR>
nnoremap <C-p> :GitFiles<CR>
" Open commits list
noremap <Leader>c :Commits<CR>
" Open buffers list
noremap <Leader>b :Buffers<CR>
" }}}

" obsession {{{
augroup vimobsession
	autocmd!
	autocmd VimEnter * nested
		\ if !argc() && empty(v:this_session) && !&modified |
		\	 if filereadable('Session.vim') |
		\		 source Session.vim |
		\	 else |
		\		 Obsession |
		\	 endif |
		\ endif
" }}}


" vim-flow {{{
" ale will take care of showing error
let g:flow#showquickfix = 0
" }}}

" vim-jsx {{{
" Enable JSX without requiring .jsx extension
let g:jsx_ext_required = 0
" }}}

" ale {{{
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 1000
" navigate to next/ previous error
nmap <silent> <C-j> <Plug>(ale_previous_wrap)
nmap <silent> <C-k> <Plug>(ale_next_wrap)

" :help ale_linters
let g:ale_linters = {
	\'python': ['pycodestyle', 'mypy', 'pylint'],
	\'json': ['jq', 'jsonlint', 'spectral'],
	\}
" remove eslint from json, as it requires eslint-json-plugin

let g:ale_fixers = {
	\'python': ['black'],
	\'javascript': ['prettier', 'eslint'],
	\'typescript': ['prettier', 'eslint'],
	\'typescriptreact': ['prettier', 'eslint'],
	\'ruby': ['rubocop'],
	\}

let g:ale_python_black_options = '-l 80'
" }}}

" vim-markdown-preview {{{
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<C-m>'
" }}}

" vim-multiple-cursors {{{
let g:multi_cursor_start_word_key = '<C-d>'
" }}}

"}}}

" add folding for different filetypes {{{
augroup folding
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
	autocmd FileType javascript setlocal foldmethod=syntax
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
		\	 set noswapfile |
		\ else |
		\	 set swapfile |
		\ endif

	" crontab
	autocmd filetype crontab setlocal nobackup nowritebackup
augroup END

set errorformat+=%f[%l\\,%c]:\ %m,%m

let g:netrw_fastbrowse=0
let g:netrw_liststyle=3

" defx {{{

"copied from :help defx-examples
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
	" Define mappings
	nnoremap <silent><buffer><expr> <CR>
	\ defx#do_action('open')
	nnoremap <silent><buffer><expr> c
	\ defx#do_action('copy')
	nnoremap <silent><buffer><expr> m
	\ defx#do_action('move')
	nnoremap <silent><buffer><expr> p
	\ defx#do_action('paste')
	nnoremap <silent><buffer><expr> l
	\ defx#do_action('open')
	nnoremap <silent><buffer><expr> E
	\ defx#do_action('open', 'vsplit')
	nnoremap <silent><buffer><expr> P
	\ defx#do_action('preview')
	nnoremap <silent><buffer><expr> o
	\ defx#do_action('open_tree', 'toggle')
	nnoremap <silent><buffer><expr> K
	\ defx#do_action('new_directory')
	nnoremap <silent><buffer><expr> N
	\ defx#do_action('new_file')
	nnoremap <silent><buffer><expr> M
	\ defx#do_action('new_multiple_files')
	nnoremap <silent><buffer><expr> C
	\ defx#do_action('toggle_columns',
	\								'mark:indent:icon:filename:type:size:time')
	nnoremap <silent><buffer><expr> S
	\ defx#do_action('toggle_sort', 'time')
	nnoremap <silent><buffer><expr> d
	\ defx#do_action('remove')
	nnoremap <silent><buffer><expr> r
	\ defx#do_action('rename')
	nnoremap <silent><buffer><expr> !
	\ defx#do_action('execute_command')
	nnoremap <silent><buffer><expr> x
	\ defx#do_action('execute_system')
	nnoremap <silent><buffer><expr> yy
	\ defx#do_action('yank_path')
	nnoremap <silent><buffer><expr> .
	\ defx#do_action('toggle_ignored_files')
	nnoremap <silent><buffer><expr> ;
	\ defx#do_action('repeat')
	nnoremap <silent><buffer><expr> h
	\ defx#do_action('cd', ['..'])
	nnoremap <silent><buffer><expr> ~
	\ defx#do_action('cd')
	nnoremap <silent><buffer><expr> q
	\ defx#do_action('quit')
	nnoremap <silent><buffer><expr> <Space>
	\ defx#do_action('toggle_select') . 'j'
	nnoremap <silent><buffer><expr> *
	\ defx#do_action('toggle_select_all')
	nnoremap <silent><buffer><expr> j
	\ line('.') == line('$') ? 'gg' : 'j'
	nnoremap <silent><buffer><expr> k
	\ line('.') == 1 ? 'G' : 'k'
	nnoremap <silent><buffer><expr> <C-l>
	\ defx#do_action('redraw')
	nnoremap <silent><buffer><expr> <C-g>
	\ defx#do_action('print')
	nnoremap <silent><buffer><expr> cd
	\ defx#do_action('change_vim_cwd')
endfunction

nnoremap <Leader>f :Defx<CR>
nnoremap <Leader>g :Defx -split=floating<CR>
" }}}

function! s:todo()
	lexpr system('cat TODO')
	lwindow
endfunction

command! Todo call s:todo()

" local (gitignored) settings
if filereadable(expand('$HOME/.local.vim'))
	source $HOME/.local.vim
endif
" }}}

set secure
