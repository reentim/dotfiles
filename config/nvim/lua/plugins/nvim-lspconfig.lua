return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = function()
          require('mason').setup()
        end,
      },
      {
        'williamboman/mason-lspconfig.nvim',
        config = function()
          require('mason-lspconfig').setup {
            ensure_installed = {
              'biome',
              'cssls',
              'lua_ls',
              'ruby_lsp',
              'tailwindcss',
              'ts_ls',
            },
            automatic_installation = true,
          }
        end,
      },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = cmp_nvim_lsp.default_capabilities()

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = {"*.ts", "*.tsx"},
        callback = function()
          local bufname = vim.fn.expand('<afile>')
          -- the file was just created
          if vim.fn.filereadable(bufname) == 0 then
            vim.cmd("LspRestart")
            vim.cmd[[echom "hello"]]
          end
        end,
      })

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },  -- Let the LSP know "vim" is a global
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                -- Optional: add your config directory for more context-aware linting
                "${3rd}/luv/library", -- for async lib support
              },
              checkThirdParty = false, -- Avoid prompts about 'luassert' etc.
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        filetypes = {
          'javascript',
          'typescript',
          'typescriptreact',
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
        root_dir = lspconfig.util.root_pattern(
          '.git',
          'package.json',
          'tsconfig.json'
        ),
      })

      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        filetypes = {
          'ruby',
        }
      })

      lspconfig.biome.setup({})
    end,
  },
}
