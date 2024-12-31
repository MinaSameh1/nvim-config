-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local utils = require('config.utils')

vim.opt.expandtab = true -- use spaces when <Tab> is inserted
vim.opt.shiftwidth = 2 -- number of spaces to use for (auto)indent step
vim.opt.tabstop = 2 -- number of spaces that <Tab> in file uses
vim.opt.softtabstop = 2 -- number of spaces that <Tab> uses while editing

vim.opt.undodir = utils.config_location .. '/undodir' -- where to store undo files
