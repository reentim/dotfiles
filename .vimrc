" Plugin related
" ------------------------------------------------------------------------------
	call pathogen#infect()
	call pathogen#helptags()
	filetype plugin indent on

" General
" ------------------------------------------------------------------------------
	set nocompatible
	set backspace=indent,eol,start
	set nu
	set encoding=utf-8
	set showcmd
	set showmode
	set wildmenu
	set wildmode=list:longest
	set ttyfast
	syntax on

" Whitespace
	set nowrap
	set tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
	set autoindent
	set smartindent

" Searching
" ------------------------------------------------------------------------------
	set hlsearch
	set incsearch
	set ignorecase
	set smartcase
	nnoremap <CR> :nohlsearch<cr>		" clear search highlighting on <CR>

	" Search for selected text, forwards or backwards. 
	" --------------------------------------------------------------------------
		vnoremap <silent> * :<C-U>
		   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
		   \gvy/<C-R><C-R>=substitute(
		   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
		   \gV:call setreg('"', old_reg, old_regtype)<CR>

	" Standardise regex handling
	" --------------------------
		nnoremap / /\v
		vnoremap / /\v

" Aesthetics
" ------------------------------------------------------------------------------
	set ruler
	colorscheme default

" Leader shortcuts
" ------------------------------------------------------------------------------
	let mapleader = ","

	" Reselect pasted text: <,v>
		nnoremap <leader>v V`]
	" Gundo
		nnoremap <leader>u :GundoToggle<CR>
	" Edit .vimrc in new vertical window
		nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
	" Edit .gvimrc in new vertical window
		nnoremap <leader>eg <C-w><C-v><C-l>:e $MYGVIMRC<cr>
	" Underline length of comment
		nmap <leader>l \\lyypv$r-\\k
	" 80 character comment underline
		nmap <leader>8 yypd$aa<ESC>\\lyypd$80a-<ESC>:norm 81\|<CR>d$khljd^\\lkddk

" Folding
" ------------------------------------------------------------------------------
	" Folding by indent level... not working out
	" ------------------------------------------
		" set foldmethod=indent
		" set foldnestmax=10
		" set nofoldenable
		" set foldlevel=1

	" Fold inner matching XML tag
		nnoremap <leader>ft Vatzf


" Windowing
" ------------------------------------------------------------------------------
	" switch to new split window
		nnoremap <leader>w <C-w>v<C-w>l
		nnoremap <leader>h :split<CR><C-w>j

	" moving around windows
		nnoremap <C-h> <C-w>h
		nnoremap <C-j> <C-w>j
		nnoremap <C-k> <C-w>k
		nnoremap <C-l> <C-w>l

" Central temporary directories
" ------------------------------------------------------------------------------
	set backup
	set backupdir=~/.vimtmp//
	set dir=~/.vimswap//
	set undofile
	set undodir=~/.vimundo//

" Macros
" ------------------------------------------------------------------------------

" General custom mappings
" ------------------------------------------------------------------------------
	nnoremap ; :
	inoremap jk <ESC>			" Also use jk to escape

" set clipboard=unnamed
" powerline
" gundo
