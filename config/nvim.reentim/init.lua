require('config.lazy')

vim.cmd.source('~/.vimrc.common')

vim.opt.guicursor = 'n-v-c-i-:block'
vim.opt.undodir = '/tmp/nvim_undo//'
vim.opt.dir = '/tmp/nvim_swap//'
vim.opt.backupdir = '/tmp/nvim_temp//'

vim.keymap.set('n', '<Leader>b', '<Plug>(CommandTBuffer)')
vim.keymap.set('n', '<Leader>j', '<Plug>(CommandTJump)')
vim.keymap.set('n', '<Leader>t', '<Plug>(CommandTGit)')
vim.keymap.set('n', '<C-p>', '<Plug>(CommandT)')

vim.cmd[[highlight SignColumn guibg=#272a3f]]
