local s = require('snippets.helpers')

return {
  s.s({
    trig = 'sout',
    dsrc = 'System.out.println',
  }, s.t('System.out.println("'), s.i(1), s.t('");')),
  s.s(
    { trig = 'time', dscr = 'Time code execution' },
    s.fmta(
      [[
long startTime = System.currentTimeMillis();
<>
long endTime = System.currentTimeMillis();
System.out.println("Execution time of <>: " + (endTime - startTime) + "ms");
      ]],
      {
        s.d(1, s.get_visual),
        s.i(2, 'name'),
      }
    )
  ),
}
