return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    config = true,
  },
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 500,
    config = function()
      -- vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 500,
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
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
  { 'AndrewRadev/splitjoin.vim' },
  { 'RRethy/nvim-treesitter-endwise' },
  { 'michaeljsmith/vim-indent-object' },
  { 'tommcdo/vim-lion' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'vim-ruby/vim-ruby' },
}
