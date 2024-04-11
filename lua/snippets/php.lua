local ls = require('snippets.helpers')

return {
  ls.s(
    { trig = 'echo', dscr = 'Echo' },
    ls.fmt([[echo "{}";]], {
      ls.i(1),
    }),
    { condition = ls.conds.line_begin }
  ),
}
