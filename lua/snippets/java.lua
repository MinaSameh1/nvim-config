local s = require('snippets.helpers')
local utils = require('config.utils')

-- complicated function for dynamicNode.
local function jdocsnip(args, _, old_state)
  -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
  -- Using a restoreNode instead is much easier.
  -- View this only as an example on how old_state functions.
  local nodes = {
    s.t({ '/**', ' * ' }),
    s.i(1, 'A short Description'),
    s.t({ '', '' }),
  }

  -- These will be merged with the snippet; that way, should the snippet be updated,
  -- some user input eg. text can be referred to in the new snippet.
  local param_nodes = {}

  if old_state then
    nodes[2] = s.i(1, old_state.descr:get_text())
  end
  param_nodes.descr = nodes[2]

  -- At least one param.
  if string.find(args[2][1], ', ') then
    vim.list_extend(nodes, { s.t({ ' * ', '' }) })
  end

  local insert = 2
  for _indx, arg in ipairs(vim.split(args[2][1], ', ', true)) do
    -- Get actual name parameter.
    arg = vim.split(arg, ' ', true)[2]
    if arg then
      local inode
      -- if there was some text in this parameter, use it as static_text for this new snippet.
      if old_state and old_state[arg] then
        inode = s.i(insert, old_state['arg' .. arg]:get_text())
      else
        inode = s.i(insert)
      end
      vim.list_extend(
        nodes,
        { s.t({ ' * @param ' .. arg .. ' ' }), inode, s.t({ '', '' }) }
      )
      param_nodes['arg' .. arg] = inode

      insert = insert + 1
    end
  end

  if args[1][1] ~= 'void' then
    local inode
    if old_state and old_state.ret then
      inode = s.i(insert, old_state.ret:get_text())
    else
      inode = s.i(insert)
    end

    vim.list_extend(
      nodes,
      { s.t({ ' * ', ' * @return ' }), inode, s.t({ '', '' }) }
    )
    param_nodes.ret = inode
    insert = insert + 1
  end

  if vim.tbl_count(args[3]) ~= 1 then
    local exc = string.gsub(args[3][2], ' throws ', '')
    local ins
    if old_state and old_state.ex then
      ins = s.i(insert, old_state.ex:get_text())
    else
      ins = s.i(insert)
    end
    vim.list_extend(
      nodes,
      { s.t({ ' * ', ' * @throws ' .. exc .. ' ' }), ins, s.t({ '', '' }) }
    )
    param_nodes.ex = ins
    insert = insert + 1
  end

  vim.list_extend(nodes, { s.t({ ' */' }) })

  local snip = s.sn(nil, nodes)
  -- Error on attempting overwrite.
  snip.old_state = param_nodes
  return snip
end

return {
  s.s({
    trig = 'sout',
    dsrc = 'System.out.println',
  }, s.t('System.out.println("'), s.i(1), s.t('");')),
  s.s(
    { trig = 'pack', name = 'package', dscr = 'package' },
    s.fmta(
      [[
    package <>;
    ]],
      {
        s.f(function(_, _)
          local path = utils.get_relative_path()

          -- get package name
          local package = path
            :gsub('src/main/java/', '')
            :gsub('/', '.')
          return package
        end),
      }
    )
  ),
  s.s(
    { trig = 'time', dscr = 'Time code execution' },
    s.fmta(
      [[
long startTime = System.currentTimeMillis();
<>
long endTime = System.currentTimeMillis();
System.out.println("Execution time of <>: " + (endTime - startTime) + "ms");
      ]],
      {
        s.d(1, s.get_visual),
        s.i(2, 'name'),
      }
    )
  ),
  -- Java methods
  s.s('fn', {
    s.d(6, jdocsnip, { 2, 4, 5 }),
    s.t({ '', '' }),
    s.c(1, {
      s.t('public '),
      s.t('private '),
      s.t('protected '),
    }),
    s.c(2, {
      s.t('void'),
      s.t('String'),
      s.t('char'),
      s.t('int'),
      s.t('double'),
      s.t('boolean'),
      s.i(nil, ''),
    }),
    s.t(' '),
    s.i(3, 'myMethod'),
    s.t('('),
    s.i(4),
    s.t(')'),
    s.c(5, {
      s.t(''),
      s.sn(nil, {
        s.t({ '', ' throws ' }),
        s.i(1),
      }),
    }),
    s.t({ ' {', '\t' }),
    s.i(0),
    s.t({ '', '}' }),
  }),
}
