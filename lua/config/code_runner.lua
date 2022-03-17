local config_location = require('config.utils').config_location

require('code_runner').setup({
  term = {
    position = 'belowright',
    size = 8,
    mode = 'startinsert',
    tab = false,
  },
  filetype_path = vim.fn.expand(config_location .. '/utils/code_runner.json'),
  project_path = vim.fn.expand(
    config_location .. '/utils/project_manager.json'
  ),
})
vim.api.nvim_set_keymap(
  'n',
  '<leader>R',
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
