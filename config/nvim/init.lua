vim.cmd[[highlight SignColumn guibg=#272a3f]]
vim.opt.backupdir = '/tmp/nvim_temp//'
vim.opt.dir = '/tmp/nvim_swap//'
vim.opt.guicursor = 'n-v-c-i-:block'
vim.opt.smartcase = true
vim.opt.undodir = '/tmp/nvim_undo//'

vim.keymap.set('n', '<leader>r', function()
  dofile(vim.env.MYVIMRC)
  vim.notify('Reloaded ' .. vim.fn.fnamemodify(vim.fn.expand('$MYVIMRC'), ':t'))
end)

vim.diagnostic.config({
  virtual_lines = true
})

vim.cmd.source(vim.fn.stdpath("config") .. '/vimrc')

require('config.lazy')
