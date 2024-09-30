return {
  {
    'wincent/command-t',
    lazy = false,
    build = function()
      local path = vim.fn.stdpath('data') .. "/lazy/command-t"
      os.execute("cd " .. path .. "&& make >/dev/null 2>&1")
    end,
    init = function()
      vim.g.CommandTPreferredImplementation = 'lua'
    end,
    config = function()
      require('wincent.commandt').setup({
        height = 20,
        position = 'bottom',
        smart_case = true,
        match_listing = {
          border = 'rounded'
        },
        prompt = {
          border = 'rounded'
        },
        scanners = {
          file = {
            max_files = 10000,
          },
          git = {
            max_files = 0,
            submodules = false,
            untracked = true,
          },
        },
      })
    end,
  },
}
