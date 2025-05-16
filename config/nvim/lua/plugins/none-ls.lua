return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require('null-ls')

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.biome,
          -- null_ls.builtins.diagnostics.biome,
        },
      })
    end,
  },
}
