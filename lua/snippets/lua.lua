local s = require('snippets.helpers')
local get_node_text = require('config.utils').get_node_text

-- See https://github.com/t-troebst/config.nvim/blob/master/lua/user/snippets/lua.lua

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
if not ts_utils_ok then
  return {}
end

local function_q = vim.treesitter.query.parse(
  'lua',
  [[
    [
        (function_declaration parameters: (parameters) @parms)
        (function_definition parameters: (parameters) @parms)
    ] @fun
]]
)
-- This only matches returns that actually return something, so early return can still be used for
-- control flow!
local return_q =
  vim.treesitter.query.parse('lua', '(return_statement (expression_list)) @ret')

--- Obtains list of parameter names for the next lua function and whether it returns something.
-- @param linenr Line number at which we start searching.
-- @return parms, ret where parms is a list of parameters, in the order that they appear in the
--         function and ret is truthy if the function ever returns something.
local function next_fun_parms(linenr)
  local bufnr = vim.api.nvim_get_current_buf()

  -- TODO: Doesn't work if we land inside of a comment block because that's a different
  -- "language".
  local root = ts_utils.get_root_for_position(linenr - 1, 0)
  if not root then
    return
  end

  for _, captures, _ in function_q:iter_matches(root, bufnr) do
    local sline = captures[1]:range()

    if sline >= linenr - 1 then
      local parms = {}
      for parm, node_type in captures[1]:iter_children() do
        -- Parameters are given via "name" nodes, other nodes might be comments etc.
        if node_type == 'name' then
          table.insert(parms, get_node_text(parm, bufnr))
        end
      end

      local returns = return_q:iter_matches(captures[2], bufnr)()
      return parms, returns
    end
  end
end

return {
  s.parse('for', 'for ${1:i} = ${2:1}, ${3:n} do\n\t$0\nend'),
  s.parse('fun', 'local function ${1:name}($2)\n\t$0\nend'),
  s.parse('while', 'while ${1:cond} do\n\t$0\nend'),
  s.parse('mfun', 'function M.${1:name}($2)\n\t$0\nend'),
  s.parse('pairs', 'for ${1:key}, ${2:value} in pairs($3) do\n\t$0\nend'),
  s.parse('ipairs', 'for ${1:i}, ${2:value} in ipairs($3) do\n\t$0\nend'),
  s.parse('if', 'if ${1:cond} then\n\t$0\nend'),
  s.parse('ifn', 'if not ${1:cond} then\n\t$0\nend'),
  s.parse('lf', 'local function ${1:name}(${2})\n  $0\nend'),
  s.parse('mf', 'function ${1:M}.${2:name}(${3})\n  $0\nend'),
  s.s(
    { trig = 'req', dscr = 'require, can take spaces' },
    s.fmt('local {} = require("{}")', {
      s.l(s.l._1:match('[^.]*$'):gsub('[^%a]+', '_'), 1),
      s.i(1, 'module'),
    })
  ),
  s.s(
    { trig = 'preq', dscr = 'require with pcall' },
    s.fmt(
      'local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end',
      {
        s.l(s.l._1:match('[^.]*$'):gsub('[^%a]+', '_'), 1),
        s.i(1, 'module'),
      }
    )
  ),
  s.s('doc', {
    s.t('--- '),
    s.i(1, 'Function description.'),
    s.d(2, function(_, snip)
      local parms, ret = next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))
      assert(parms, 'Did not find a function!')

      local parm_nodes = {}
      for j, parm in ipairs(parms) do
        table.insert(parm_nodes, s.t({ '', '-- @param ' .. parm .. ' ' }))
        table.insert(parm_nodes, s.i(j, 'Parameter description.'))
      end

      if ret then
        table.insert(parm_nodes, s.t({ '', '-- @return ' }))
        table.insert(parm_nodes, s.i(#parms + 1, 'Return description.'))
      end

      return s.sn(1, parm_nodes)
    end),
  }),
  s.s(
    { trig = 'guard', dscr = 'Guard against missing module' },
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
