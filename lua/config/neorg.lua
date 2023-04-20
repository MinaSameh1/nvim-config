local status_ok, neorg = pcall(require, 'neorg')
if not status_ok then
  print('Error in neorg config')
  return
end

neorg.setup({
  load = {
    ['core.defaults'] = {},
    ['core.keybinds'] = {},
    ['core.neorgcmd'] = {},
    ['core.concealer'] = {},
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
    ['core.dirman'] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          notes = '~/Documents/notes',
          home = '~/Documents/stuff/notes',
          work = '~/Documents/stuff/work/notes',
        },
      },
    },
  },
})
