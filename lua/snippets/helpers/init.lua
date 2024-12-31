local Snip = {}
Snip.ls = require('luasnip')
Snip.r = require('luasnip.extras').rep
Snip.s = Snip.ls.snippet
Snip.sn = Snip.ls.snippet_node
Snip.t = Snip.ls.text_node
Snip.i = Snip.ls.insert_node
Snip.f = Snip.ls.function_node
Snip.c = Snip.ls.choice_node
Snip.d = Snip.ls.dynamic_node
Snip.r = Snip.ls.restore_node
Snip.parse = Snip.ls.parser.parse_snippet
Snip.sn = Snip.ls.snippet_node
Snip.l = require('luasnip.extras').lambda
Snip.rep = require('luasnip.extras').rep
Snip.p = require('luasnip.extras').partial
Snip.m = require('luasnip.extras').match
Snip.n = require('luasnip.extras').nonempty
Snip.dl = require('luasnip.extras').dynamic_lambda
Snip.fmt = require('luasnip.extras.fmt').fmt
Snip.fmta = require('luasnip.extras.fmt').fmta
Snip.types = require('luasnip.util.types')
Snip.conds = require('luasnip.extras.expand_conditions')
Snip.add_snippets = Snip.ls.add_snippets
Snip.postfix = require('luasnip.extras.postfix').postfix

function Snip.copy(args)
  return args[1]
end

---@diagnostic disable-next-line: unused-local
function Snip.get_visual(_args, parent, _) -- Third argument is the old state
  -- https://github.com/L3MON4D3/LuaSnip/issues/81#issuecomment-1235595467
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return Snip.sn(nil, Snip.i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return Snip.sn(nil, Snip.i(1))
  end
end

return Snip
