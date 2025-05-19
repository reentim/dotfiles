return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = function()
      require("telescope").setup({
        defaults = {
          preview = false,
        },
      })
      vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>')
    end,
}
