-- This file is for customizing color schemes!

vim.g.tokyonight_style = 'storm' -- Can be storm, night or day
vim.g.tokyonight_sidebars = {
  'TelescopePrompt',
  'NvimTree',
  'terminal',
  'packer',
  'tagbar',
  'dap-repl',
}
-- Change the "hint" color to the "orange" color, and make the "error" color bright red
vim.g.tokyonight_colors = { hint = 'orange', error = '#ff0000' }

-- NeoSolarized
require('NeoSolarized').setup({
  style = 'dark',
  transparent = false,
})

-- Border for floaty stuff :P
vim.cmd([[
  autocmd ColorScheme * highlight NormalFloat guibg=#1f2335
  autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335
]])
