-- https://github.com/ejmastnak/dotfiles/blob/main/config/nvim/LuaSnip/python/python.lua
local ls = require('snippets.helpers')

return {
  -- PRINT STATEMENT
  ls.s(
    { trig = 'pp', snippetType = 'autosnippet' },
    ls.fmta([[print(<>)]], {
      ls.d(1, ls.get_visual),
    }),
    { condition = ls.conds.line_begin }
  ),
  -- TIME, i.e. snippet for timing code execution
  ls.s(
    { trig = 'time', dscr = 'Time code execution' },
    ls.fmta(
      [[
        start = time.time()
        <>
        end = time.time()
      ]],
      {
        ls.d(1, ls.get_visual),
      }
    )
  ),
  ls.s(
    { trig = 'iff', snippetType = 'autosnippet' },
    ls.fmta(
      [[
        if <>:
            <>
      ]],
      {
        ls.i(1),
        ls.d(2, ls.get_visual),
      }
    ),
    { condition = ls.line_begin }
  ),
}
