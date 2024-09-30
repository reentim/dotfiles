return {
  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
    opts = {
      indent = { char = '│' },
      scope = { char = '│' },
    },
    config = function(_, opts)
      require('ibl').setup(opts)
    end,
  },
}
