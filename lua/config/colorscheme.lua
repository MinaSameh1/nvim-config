-- This file is for customizing color schemes!
local M = {}

-- Border for floaty stuff :P
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1f2335' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = 'white', bg = '#1f2335' })

function M.TransparentEnable()
  M.bg = vim.api.nvim_get_hl(0, {
    name = 'Normal',
  }).bg
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
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
end

function M.TransparentDisable()
  M.bg = nil
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
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = M.bg or 'none' })
  vim.cmd.colorscheme(vim.g.colors_name)
end

function M.TransparentToggle()
  if M.bg then
    M.TransparentDisable()
  else
    M.TransparentEnable()
  end
end

function M.initHighlights()
  vim.cmd([[
    " hi @lsp.type.class      guifg=Aqua
    " hi @lsp.type.function   guifg=Yellow
    hi @lsp.type.method     guifg=Orange
    hi @lsp.type.parameter  guifg=Purple
    hi @lsp.type.variable   guifg=Yellow
    " hi @lsp.type.property   guifg=Green

    " hi @lsp.typemod.function.classScope  guifg=Orange
    " hi @lsp.typemod.variable.classScope  guifg=Orange
    " hi @lsp.typemod.variable.fileScope   guifg=Orange
    hi @lsp.typemod.variable.globalScope guifg=Red
    ]])
end

return M
