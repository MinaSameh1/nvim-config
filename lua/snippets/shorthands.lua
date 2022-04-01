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
Snip.parse_snippet = Snip.ls.parser.parse_snippet
Snip.add_snippets = Snip.ls.add_snippets
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

function Snip.copy(args)
  return args[1]
end
return Snip
