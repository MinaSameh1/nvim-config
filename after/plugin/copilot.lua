-- change github copilot suggestion color
vim.cmd('hi CopilotSuggestion guifg=#555555 ctermfg=8')

-- Map github copilot suggestion key
vim.api.nvim_set_keymap('i', '<C-\\>', 'copilot#Accept("")', {
  noremap = false,
  expr = true,
  silent = true,
  desc = 'Accept Copilot Suggestion',
})

vim.g.copilot_no_tab_map = true
