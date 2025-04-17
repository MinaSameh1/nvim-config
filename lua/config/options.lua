-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local utils = require('config.utils')

-- open lazyvim in current directory and ignore lsp and .git
-- vim.g.root_spec = { 'cwd' }

vim.opt.expandtab = true -- use spaces when <Tab> is inserted
vim.opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
vim.opt.tabstop = 2 -- number of spaces that <Tab> in file uses
vim.opt.softtabstop = 2 -- number of spaces that <Tab> uses while editing

vim.opt.undodir = utils.config_location .. '/undodir' -- where to store undo files

local function initHighlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    -- Colors: Purple
    callback = function()
      vim.api.nvim_set_hl(0, '@lsp.mod.readonly', { italic = true })
      vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = '#7aa2f7' }) -- Blue
      vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = '#bb9af7' }) -- Purple
      vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = '#ff9e64' }) -- Orange
      vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = '#9ece6a' }) -- Green
      vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg = '#e0af68' }) -- Yellow
      vim.api.nvim_set_hl(0, '@lsp.type.property', { fg = '#73daca' }) -- Cyan
      vim.api.nvim_set_hl(
        0,
        '@lsp.typemod.function.classScope',
        { fg = '#ff9e64' }
      ) -- Orange
      vim.api.nvim_set_hl(
        0,
        '@lsp.typemod.variable.globalScope',
        { fg = '#f7768e' }
      ) -- Red
    end,
  })
end

initHighlights()
