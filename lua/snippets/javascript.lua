local s = require('snippets.shorthands')
local l = require('luasnip.extras').l

return {
  s.s(
    'todo',
    s.fmt([[ // TODO: {date} {}]], {
      date = s.f(function()
        return os.date('%D - %H:%M')
      end),
      s.i(1),
    })
  ),
  --- Create express controller
  s.s(
    {
      trig = 'expcont',
      dscr = 'Express Controller with choice for controller shape',
    },
    s.fmt(
      [[
  /**
   * @function {}
   * @description {}
   * @param {{Request}} req Express Request
   * @param {{Response}} res Express Response
   * @param {{NextFunction}} next Express Next Function
   */
  export {} {{
    try {{
      {}
    }} catch (err) {{
      next(err);
    }}
  }}
  ]],
      {
        s.i(1),
        s.i(2),
        s.c(3, {
          s.fmt('const {name} = (req, res, next) =>', {
            name = s.i(1, 'name'),
          }),
          s.fmt('const {name} = async (req, res, next) =>', {
            name = s.i(1, 'name'),
          }),
          s.fmt('export function {name}(req, res, next)', {
            name = s.i(1, 'name'),
          }),
          s.fmt('export async function {name}(req, res, next)', {
            name = s.i(1, 'name'),
          }),
        }),
        s.i(4),
      }
    )
  ),
  -- Create express controller snippet
  s.s(
    { trig = 'exprouter', dscr = 'Express Router' },
    s.fmt(
      [[
  import {{ Router }} from "express";

  const {name}Router = Router();

  {name}Router.get("/", {controller});

  export default {}Router;
  ]],
      {
        s.i(1),
        name = s.f(s.copy, 1),
        controller = s.i(2, 'controller'),
      }
    )
  ),
  {
    trig = 'jtest', -- Trigger word to expand the snippet
    name = 'jest_test', -- Optional name for the snippet
    dscr = 'Create a Jest test case', -- Description

    -- Snippet body
    s.t(
      "test('${1:test description}', () => {\n",
      '\t${2: // Test code here}\n',
      '});'
    ),
  },
}
