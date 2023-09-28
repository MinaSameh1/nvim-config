local status_ok, neorg = pcall(require, 'neorg')
if not status_ok then
  print('Error in neorg config')
  return
end

local opts = { noremap = true, silent = true, expr = false }
local setDesc = require('config.utils').getDescWithMapOptsSetter(opts)

vim.api.nvim_set_keymap(
  'v',
  '<leader>N',
  '<cmd>Neorg<CR>',
  setDesc('Opens Neorg')
)

neorg.setup({
  load = {
    ['core.defaults'] = {},
    ['core.keybinds'] = {},
    ['core.neorgcmd'] = {},
    ['core.concealer'] = {},
    ['core.ui'] = {},
    ['core.ui.calendar'] = {},
    ['core.tempus'] = {},
    ['core.journal'] = {},
    ['core.esupports.indent'] = {},
    ['core.integrations.treesitter'] = {},
    ['core.looking-glass'] = {},
    ['core.qol.toc'] = {},
    ['core.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.export'] = {},
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
})
