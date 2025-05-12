" General
" ------------------------------------------------------------------------------
  set nocompatible
  let mapleader = ","
  set backspace=indent,eol,start
  set nonu
  set encoding=utf-8
  set showcmd
  set noshowmode
  set ttyfast
  set ttimeout
  set ttimeoutlen=10
  syntax on
  set shell=bash
  set showmatch
	autocmd BufLeave,FocusLost * silent! wall

  " Jump to last cursor position unless it's invalid or in an event handler
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

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

" Filetype dependent formatting
" ----------------------------------------------------------------------------
  autocmd FileType php,c,sh
    \ setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

" Spell-checking for eruby and git commit messages
  if has('spell')
    autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal spell
    autocmd FileType eruby                    setlocal spell
    autocmd BufNewFile,BufRead *.tpl.php      setlocal spell
  endif

" Plugins
" ------------------------------------------------------------------------------
  " Pathogen
    call pathogen#infect()
    call pathogen#helptags()
    filetype plugin indent on

  " Powerline
    set laststatus=2

  " Syntastic
    let g:syntastic_mode_map = { 'mode': 'passive' }

  " indent html
    " let g:html_indent_inctags = "html,body,head,tbody"
    " let g:html_indent_script1 = "inc"
    " let g:html_indent_style1 = "inc"

  " delimitmate
    let delimitMate_offByDefault = 0

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

    " Ctrl-P
      let g:ctrlp_max_height = 20
      let g:ctrlp_match_window_reversed = 0
      let g:ctrlp_working_path_mode = ''

    " Ultisnips
    " ---------
    let g:UltiSnipsExpandTrigger      = "<C-]>"
    let g:UltiSnipsJumpForwardTrigger = "<C-]>"
    let g:UltiSnipsSnippetsDir        = "~/.vim/bundle/snippets/UltiSnips"

    " Vitality
    " --------
    let g:vitality_fix_cursor = 0
    let g:vitality_always_assume_iterm = 1

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

  " Open directory
    nnoremap <leader>o :!open <C-R>=expand('%:h').'/'<cr><CR>

  " Run scripts
    autocmd FileType sh,bash    nnoremap <leader>r :w\|:!clear && time bash %:p<cr>
    autocmd FileType rb,ruby    nnoremap <leader>r :w\|:!clear && time ruby %:p<cr>
    autocmd FileType py,python  nnoremap <leader>r :w\|:!clear && time python %:p<cr>
    autocmd FileType javascript nnoremap <leader>r :w\|:!clear && time node %:p<cr>
    autocmd FileType c          nnoremap <leader>r :w\|:silent! !gcc %:p<cr>:!time ./a.out<cr>
    autocmd FileType vim        nnoremap <leader>r :w\|:source %:p<cr>


  " Run tests / specs
    nnoremap <leader>c :wa\|:!clear && time bundle exec rake cucumber:ok<cr>
    nnoremap <leader>f :wa\|:!clear && time bundle exec rspec --color --tty  --format documentation %<cr>
    nnoremap <leader>z :wa\|:!clear && time zeus rspec --color --tty  --format documentation %<cr>

  " load rb into irb session
    autocmd FileType rb,ruby    nnoremap <leader>a :!clear<cr>:w\|:!irb -r %:p<cr>

  " Reselect pasted text: <,v>
    nnoremap <leader>v V`]

  " Edit .vimrc in new vertical window
    nnoremap <leader>ev :e $MYVIMRC<cr>

  " Edit snippets
    nnoremap <leader>es :execute "e ~/.vim/bundle/snippets/UltiSnips/" . &filetype . ".snippets"<CR>

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
  " Make Y consistent with C and D.  See :help Y.
  nnoremap Y y$

  " Open files in directory of current file
  " ---------------------------------------
    cnoremap %% <C-R>=expand('%:p:h').'/'<cr>
    map <leader>e :edit %%
    map <leader>v :view %%

  " hash rockets and arrows
    imap <c-l> =><space>
    imap <c-j> ->

