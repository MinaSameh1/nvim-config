local status_ok, bufferline = pcall(require, 'bufferline')
if not status_ok then
  print('problem with bufferline.')
  return
end

bufferline.setup({
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
})

local nnoremap = require('config.utils').nnoremap
-- *******************************
-- *         BufferLine          *
-- *******************************
nnoremap(']b', ':BufferLineCycleNext<CR>') -- Go right
nnoremap('[b', ':BufferLineCyclePrev<CR>') -- Go left
nnoremap(']B', ':BufferLineMoveNext<CR>') -- Move the buffer to the right
nnoremap('[B', ':BufferLineMovePrev<CR>') -- Move the buffer to the left
nnoremap('<leader>be', ':BufferLineSortByExtension<CR>') -- Sort buffer by Extension
nnoremap('<leader>bd', ':BufferLineSortByDirectory<CR>') -- Sort buffer by Directory
nnoremap('<leader>gb', ':BufferLinePick<CR>') -- Pick buffer
