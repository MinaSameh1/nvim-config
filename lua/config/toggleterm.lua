local status_ok, toggleterm = pcall(require, 'toggleterm')
if not status_ok then
  return
end

local direction = 'float'

toggleterm.setup({
  size = 20,
  open_mapping = [[<c-`>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = direction, --'vertical' | 'horizontal' | 'window' | 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = 'Normal',
      background = 'Normal',
    },
  },
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 'n', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-o><esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-o>o', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require('toggleterm.terminal').Terminal

-- Custom terminals :P
local bashtop = Terminal:new({
  cmd = 'bashtop',
  hidden = true,
  direction = direction,
})

function _BASHTOP_TOGGLE()
  bashtop:toggle()
end

local node = Terminal:new({
  cmd = 'node',
  hidden = true,
  direction = direction,
})

function _NODE_TOGGLE()
  node:toggle()
end

local ncdu = Terminal:new({
  cmd = 'ncdu',
  hidden = true,
  direction = direction,
})

function _NCDU_TOGGLE()
  ncdu:toggle()
end

local htop = Terminal:new({
  cmd = 'htop',
  hidden = true,
  direction = direction,
})

function _HTOP_TOGGLE()
  htop:toggle()
end

local python = Terminal:new({
  cmd = 'ipython',
  hidden = true,
  direction = direction,
})

function _PYTHON_TOGGLE()
  python:toggle()
end

local lazydocker = Terminal:new({
  cmd = 'lazydocker',
  hidden = true,
  direction = direction,
})

function _DOCKER_TOGGLE()
  lazydocker:toggle()
end

-- Key maps
local Key = vim.api.nvim_set_keymap
local Opts = { noremap = true, silent = true }
local setDesc = require('config.utils').getDescWithMapOptsSetter(Opts)

Key('n', '<leader>tH', '<Cmd>lua _HTOP_TOGGLE()<CR>', setDesc('Toggle htop'))
Key(
  'n',
  '<leader>tp',
  '<Cmd>lua _PYTHON_TOGGLE()<CR>',
  setDesc('Toggle python')
)
Key('n', '<leader>tn', '<Cmd>lua _NODE_TOGGLE()<CR>', setDesc('Toggle node'))
Key('n', '<leader>tN', '<Cmd>lua _NCDU_TOGGLE()<CR>', setDesc('Toggle ncdu'))
Key(
  'n',
  '<leader>tH',
  '<Cmd>lua _BASHTOP_TOGGLE()<CR>',
  setDesc('Toggle bashtop')
)
Key(
  'n',
  '<leader>tD',
  '<Cmd>lua _DOCKER_TOGGLE()<CR>',
  setDesc('Toggle docker')
)
