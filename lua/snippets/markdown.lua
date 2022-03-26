require('snippets.shorthands').setup_shorthands()

local snippets = {
  s(
    'spancol',
    fmt(
      [[
    <span style='color:{}'>{}</span>{}
  ]],
      {
        i(1, 'red'),
        i(2, 'text here'),
        i(0),
      }
    )
  ),

  -- Collapsible content
  s(
    'coll',
    fmt(
      [[
    <details>
    <summary><font size="{}" color="{}">{}</font></summary>
    {}
    </details>
    {}
    ]],
      {
        i(1, '2'),
        i(2, 'red'),
        i(3, 'Click to expand.'),
        i(4, 'Content goes here'),
        i(0),
      }
    )
  ),
}

return snippets
