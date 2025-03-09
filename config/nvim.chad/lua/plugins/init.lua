return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
      -- require("lspconfig").ts_ls.setup({})
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc", "html", "css"
      },
    },
  },

  {
    "wincent/command-t",
    lazy = false,
    build = function()
      local path = vim.fn.stdpath('data') .. "/lazy/command-t"
      os.execute("cd " .. path .. "&& make >/dev/null 2>&1")
    end,
    init = function()
      vim.g.CommandTPreferredImplementation = 'lua'
    end,
    config = function()
      require("wincent.commandt").setup({
        height = 20,
        position = "bottom",
      })
    end,
  },

  {
    "alexghergh/nvim-tmux-navigation",
    lazy = false,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = {
      mapping = {
        -- this is what I want, but it isn't working:
        -- ["<C-p>"] = require("cmp").mapping.confirm({ select = true }),
        -- ["<C-j>"] = require("cmp").mapping.select_next_item(),
        -- ["<C-k>"] = require("cmp").mapping.select_prev_item(),
      },
    },
  },
}
