-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local utils = require('config.utils')

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
      -- vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = 'Aqua' })
      -- vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = 'Yellow' })
      vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = 'Orange' })
      -- vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = 'Purple' })
      vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg = 'Yellow' })
      -- vim.api.nvim_set_hl(0, '@lsp.type.property', { fg = 'Green' })
      --[[ vim.api.nvim_set_hl(
        0,
        '@lsp.typemod.function.classScope',
        { fg = 'Orange' }
      )
      vim.api.nvim_set_hl(
        0,
        '@lsp.typemod.variable.classScope',
        { fg = 'Orange' }
      )
      vim.api.nvim_set_hl(
        0,
        '@lsp.typemod.variable.fileScope',
        { fg = 'Orange' }
      ) ]]
      vim.api.nvim_set_hl(
        0,
        '@lsp.typemod.variable.globalScope',
        { fg = 'Red' }
      )
    end,
  })
end

initHighlights()
