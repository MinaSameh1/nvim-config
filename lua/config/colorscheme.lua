-- This file is for customizing color schemes!
local M = {}

function M.setupTokyonight()
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
end

-- Border for floaty stuff :P
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1f2335' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = 'white', bg = '#1f2335' })

function M.TransparentEnable()
  M.bg = vim.api.nvim_get_hl(0, {
    name = 'NormalFloat',
  }).background
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineTabClose', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferlineBufferSelected', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineBackground', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineSeparator', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineIndicatorSelected', { bg = 'none' })
end

function M.TransparentDisable()
  vim.api.nvim_set_hl(0, 'Normal', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'NonText', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineTabClose', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'BufferlineBufferSelected', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineBackground', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineSeparator', { bg = M.bg or 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineIndicatorSelected', { bg = M.bg or 'none' })
  vim.cmd.colorscheme(vim.g.colors_name)
end

return M
