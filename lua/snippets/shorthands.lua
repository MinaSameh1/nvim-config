local Snip = {}
Snip.ls = require('luasnip')
Snip.s = Snip.ls.snippet
Snip.t = Snip.ls.text_node
Snip.i = Snip.ls.insert_node
Snip.r = require('luasnip.extras').rep

return Snip
