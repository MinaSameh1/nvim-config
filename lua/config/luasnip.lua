local types = require('luasnip.util.types')
local ls = require('luasnip')
local p = require('luasnip.extras').partial
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

ls.snippets = {
  all = {
    ls.s('date', p(os.date, '%Y-%m-%d')),
  },
  lua = {
    ls.parser.parse_snippet('lf', 'local function ${1:name}(${2})\n  $0\nend'),
    ls.parser.parse_snippet('mf', 'function ${1:M}.${2:name}(${3})\n  $0\nend'),
  },
}
-- Loading any vscode snippets from plugins
require('luasnip.loaders.from_vscode').lazy_load()

-- Mappins to move around inside snippets
local smap = require('config.utils').imap
local imap = require('config.utils').smap

imap('<C-j>', '<CMD>lua require("luasnip").jump(1)<CR>')
smap('<C-j>', '<CMD>lua require("luasnip").jump(1)<CR>')
imap('<C-k>', '<CMD>lua require("luasnip").jump(-1)<CR>')
smap('<C-k>', '<CMD>lua require("luasnip").jump(-1)<CR>')

-- A command to edit the snippet file
vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]])
require("luasnip.loaders.from_lua").lazy_load({paths = config .. '/lua/snippets' })
