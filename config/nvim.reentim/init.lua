vim.opt.smartcase = true

require('config.lazy')

vim.cmd.source('~/.vimrc.common')

vim.opt.guicursor = 'n-v-c-i-:block'
vim.opt.undodir = '/tmp/nvim_undo//'
vim.opt.dir = '/tmp/nvim_swap//'
vim.opt.backupdir = '/tmp/nvim_temp//'

vim.cmd[[highlight SignColumn guibg=#272a3f]]

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {"*.ts", "*.tsx"},
  callback = function()
    local bufname = vim.fn.expand('<afile>')
    if vim.fn.filereadable(bufname) == 0 then  -- If the file was just created
      vim.cmd("LspRestart")
    end
  end,
})
