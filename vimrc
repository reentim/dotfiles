set nocompatible

filetype plugin indent on
syntax on

set autoindent
set autoread
set backspace=indent,eol,start
set backup
set backupdir=/tmp/vimtemp//
set colorcolumn=80
set dir=/tmp/vimswap//
set encoding=utf-8
set expandtab
set fileencoding=utf-8
set foldmethod=indent
set foldminlines=0
set grepformat=%f:%l:%c:%m
set hidden
set history=10000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set listchars=tab:▸\ ,eol:↵,extends:>,precedes:<,trail:.,space:.
set modeline
set mouse=a
set noequalalways
set nofoldenable
set nowrap
set number
set relativenumber
set ruler
set shell=bash
set shiftwidth=2
set showcmd
set showmatch
set showmode
set showtabline=2
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set t_Co=256
set tabstop=4
set tags+=.git/tags
set ttimeout
set ttimeoutlen=10
set ttyfast
set ttymouse=sgr
set undodir=/tmp/vimundo//
set undofile
set wildmenu
set winheight=16
set winwidth=80

cnoreabbrev h Help
cnoremap %% <C-r>=expand('%:.:h').'/'<CR>
command! -nargs=? -complete=help Help help <args> | wincmd L | vert resize 80 | normal! 999zh
inoremap <C-J> ->
inoremap <C-L> =><space>
inoremap jk <ESC>
nnoremap / /\v
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <F5> :set invlist<CR>
nnoremap <silent> <CR> :nohl<CR>
nnoremap Y y$
vnoremap / /\v
