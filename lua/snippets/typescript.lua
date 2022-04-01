local s = require('snippets.shorthands')

return {
  s.s(
    'func',
    s.fmt('{} {} ({}: {}): {} {{{}}}', {
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
    })
  ),
}
