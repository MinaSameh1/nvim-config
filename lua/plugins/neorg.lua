

-- Map local leader to <Space>
vim.g.maplocalleader = ','

return {
  'nvim-neorg/neorg',
  cmd = 'Neorg',
  ft = 'norg',
  dependencies = { 'luarocks.nvim' },
  keys = {
    {
      '<leader>N',
  '<cmd>Neorg<CR>',
      mode = 'n',
      noremap = true,
      silent = true,
      desc = 'Open Neorg',
    },
  },
  opts = {
    load = {
      ['core.defaults'] = {},
      ['core.keybinds'] = {},
      ['core.neorgcmd'] = {},
      ['core.concealer'] = {},
      ['core.pivot'] = {},
      ['core.itero'] = {},
      ['core.promo'] = {},
      ['core.fs'] = {},
      ['core.ui'] = {},
      ['core.ui.calendar'] = {},
      ['core.tempus'] = {},
      ['core.journal'] = {},
      ['core.esupports.indent'] = {},
      ['core.integrations.treesitter'] = {},
      ['core.looking-glass'] = {},
      ['core.qol.toc'] = {},
      ['core.summary'] = {},
      ['core.completion'] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ['core.export'] = {},
      -- ['core.export.markdown'] = {},
      ['core.dirman'] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            notes = '~/Stuff/notes/notes',
            home = '~/Stuff/notes',
            work = '~/Stuff/notes/work',
          },
          default_workspace = 'notes',
        },
      },
    },
  },
}
