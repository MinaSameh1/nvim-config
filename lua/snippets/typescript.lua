local s = require('snippets.shorthands')

require('snippets.javascript') -- Load js snippets

return {
  s.s(
    'func',
    s.fmt(
      [[
    /**
      * {doc}
      *
      * @param {param}:{type}
      * @return {ret}
      */
    {} {} ({}: {}): {} {{{}}}
    ]],
      {
        s.c(1, {
          s.t('function'),
          s.t('async function'),
          s.t('export function'),
          s.t('export async function'),
        }),
        s.i(2, 'name'),
        s.i(3, 'param'),
        s.i(4, 'type'),
        s.i(5, 'return'),
        s.i(6, ''),
        param = s.f(s.copy, 3),
        ret = s.f(s.copy, 5),
        type = s.f(s.copy, 4),
        doc = s.f(s.copy, 2),
      }
    )
  ),
  s.s(
    'todo',
    s.fmt([[ // TODO: {date} {}]], {
      date = s.f(function()
        return os.date('%D - %H:%M')
      end),
      s.i(1),
    })
  ),
}
