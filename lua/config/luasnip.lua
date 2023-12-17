local types = require('luasnip.util.types')
local ls = require('luasnip')
local config = require('config.utils').config_location

ls.config.setup({
  history = true,
  delete_check_events = 'TextChanged',
  updateevents = 'TextChanged, TextChangedI',
  region_check_events = 'CursorHold',
  enable_autosnippets = true,
  store_selection_keys = '<TAB>',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '●', 'DiffAdd' } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { '●', 'DiffDelete' } },
      },
    },
  },
  -- Use treesitter for getting the current filetype. This allows correctly resolving
  -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
  ft_func = require('luasnip.extras.filetype_functions').from_cursor,
})

-- Loading any vscode snippets from plugins
require('luasnip.loaders.from_vscode').lazy_load()

vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  require('luasnip').jump(-1)
end)
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  require('luasnip').jump(1)
end)
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-u>', function()
  require('luasnip.extras.select_choice')()
end)

-- A command to edit the snippet file
vim.api.nvim_create_user_command('LuaSnipEdit', function()
  require('luasnip.loaders.from_lua').edit_snippet_files()
end, { nargs = 0, desc = 'Edits current file snippets' })

require('luasnip.loaders.from_lua').lazy_load({
  paths = config .. '/lua/snippets',
})
