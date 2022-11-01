local status_ok, coderunner = pcall(require, 'code_runner')
if not status_ok then
  print('Error in coderunner config')
  return
end

local config_location = require('config.utils').config_location

coderunner.setup({
  term = {
    position = 'belowright',
    size = 4,
    mode = 'startinsert',
    tab = false,
  },
  filetype_path = vim.fn.expand(config_location .. '/utils/code_runner.json'),
  project_path = vim.fn.expand(
    config_location .. '/utils/project_manager.json'
  ),
})

-- Keymaps
vim.api.nvim_set_keymap(
  'n',
  '<leader>rc',
  ':RunCode<CR>',
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>rf',
  ':RunFile<CR>',
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>rp',
  ':RunProject<CR>',
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>rc',
  ':RunClose<CR>',
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>crf',
  ':CRFiletype<CR>',
  { noremap = true, silent = false }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>crp',
  ':CRProjects<CR>',
  { noremap = true, silent = false }
)
