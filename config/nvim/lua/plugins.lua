return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 500,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'dcampos/nvim-snippy',
    config = function()
      require('snippy').setup({
        scopes = {
          typescriptreact = { '_', 'typescript', 'html' },
        }
      })
    end
  },
  {
    'Wansmer/treesj',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local treesj = require('treesj')
      treesj.setup({
        max_join_length = 999,
      })
      vim.keymap.set('n', 'gS', function()
        treesj.split({ split = { recursive = true } })
      end)
      vim.keymap.set('n', 'gJ', treesj.join)
    end,
  },
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', {})
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', {})
    end,
  },
  { 'RRethy/nvim-treesitter-endwise' },
  { 'michaeljsmith/vim-indent-object' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-rails' },
  { 'vim-ruby/vim-ruby' },
}
