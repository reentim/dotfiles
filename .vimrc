" Plugin related
" ------------------------------------------------------------------------------
  call pathogen#infect()
  call pathogen#helptags()
  filetype plugin indent on

  " Command-T ignore files
    set wildignore+=*.pdf,*.png,*.jpg,*.jpeg

  " Powerline
  set laststatus=2 
  set t_Co=256

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
  set expandtab tabstop=2 softtabstop=2 shiftwidth=2
  set autoindent
  set smartindent

  " File dependent indentation
  autocmd FileType html setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  " Jump to last cursor position unless it's invalid or in an event handler
  " c/o G.B.
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Searching
" ------------------------------------------------------------------------------
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase
  nnoremap <CR> :nohlsearch<cr> " clear search highlighting on <CR>

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
  colorscheme ron
  set listchars=tab:▸\ ,eol:↵
  nmap <F5> :set invlist<cr> 

" Leader shortcuts
" ------------------------------------------------------------------------------
  let mapleader = ","

    nnoremap <C-R>p :CtrlPCurWD<CR>
  " Reselect pasted text: <,v>
    nnoremap <leader>v V`]
  " Edit .vimrc in new vertical window
    nnoremap <leader>ev :e $MYVIMRC<cr>
  " Edit .gvimrc in new vertical window
    nnoremap <leader>eg :e $MYGVIMRC<cr>
  " Underline length of comment
    nmap <leader>l \\lyypv$r-\\k
  " 80 character comment underline
    nmap <leader>8 yypd$aa<ESC>\\lyypd$80a-<ESC>:norm 81\|<CR>d$khljd^\\lkddk

" Folding
" ------------------------------------------------------------------------------
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
  inoremap jk <ESC>      " Also use jk to escape

  " set clipboard=unnamed
