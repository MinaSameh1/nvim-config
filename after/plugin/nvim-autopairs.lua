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
