return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'postgrestools',
          'biome',
        },
        -- TODO: how much would true slow things down?
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- ms
      })
    end,
  },
}
