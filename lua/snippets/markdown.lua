local s = require('snippets.helpers').s
local i = require('snippets.helpers').i
local t = require('snippets.helpers').t
local f = require('snippets.helpers').f

local date = function()
  return os.date('%D - %H:%M')
end

s({
  trig = 'meta',
  namr = 'Metadata',
  dscr = 'Yaml metadata format for markdown',
}, {
  t({ '---', 'title: ' }),
  i(1, 'note_title'),
  t({ '', 'author: ' }),
  i(2, 'author'),
  t({ '', 'date: ' }),
  f(date, {}),
  t({ '', 'categories: [' }),
  i(3, ''),
  t({ ']', 'lastmod: ' }),
  f(date, {}),
  t({ '', 'tags: [' }),
  i(4),
  t({ ']', 'comments: true', '---', '' }),
  i(0),
})
