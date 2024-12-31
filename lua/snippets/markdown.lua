local s = require('snippets.helpers')

local date = function()
  return os.date('%D - %H:%M')
end

return {
  s.s({
    trig = 'meta',
    namr = 'Metadata',
    dscr = 'Yaml metadata format for markdown',
  }, {
    s.t({ '---', 'title: ' }),
    s.i(1, 'note_title'),
    s.t({ '', 'author: ' }),
    s.i(2, 'author'),
    s.t({ '', 'date: ' }),
    s.f(date, {}),
    s.t({ '', 'categories: [' }),
    s.i(3, ''),
    s.t({ ']', 'lastmod: ' }),
    s.f(date, {}),
    s.t({ '', 'tags: [' }),
    s.i(4),
    s.t({ ']', 'comments: true', '---', '' }),
    s.i(0),
  }),

  s.s({ trig = 'table(%d+)x(%d+)', regTrig = true }, {
    ---@diagnostic disable-next-line: unused-local
    s.d(1, function(_args, snip)
      local nodes = {}
      local i_counter = 0
      local hlines = ''
      for _ = 1, snip.captures[2] do
        i_counter = i_counter + 1
        table.insert(nodes, s.t('| '))
        table.insert(nodes, s.i(i_counter, 'Column' .. i_counter))
        table.insert(nodes, s.t(' '))
        hlines = hlines .. '|---'
      end
      table.insert(nodes, s.t({ '|', '' }))
      hlines = hlines .. '|'
      table.insert(nodes, s.t({ hlines, '' }))
      for _ = 1, snip.captures[1] do
        for _ = 1, snip.captures[2] do
          i_counter = i_counter + 1
          table.insert(nodes, s.t('| '))
          table.insert(nodes, s.i(i_counter))
          print(i_counter)
          table.insert(nodes, s.t(' '))
        end
        table.insert(nodes, s.t({ '|', '' }))
      end
      return s.sn(nil, nodes)
    end),
  }),
}
