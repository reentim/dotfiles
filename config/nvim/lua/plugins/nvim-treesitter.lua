return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = {
      'TSBufDisable',
      'TSBufEnable',
      'TSInstall',
      'TSInstallInfo',
      'TSModuleInfo',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'css',
        'html',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'printf',
        'ruby',
        'sql',
        'tmux',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = { enable = true },
      endwise = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
