return {
  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
    config = function()
      local hooks = require "ibl.hooks"
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
      require('ibl').setup()
    end,
  },
}
