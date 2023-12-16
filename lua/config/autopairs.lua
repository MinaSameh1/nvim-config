local status_ok, autopairs = pcall(require, 'nvim-autopairs')
if not status_ok then
  print('Error in autopairs')
  return
end
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds') -- Built in conditions
local ts_conds = require('nvim-autopairs.ts-conds')
local npairs = require('nvim-autopairs')

npairs.add_rules({
  -- For example, when you type `$` in a tex file, autopairs will add a pair of `$` and put the cursor in the middle
  Rule('$', '$', { 'tex', 'latex' })
    -- add a pair if it's not already in an inline_formula
    :with_pair(
      ts_conds.is_not_ts_node({ 'inline_formula' })
    )
    -- move right when repeating $
    :with_move(cond.done())
    -- disable adding a newline when you press <cr>
    :with_cr(cond.none()),

  -- For example, when you type `\[` in a tex file, autopairs will add a pair of `\]` and put the cursor in the middle
  Rule('\\[', '\\]', { 'tex', 'latex' })
    -- add a pair if it's not already in an inline_formula
    :with_pair(
      ts_conds.is_not_ts_node({ 'inline_formula' })
    )
    -- move right when repeating $
    :with_move(cond.done())
    -- disable adding a newline when you press <cr>
    :with_cr(cond.none()),
})

autopairs.setup({
  disable_filetype = {
    'TelescopePrompt',
    'dap-repl',
    'neo-tree',
    'Trouble',
    'lazy',
  },
  disable_in_macro = false, -- disable when recording or executing a macro
  disable_in_visualblock = false, -- disable when insert after visual block mode
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),
  enable_moveright = true,
  enable_afterquote = true, -- add bracket pairs after quote
  enable_check_bracket_line = false, --- check bracket in same line
  check_ts = true,
  ts_config = {
    lua = { 'string' }, -- it will not add a pair on that treesitter node
    javascript = { 'template_string' },
    -- java = false,-- don't check treesitter on java
  },
  map_bs = true, -- map the <BS> key
  map_c_h = false, -- Map the <C-h> key to delete a pair
  map_c_w = false, -- map <c-w> to delete a pair if possible
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    offset = 0, -- Offset from pattern match
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment',
  },
})

require('cmp').event:on(
  'confirm_done',
  require('nvim-autopairs.completion.cmp').on_confirm_done({
    map_char = { tex = '' },
  })
)
