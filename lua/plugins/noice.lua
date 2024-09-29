-- Create highlight group NotifyBackground
vim.cmd('hi NotifyBackground guibg=#1e222a')

local nnoremap = require('config.utils').nnoremap

nnoremap(
  '<M-space>',
  '<cmd>Noice dismiss<CR><cmd>lua require("fidget.notification").clear()<CR>',
  { desc = 'Dismiss notifications' }
)

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    routes = {
      {
        view = 'notify',
        filter = { event = 'msg_showmode' },
      },
    },
    background_colour = '#1e222a',
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      -- bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      -- long_message_to_split = true, -- long messages will be sent to a split
      -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    {
      'MunifTanjim/nui.nvim',
      event = 'VeryLazy',
    },
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      'rcarriga/nvim-notify',
      event = 'VeryLazy',
    },
  },
}
