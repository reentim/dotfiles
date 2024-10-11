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
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            indentStyle = 'space',
            indentSize = 2,
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
        keys = {
          -- {
          --   "<leader>co",
          --   lspconfig.action["source.organizeImports"],
          --   desc = "Organize Imports",
          -- },
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
