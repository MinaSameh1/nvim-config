local s = require('snippets.shorthands').s
local i = require('snippets.shorthands').i
local t = require('snippets.shorthands').t
local f = require('snippets.shorthands').f

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
