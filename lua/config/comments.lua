local status_ok, comment = pcall(require, 'Comment')
if not status_ok then
  return
end

comment.setup({
  -- Add a space b/w comment and the line
  -- @type boolean
  padding = true,

  -- Whether the cursor should stay at its position
  -- NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
  -- @type boolean
  sticky = true,

  -- LHS of operator-pending mappings in NORMAL + VISUAL mode
  -- @type table
  opleader = {
    -- Line-comment keymap
    line = 'gc',
    -- Block-comment keymap
    block = 'gb',
  },
  toggler = {
    ---Line-comment toggle keymap
    line = 'gcc',
    ---Block-comment toggle keymap
    block = 'gbc',
  },

  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
