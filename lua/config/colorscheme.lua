-- This file is for customizing tokyonight color scheme!
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

vim.cmd([[
    autocmd ColorScheme * highlight NormalFloat guibg=#1f2335
    autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335
    ]])
