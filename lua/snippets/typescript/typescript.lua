local s = require('snippets.helpers')
local get_node_text = require('config.utils').get_node_text

--[[ require('snippets.javascript') -- Load js snippets ]]

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
if not ts_utils_ok then
  return {}
end

local function_q = vim.treesitter.query.parse(
  'typescript',
  -- (function_definition parameters: (parameters) @parms)
  [[
    [
        (function_declaration parameters: (formal_parameters) @parms)
    ] @fn
]]
)
-- This only matches returns that actually return something, so early return can still be used for
-- control flow!
local return_q =
  vim.treesitter.query.parse('typescript', '(return_statement) @ret')

--- Obtains list of parameter names for the next lua function and whether it returns something.
-- @param linenr Line number at which we start searching.
-- @return parms, ret where parms is a list of parameters, in the order that they appear in the
--         function and ret is truthy if the function ever returns something.
local function next_fun_parms(linenr)
  if not linenr then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()

  -- TODO: Doesn't work if we land inside of a comment block because that's a different
  -- "language".
  local root = ts_utils.get_root_for_position(linenr - 1, 0)
  if not root then
    return
  end

  for _, captures, _ in function_q:iter_matches(root, bufnr) do
    if not getmetatable(captures) and not getmetatable(captures[1]) then
      return
    end
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
  -- TODO: Fix this, needs better queries
  s.s('doc', {
    s.t({ '', '/**' }),
    s.t({ '', ' *' }),
    s.i(1, ' Function description.'),
    s.d(2, function(_, snip)
      local parms, ret = next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))
      -- checks if table is empty
      assert(parms and next(parms), 'Did not find a function!')

      local parm_nodes = {}
      for j, parm in ipairs(parms) do
        table.insert(parm_nodes, s.t({ '', '@param ' .. parm .. ' ' }))
        table.insert(parm_nodes, s.i(j, 'Parameter description.'))
      end

      if ret then
        table.insert(parm_nodes, s.t({ '', '@return ' }))
        table.insert(parm_nodes, s.i(#parms + 1, 'Return description.'))
      end

      table.insert(parm_nodes, s.t({ '', ' *' }))
      table.insert(parm_nodes, s.t({ '', ' */' }))
      return s.s(1, parm_nodes)
    end),
  }),
  s.s(
    'func',
    s.fmt(
      [[
    /**
      * @function {doc}
      * @description {}
      * @param {paramdoc}
      * @return {ret}
      */
    {} {} ({}): {} {{{}}}
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
        paramdoc = s.i(4),
        s.i(5, 'return'),
        s.i(6, 'body'),
        s.i(7, 'description'),
        ret = s.f(s.copy, 5),
        doc = s.f(s.copy, 2),
      }
    ),
    { condition = s.conds.line_begin }
  ),
  s.parse({
    trig = 'errimpl',
    description = 'Adds a throw err with message',
  }, 'throw new Error("${1:Not Implemented}");'),
  s.parse('clgv', 'console.log("${1:value} >>", ${2:value});'),
  s.parse('clg', 'console.log("${1:value}");'),
  s.s(
    { trig = 'time', dscr = 'Time code execution' },
    s.fmta(
      [[
        const start = new Date().getTime();
        <>
        const end = new Date().getTime() - start;
        console.log(">>#Execution time of <>: " + end + "ms");
      ]],
      {
        s.d(1, s.get_visual),
        s.i(2, 'name'),
      }
    )
  ),
  s.s(
    { trig = 'cl', snippetType = 'autosnippet' },
    s.fmta([[console.log(<>)]], {
      s.d(1, s.get_visual),
    }),
    { condition = s.conds.line_begin }
  ),
  s.postfix('.br', {
    s.f(function(_, parent)
      return '[' .. parent.snippet.env.POSTFIX_MATCH .. ']'
    end, {}),
  }),
}
