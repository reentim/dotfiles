return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'windwp/nvim-autopairs',
        opts = {
          fast_wrap = {},
          disable_filetype = { 'vim' },
        },
        config = function(_, opts)
          require('nvim-autopairs').setup(opts)
          local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
          require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
      },
      {
        "hrsh7th/cmp-nvim-lua",
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
      },
    },
    opts = function()
      local cmp = require('cmp')
      return {
        completion = {
          completeopt = "menu,menuone",
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
              return cmp.confirm({ select = true })
            else
              return cmp.complete()
            end
          end),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
        },
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'path' },
        },
      }
    end,
  },
}
