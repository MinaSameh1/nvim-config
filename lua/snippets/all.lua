local s = require('snippets.helpers')

return {
  s.s('date', s.p(os.date, '%Y-%m-%d')),
  s.s('datetime', s.p(os.date, '%Y-%m-%d %H:%M:%S')),
  s.parse('luasnip', 'loaded!!'),
  s.parse(
    { trig = 'ternary', wordTrig = false },
    '${1:cond} ? ${2:true} : ${3:false}'
  ),
}
