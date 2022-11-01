local s = require('snippets.shorthands')

return {
  s.s(
    'guard',
    s.fmt(
      [[
      local status_ok, {} = pcall(require,'{}')
      if not status_ok then
        print('Error in {name} config')
        return
      end
      {}
      ]],
      {
        s.i(1),
        s.i(2),
        s.i(3),
        name = s.f(s.copy, 1),
      }
    )
  ),
}
