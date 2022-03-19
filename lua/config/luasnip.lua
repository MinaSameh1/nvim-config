local types = require('luasnip.util.types')
local ls = require('luasnip')
local p = require('luasnip.extras').partial

ls.config.setup({
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
imap('<C-k>', '<CMD>lua require("luasnip").jump(-1)<CR>')
smap('<C-j>', '<CMD>lua require("luasnip").jump(1)<CR>')
smap('<C-k>', '<CMD>lua require("luasnip").jump(-1)<CR>')
