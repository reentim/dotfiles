vim.opt.backupdir = '/tmp/nvim_temp//'
vim.opt.dir = '/tmp/nvim_swap//'
vim.cmd[[highlight SignColumn guibg=#272a3f]]
vim.opt.guicursor = 'n-v-c-i-:block'
vim.opt.smartcase = true
vim.opt.undodir = '/tmp/nvim_undo//'

vim.diagnostic.config({
  virtual_lines = true
})

vim.cmd.source(vim.fn.stdpath("config") .. '/vimrc')

require('config.lazy')
