-- change github copilot suggestion color
-- vim.cmd('hi CopilotSuggestion guifg=#555555 ctermfg=8')

local Snacks = require('snacks')
local copilot_exists = pcall(require, 'copilot')

-- Map github copilot suggestion key
vim.api.nvim_set_keymap('i', '<C-\\>', 'copilot#Accept("")', {
  noremap = false,
  expr = true,
  silent = true,
  desc = 'Accept Copilot Suggestion',
})

if copilot_exists then
  Snacks.toggle({
    name = 'Copilot Completion',
    color = {
      enabled = 'azure',
      disabled = 'orange',
    },
    get = function()
      return not require('copilot.client').is_disabled()
    end,
    set = function(state)
      if state then
        require('copilot.command').enable()
      else
        require('copilot.command').disable()
      end
    end,
  }):map('<leader>at')
end
