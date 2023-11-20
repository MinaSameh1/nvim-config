local nnoremap = require('config.utils').nnoremap
-- *******************************
-- *         BufferLine          *
-- *******************************
nnoremap(']b', ':BufferLineCycleNext<CR>', { desc = 'Right buffer' }) -- Go right
nnoremap('[b', ':BufferLineCyclePrev<CR>', { desc = 'Left buffer' }) -- Go left
nnoremap(
  ']B',
  ':BufferLineMoveNext<CR>',
  { desc = 'Move the buffer to the right' }
) -- Move the buffer to the right
nnoremap(
  '[B',
  ':BufferLineMovePrev<CR>',
  { desc = 'Move the buffer to the left' }
) -- Move the buffer to the left
nnoremap(
  '<leader>be',
  ':BufferLineSortByExtension<CR>',
  { desc = 'Sort by extension' }
) -- Sort buffer by Extension
nnoremap(
  '<leader>bd',
  ':BufferLineSortByDirectory<CR>',
  { desc = 'Sort by directory' }
) -- Sort buffer by Directory
nnoremap('<leader>gb', ':BufferLinePick<CR>', { desc = 'Pick buffer' }) -- Pick buffer

return {
  'akinsho/bufferline.nvim',
  event = 'BufWinEnter',
  version = '*',
  dependencies = { 'nvim-web-devicons' },
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
          filetype = 'NvimTree',
          text = 'File Explorer',
          highlight = 'Directory',
        },
        {
          filetype = 'aerial',
          text = 'Symbols',
          highlight = 'Directory',
        },
      },
      -- show_buffer_close_icons = false,
      -- show_close_icon = false,
      -- Filter out the buffers that shouldn't be shown
      custom_filter = function(buf, buf_nums)
        return vim.bo[buf].filetype ~= 'fugitive'
      end,
    },
  },
}
