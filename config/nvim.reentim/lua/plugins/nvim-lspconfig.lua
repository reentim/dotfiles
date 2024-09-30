return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = cmp_nvim_lsp.default_capabilities()
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        filetypes = {
          'javascript',
          'typescript',
        },
        settings = {
          typescript = {
            indentStyle = 'space',
            indentSize = 2,
          },
        },
        root_dir = lspconfig.util.root_pattern(
          '.git',
          'package.json',
          'tsconfig.json'
        ),
      })
    end,
  },
}
