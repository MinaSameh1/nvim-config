local s = require('snippets.helpers')

local vars = {
  username = 'minasameh1',
  email = 'mina.s.wadie@gmail.com',
  github = 'https://github.com/minasameh1',
  real_name = 'Mina Sameh',
}

local calculate_comment_string = require('Comment.ft').calculate
local utils = require('Comment.utils')

--- Get the comment string {beg,end} table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_cstring = function(ctype)
  -- use the `Comments.nvim` API to fetch the comment string for the region (eq. '--%s' or '--[[%s]]' for `lua`)
  ---@diagnostic disable-next-line: missing-fields
  local cstring = calculate_comment_string({
    ctype = ctype,
    range = utils.get_region(),
  }) or vim.bo.commentstring
  -- as we want only the strings themselves and not strings ready for using `format`
  -- we want to split the left and right side
  local left, right = utils.unwrap_cstr(cstring)
  -- create a `{left, right}` table for it
  return { left, right }
end

--- Options for marks to be used in a TODO comment
local marks = {
  signature = function()
    return s.fmt('<{}>', s.i(1, vars.username))
  end,
  signature_with_email = function()
    return s.fmt('<{}{}>', { s.i(1, vars.username), s.i(2, ' ' .. vars.email) })
  end,
  date_signature_with_email = function()
    return s.fmt('<{}{}{}>', {
      s.i(1, os.date('%d-%m-%y')),
      s.i(2, ', ' .. vars.username),
      s.i(3, ' ' .. vars.email),
    })
  end,
  date_signature = function()
    return s.fmt(
      '<{}{}>',
      { s.i(1, os.date('%d-%m-%y')), s.i(2, ', ' .. vars.username) }
    )
  end,
  date = function()
    return s.fmt('<{}>', s.i(1, os.date('%d-%m-%y')))
  end,
  empty = function()
    return s.t('')
  end,
}

local todo_snippet_nodes = function(aliases, opts)
  local aliases_nodes = vim.tbl_map(function(alias)
    return s.i(nil, alias) -- generate choices for [name-of-comment]
  end, aliases)
  local sigmark_nodes = {} -- choices for [comment-mark]
  for _, mark in pairs(marks) do
    table.insert(sigmark_nodes, mark())
  end
  -- format them into the actual snippet
  local comment_node = s.fmta('<> <>: <> <> <><>', {
    s.f(function()
      return get_cstring(opts.ctype)[1] -- get <comment-string[1]>
    end),
    s.c(1, aliases_nodes), -- [name-of-comment]
    s.i(3), -- {comment-text}
    s.c(2, sigmark_nodes), -- [comment-mark]
    s.f(function()
      return get_cstring(opts.ctype)[2] -- get <comment-string[2]>
    end),
    s.i(0),
  })
  return comment_node
end

--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[]|string of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
local todo_snippet = function(context, aliases, opts)
  opts = opts or {}
  -- if we do not have aliases, be smart about the function parameters
  aliases = type(aliases) == 'string' and { aliases } or aliases
  context = context or {}
  -- all we need from the context is the trigger
  if not context.trig then
    return error("context doesn't include a `trig` key which is mandatory", 2)
  end
  -- comment type can be passed in the `opts` table, but if it is not, we have to ensure, it is defined
  opts.ctype = opts.ctype or 1
  ---@diagnostic disable-next-line: param-type-mismatch
  local alias_string = table.concat(aliases, '|') -- `choice_node` documentation
  context.name = context.name or (alias_string .. ' comment') -- generate the `name` of the snippet if not defined
  context.dscr = context.dscr
    or (alias_string .. ' comment with a signature-mark') -- generate the `dscr` if not defined
  context.docstring = context.docstring
    or (' {1:' .. alias_string .. '}: {3} <{2:mark}>{0} ') -- generate the `docstring` if not defined
  -- nodes from the previously defined function for their generation
  local comment_node = todo_snippet_nodes(aliases, opts)
  return s.s(context, comment_node, opts) -- the final todo-snippet constructed from our parameters
end

local todo_snippet_specs = {
  { { trig = 'todo' }, 'TODO' },
  { { trig = 'fix' }, { 'FIX', 'BUG', 'ISSUE', 'FIXIT' } },
  { { trig = 'hack' }, 'HACK' },
  { { trig = 'warn' }, { 'WARN', 'WARNING', 'XXX' } },
  { { trig = 'perf' }, { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' } },
  { { trig = 'note' }, { 'NOTE', 'INFO' } },
  -- NOTE: Block commented todo-comments <kunzaatko>
  {
    { trig = 'todob' },
    'TODO',
    { ctype = 2 },
  },
  {
    { trig = 'fixb' },
    { 'FIX', 'BUG', 'ISSUE', 'FIXIT' },
    { ctype = 2 },
  },
  {
    { trig = 'hackb' },
    'HACK',
    { ctype = 2 },
  },
  {
    { trig = 'warnb' },
    { 'WARN', 'WARNING', 'XXX' },
    { ctype = 2 },
  },
  {
    { trig = 'perfb' },
    { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' },
    { ctype = 2 },
  },
  { { trig = 'noteb' }, { 'NOTE', 'INFO' }, { ctype = 2 } },
}

local todo_comment_snippets = {}

for _, v in ipairs(todo_snippet_specs) do
  -- NOTE: 3rd argument accepts nil
  table.insert(todo_comment_snippets, todo_snippet(v[1], v[2], v[3]))
end

s.add_snippets(
  'all',
  todo_comment_snippets,
  { type = 'snippets', key = 'todo_comments' }
)

return {
  s.s('date', s.p(os.date, '%Y-%m-%d')),
  s.s('datetime', s.p(os.date, '%Y-%m-%d %H:%M:%S')),
  s.parse('luasnip', 'loaded!!'),
  s.parse(
    { trig = 'ternary', wordTrig = false },
    '${1:cond} ? ${2:true} : ${3:false}'
  ),
}
