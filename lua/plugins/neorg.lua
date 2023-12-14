local opts = { noremap = true, silent = true, expr = false }
local setDesc = require('config.utils').getDescWithMapOptsSetter(opts)

vim.api.nvim_set_keymap(
  'n',
  '<leader>N',
  '<cmd>Neorg<CR>',
  setDesc('Opens Neorg')
)

return {
  'nvim-neorg/neorg',
  build = ':Neorg sync-parsers',
  cmd = 'Neorg',
  ft = 'norg',
  opts = {
    load = {
      ['core.defaults'] = {},
      ['core.keybinds'] = {},
      ['core.neorgcmd'] = {},
      ['core.concealer'] = {},
      ['core.upgrade'] = {},
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
            notes = '~/Documents/stuff/notes/notes',
            home = '~/Documents/stuff/notes',
            work = '~/Documents/stuff/notes/work',
          },
          default_workspace = 'notes',
        },
      },
    },
  },
}
