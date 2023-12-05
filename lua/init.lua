--[[
-- **************************
-- *         Plugins        *
-- **************************
--]]
local utils = require('config.utils')
local xmap = utils.xmap
local nnoremap = utils.nnoremap

-- vimtex, Must be loaded before filetype
vim.g.vimtex_view_method = 'zathura'
vim.g.tex_flavor = 'latex'
vim.opt.conceallevel = 1

-- Fuigitive
nnoremap('<leader>gg', '<Cmd>Git<CR>') -- fugitive Git window
nnoremap('<leader>gc', '<Cmd>Git commit<CR>') -- Commit
-- Easy Align
xmap('ga', '<Plug>(EasyAlign)') -- Start interactive EasyAlign in visual mode (e.g. vipga)
nnoremap('ga', '<Plug>(EasyAlign)') -- Start interactive EasyAlign for a motion/text object (e.g. gaip)

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.g.dashboard_default_executive = 'telescope' -- Use telescope

-- Mappings for Trouble
vim.keymap.set(
  'n',
  '<leader>xx',
  '<cmd>TroubleToggle<cr>',
  { silent = true, noremap = true, desc = 'Toggle Trouble' }
)
vim.keymap.set(
  'n',
  '<leader>xl',
  '<cmd>Trouble loclist<cr>',
  { silent = true, noremap = true, desc = 'Loclist' }
)
vim.keymap.set(
  'n',
  '<leader>xq',
  '<cmd>Trouble quickfix<cr>',
  { silent = true, noremap = true, desc = 'Quickfix' }
)
-- Focus
vim.api.nvim_set_keymap(
  'n',
  '<leader>S',
  ':FocusSplitNicely<CR>',
  { silent = true, noremap = true, desc = 'Focus Split Nicely' }
)

require('config')
require('config.colorscheme')
require('colors.colors')
require('cmds')

-- If your colorscheme doesn't define @lsp.* groups yet,
-- but it does define treesitter highlights,
-- you might find it useful to link the semantic groups to the treesitter groups
-- to get consistent colors:
local links = {
  ['@lsp.type.namespace'] = '@namespace',
  ['@lsp.type.type'] = '@type',
  ['@lsp.type.class'] = '@type',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.interface'] = '@type',
  ['@lsp.type.struct'] = '@structure',
  ['@lsp.type.parameter'] = '@parameter',
  ['@lsp.type.variable'] = '@variable',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.function'] = '@function',
  ['@lsp.type.method'] = '@method',
  ['@lsp.type.macro'] = '@macro',
  ['@lsp.type.decorator'] = '@function',
}

for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

local function initHighlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    -- Colors: Purple
    callback = function()
      vim.api.nvim_set_hl(0, '@lsp.mod.readonly', { italic = true })
      -- vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = 'Aqua' })
      -- vim.api.nvim_set_hl(0, '@lsp.type.function', { fg = 'Yellow' })
      vim.api.nvim_set_hl(0, '@lsp.type.method', { fg = 'Orange' })
      vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg = 'Purple' })
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

vim.opt.fillchars = { eob = ' ' }
--[[ vim.cmd.colorscheme('solarized-osaka') ]]
vim.cmd.colorscheme('tokyonight')
-- Original is #268bd3 , use #000 for transparent
vim.cmd('hi LspInlayHint guibg=#3a90f0 guifg=#123')
