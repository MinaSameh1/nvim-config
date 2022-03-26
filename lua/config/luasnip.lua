local types = require('luasnip.util.types')
local ls = require('luasnip')
local p = require('luasnip.extras').partial

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

-- Split up snippets by filetype, load on demand and reload after change
-- Snippets for each filetype are saved as modules in ~/.config/nvim/lua/snippets/<filetype>.lua

-- Ref: https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs#split-up-snippets-by-filetype-load-on-demand-and-reload-after-change-first-iteration
function _G.snippets_load_files()
  for m, _ in pairs(ls.snippets) do
    package.loaded['snippets.' .. m] = nil
  end
  ls.snippets = setmetatable({}, {
    __index = function(t, k)
      local ok, m = pcall(require, 'snippets.' .. k)
      if not ok and not string.match(m, '^module.*not found:') then
        error(m)
      end
      t[k] = ok and m or {}

      -- optionally load snippets from vscode- or snipmate-library:
      -- require("luasnip.loaders.from_vscode").load({include={k}})
      -- require("luasnip.loaders.from_snipmate").load({include={k}})

      return t[k]
    end,
  })
end

_G.snippets_load_files()
-- Reload after change
vim.cmd([[
  augroup snippets_clear
  " autocmd!
  autocmd BufWritePost ~/.config/nvim/lua/snippets/*.lua lua _G.snippets_load_files()
  augroup END
]])

function _G.edit_ft()
  -- returns table like {"lua", "all"}
  local fts = require('luasnip.util.util').get_snippet_filetypes()
  vim.ui.select(fts, {
    prompt = 'Select which filetype to edit:',
  }, function(item, idx)
    -- selection aborted -> idx == nil
    if idx then
      vim.cmd(
        'edit '
          .. vim.fn.stdpath('config')
          .. '/lua/snippets/'
          .. item
          .. '.lua'
      )
    end
  end)
end

-- A command to edit the snippet file
vim.cmd([[command! LuaSnipEdit :lua _G.edit_ft()]])
