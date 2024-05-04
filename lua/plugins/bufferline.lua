-- *******************************
-- *         BufferLine          *
-- *******************************

return {
  'akinsho/bufferline.nvim',
  event = 'BufWinEnter',
  dependencies = { 'nvim-web-devicons' },
  --- @type LazyKeysSpec[]
  keys = {
    {
      ']B',
      ':BufferLineMoveNext<CR>',
      noremap = true,
      desc = 'Move the buffer to the right',
    },
    {
      '[B',
      ':BufferLineMovePrev<CR>',
      noremap = true,
      desc = 'Move the buffer to the left',
    },
    {
      ']b',
      ':BufferLineCycleNext<CR>',
      noremap = true,
      desc = 'Right buffer',
    },
    {
      '[b',
      ':BufferLineCyclePrev<CR>',
      noremap = true,
      desc = 'Left buffer',
    },
    {
      '<leader>be',
      ':BufferLineSortByExtension<CR>',
      noremap = true,
      desc = 'Sort by extension',
    },
    {
      '<leader>bd',
      ':BufferLineSortByDirectory<CR>',
      noremap = true,
      desc = 'Sort by directory',
    },
    {
      '<leader>bp',
      ':BufferLineTogglePin<CR>',
      noremap = true,
      desc = 'Pin current Buffer',
    },
    {
      '<leader>gb',
      ':BufferLinePick<CR>',
      noremap = true,
      desc = 'Pick buffer',
    },
  },
  opts = {
    options = {
      -- numbers = 'buffer_id',
      numbers = function(opts)
        return string.format('%s', opts.ordinal)
      end,
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return '(' .. count .. ')'
      end,
      right_mouse_command = 'vertical sbuffer %d',
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          highlight = 'Directory',
        },
        {
          filetype = 'Outline',
          text = 'Symbols',
          highlight = 'Directory',
        },
      },
      -- show_buffer_close_icons = false,
      -- show_close_icon = false,
      -- Filter out the buffers that shouldn't be shown
      ---@diagnostic disable-next-line: unused-local
      custom_filter = function(buf, _buf_nums)
        -- create a lookup table for all filetypes that shouldn't be shown
        local hideBufTypes = {
          ['fugitive'] = true,
          ['Outline'] = true,
          ['neo-tree'] = true,
        }
        return not hideBufTypes[vim.bo[buf].filetype]
      end,
    },
  },
}
