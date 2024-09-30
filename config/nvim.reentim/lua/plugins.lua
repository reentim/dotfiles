return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    config = true,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 500,
    opts = {},
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
}
