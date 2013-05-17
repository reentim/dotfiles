" General
" ------------------------------------------------------------------------------
  set nocompatible
  let mapleader = ","
  set backspace=indent,eol,start
  set nu
  set encoding=utf-8
  set showcmd
  set noshowmode
  set ttyfast
  syntax on
  set shell=bash

  " Jump to last cursor position unless it's invalid or in an event handler
  " -----------------------------------------------------------------------
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  " Auto-insert mode with spellchecking for git commit messages
    if has('autocmd')
      if has('spell')
        au BufNewFile,BufRead COMMIT_EDITMSG setlocal spell
      endif
      au BufNewFile,BufRead COMMIT_EDITMSG call feedkeys('ggi', 't')
      au BufNewFile,BufRead COMMIT_EDITMSG set nocursorline
    endif

" Aesthetics
" ------------------------------------------------------------------------------
  set t_Co=256
  set colorcolumn=80
  set ruler
  colorscheme Tomorrow-Night-Bright
  set listchars=tab:▸\ ,eol:↵
  set listchars+=trail:.
  set listchars+=extends:>
  set listchars+=precedes:<
  nmap <F5> :set invlist<cr>
  " set cursorline

" Plugin related
" ------------------------------------------------------------------------------
  " Pathogen
    call pathogen#infect()
    call pathogen#helptags()
    filetype plugin indent on

  " Powerline
    " always show the status line
    set laststatus=2

  " Syntastic
    let g:syntastic_mode_map = { 'mode': 'passive' }

  " indent html
    let g:html_indent_inctags = "html,body,head,tbody"
    let g:html_indent_script1 = "inc"
    let g:html_indent_style1 = "inc"

  " delimitmate
    let delimitMate_offByDefault = 0

  " " ctrl-p in working directory and below only
  "   let g:ctrlp_working_path_mode = ''

  " Indent Guides
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    " Tomorrow-Night-Eighties
      " hi IndentGuidesOdd  guibg=red   ctermbg=236
      " hi IndentGuidesEven guibg=green ctermbg=238
    " Tomorrow-Night-Bright
      hi IndentGuidesOdd  guibg=red   ctermbg=235
      hi IndentGuidesEven guibg=green ctermbg=237

  " Command-t
  " ---------
    set wildignore+=public/css
    let g:CommandTMaxFiles=99000
    map <leader>t  :wa\|:CommandTFlush<cr>\|:CommandT<cr>
    map <leader>gv      :CommandTFlush<cr>\|:CommandT app/views<cr>
    map <leader>gc      :CommandTFlush<cr>\|:CommandT app/controllers<cr>
    map <leader>gm      :CommandTFlush<cr>\|:CommandT app/models<cr>
    map <leader>gh      :CommandTFlush<cr>\|:CommandT app/helpers<cr>
    map <leader>gj      :CommandTFlush<cr>\|:CommandT app/assets/javascripts<cr>
    map <leader>gl      :CommandTFlush<cr>\|:CommandT lib<cr>
    map <leader>gp      :CommandTFlush<cr>\|:CommandT public<cr>
    " map <leader>gs      :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
    map <leader>gs      :CommandTFlush<cr>\|:CommandT app/assets/stylesheets<cr>
    map <leader>gf      :CommandTFlush<cr>\|:CommandT features<cr>

    " Ultisnips
    " ---------
    " let g:UltiSnipsExpandTrigger="<tab>"
    " let g:UltiSnipsJumpForwardTrigger="<tab>"
    " let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

    " You complete me
    " ---------------
      let g:ycm_key_list_select_completion = ['<C-T>']

" Whitespace
" ------------------------------------------------------------------------------
  set nowrap
  set expandtab tabstop=2 softtabstop=2 shiftwidth=2
  set autoindent
  set smartindent

  highlight TrailingWhitespace ctermbg=red guibg=red
  au BufEnter    * match TrailingWhitespace /\s\+$/
  au InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
  au InsertLeave * match TrailingWhitespace /\s\+$/
  au BufWinLeave * call clearmatches()

  " highlight ErrantIndentStyle ctermbg=red guibg=red
  " au BufEnter    * match ErrantIndentStyle /  /
  " au InsertEnter * match ErrantIndentStyle /  /
  " au InsertLeave * match ErrantIndentStyle /  /

  " File dependent indentation
  autocmd FileType html,php,c,sh
    \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

" Searching
" ------------------------------------------------------------------------------
  set hlsearch
  set incsearch
  set ignorecase
  set smartcase
  " clear search highlighting on <CR>
  nnoremap <CR> :nohlsearch<cr>

  " Search for selected text, forwards or backwards.
  " ------------------------------------------------
    vnoremap <silent> * :<C-U>
       \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
       \gvy/<C-R><C-R>=substitute(
       \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
       \gV:call setreg('"', old_reg, old_regtype)<CR>

  " Standardise regex handling
  " --------------------------
    nnoremap / /\v
    vnoremap / /\v

" Leader shortcuts
" ------------------------------------------------------------------------------
  " Paste mode
    nnoremap <leader>p :set invpaste<CR>

  " Run scripts
    autocmd FileType sh,bash    nnoremap <leader>r :!clear<cr>:w\|:!time bash %:p<cr>
    autocmd FileType rb,ruby    nnoremap <leader>r :!clear<cr>:w\|:!time ruby %:p<cr>
    autocmd FileType py,python  nnoremap <leader>r :!clear<cr>:w\|:!time python %:p<cr>

    autocmd FileType eruby      setlocal spell
  " Run tests / specs
    nnoremap <leader>z :wa<cr>:!clear<cr>:!time zeus rspec --color --tty  --format documentation %<cr>
    nnoremap <leader>c :wa<cr>:!clear<cr>:!time bundle exec rake cucumber:ok<cr>

  " load rb into irb session
    autocmd FileType rb,ruby    nnoremap <leader>a :!clear<cr>:w\|:!irb -r %:p<cr>

  " Reselect pasted text: <,v>
    nnoremap <leader>v V`]
  " Edit .vimrc in new vertical window
    nnoremap <leader>ev :e $MYVIMRC<cr>
  " Edit .gvimrc in new vertical window
    nnoremap <leader>eg :e $MYGVIMRC<cr>

  " Comment underlining: relies on vim-commentary plugin
  " ----------------------------------------------------
    function! UnderlineComment()
      " uncomment current line
      normal \\l
      " yank line, paste below
      normal yyp
      " visually select pasted line, replace all with '-'
      normal v$r-
      " comment out underline, re-comment original comment
      normal \\k
    endfunction
    nnoremap <leader>l :call UnderlineComment()<cr>

    " 80 character underline
    " ----------------------
      nmap <leader>8 yypd$aa<ESC>\\lyypd$81a-<ESC>:norm 81\|<CR>d$khljd^\\lkddk

" Folding
" ------------------------------------------------------------------------------
    set foldmethod=indent
    set nofoldenable

" Buffers and windows
" ------------------------------------------------------------------------------
  set hidden

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
  set backupdir=/tmp/vimtemp//
  set dir=/tmp/vimswap//
  set undofile
  set undodir=/tmp/vimundo//

" General custom mappings
" ------------------------------------------------------------------------------
  nnoremap ; :
  inoremap jk <ESC>
  nnoremap <leader><leader> <c-^>

  " Open files in directory of current file
  " ---------------------------------------
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>e :edit %%
    map <leader>v :view %%

  " hash rockets and arrows
    imap <c-l> =><space>
    imap <c-j> ->

