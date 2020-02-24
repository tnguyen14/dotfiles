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
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

Plug 'Raimondi/delimitMate'
Plug 'moll/vim-bbye'
Plug 'w0rp/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'ajh17/VimCompletesMe'
Plug 'mbbill/undotree'
" Plug 'terryma/vim-multiple-cursors'

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
	nnoremap + <C-W>>
	nnoremap - <C-W><
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
nnoremap <Leader>l :lnext<CR>
nnoremap <Leader>L :lprevious<CR>
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
command! -bang -nargs=* Rg
	\ call fzf#vim#grep(
	\   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color=always '.shellescape(<q-args>), 1,
	\   <bang>0 ? fzf#vim#with_preview('up:60%')
	\           : fzf#vim#with_preview('right:50%:hidden', '?'),
	\   <bang>0)

command! -bang -nargs=* Gg
	\ call fzf#vim#grep(
	\   'git grep --line-number --ignore-case '.shellescape(<q-args>), 0,
	\   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

command! -bang -nargs=? -complete=dir Files
	\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? GitFiles
	\ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

nnoremap <C-p> :Files<CR>
nnoremap <Leader>p :GitFiles<CR>
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
		\   if filereadable('Session.vim') |
		\     source Session.vim |
		\   else |
		\     Obsession |
		\   endif |
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
" navigate to next/ previous error
nmap <silent> <C-j> <Plug>(ale_previous_wrap)
nmap <silent> <C-k> <Plug>(ale_next_wrap)

" :help ale_linters
let g:ale_linters = {
			\'python': ['pycodestyle']
			\}

let g:ale_fixers = {
			\'python': ['black'],
			\'javascript': ['prettier']
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
		\   set noswapfile |
		\ else |
		\   set swapfile |
		\ endif

	" crontab
	autocmd filetype crontab setlocal nobackup nowritebackup
augroup END

set errorformat+=%f[%l\\,%c]:\ %m,%m

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
