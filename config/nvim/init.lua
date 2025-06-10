vim.cmd[[highlight SignColumn guibg=brightblack]]
vim.opt.backupdir = '/tmp/nvim_temp//'
vim.opt.dir = '/tmp/nvim_swap//'
vim.opt.guicursor = 'n-v-c-i-:block'
vim.opt.smartcase = true
vim.opt.undodir = '/tmp/nvim_undo//'

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', '<leader>r', function()
  dofile(vim.env.MYVIMRC)
  vim.notify('Reloaded ' .. vim.fn.fnamemodify(vim.fn.expand('$MYVIMRC'), ':t'))
end)

vim.diagnostic.config({
  virtual_lines = false
})

require('config.lazy')

vim.cmd.source(vim.fn.stdpath("config") .. '/vimrc')

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        local group = vim.fn.hlexists("HighlightedyankRegion") > 0
            and "HighlightedyankRegion"
            or "IncSearch"

        vim.highlight.on_yank {
            higroup = group,
            timeout = 200,
        }
    end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "css",
--   callback = function()
--     vim.opt_local.formatoptions:remove("r")
--     vim.opt_local.formatoptions:remove("o")
--   end,
-- })

local function jump_with_mark(key)
  return function()
    local count = vim.v.count
    if count > 1 then
      vim.cmd("normal! m'")
    end
    vim.cmd("normal! " .. count .. key)
  end
end

vim.keymap.set('n', 'j', jump_with_mark('j'), { expr = false, silent = true })
vim.keymap.set('n', 'k', jump_with_mark('k'), { expr = false, silent = true })

vim.diagnostic.config({
  virtual_text = true
})
