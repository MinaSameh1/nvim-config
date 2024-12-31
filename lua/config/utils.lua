local api = vim.api
local fn = vim.fn
local utils = {}

utils.config_location = vim.fn.stdpath('config')

--- Handle Neovim version differences for treesitter
-- @param node the node to get the text from
-- @param buf the buffer to get the text from
-- @return the text of the node
-- @see https://github.com/stevearc/aerial.nvim/commit/a6b86fd357f184ad9f146245f8d34c9df0f424fa
function utils.get_node_text(node, bufnr)
  if vim.treesitter.get_node_text then
    -- Neovim 0.9
    return vim.treesitter.get_node_text(node, bufnr)
  elseif vim.treesitter.query and vim.treesitter.query.get_node_text then
    return vim.treesitter.query.get_node_text(node, bufnr)
  else
    local ts_utils = require('nvim-treesitter.ts_utils')
    return ts_utils.get_node_text(node, bufnr)[1]
  end
end

function utils.cd_current_file()
  vim.cmd('cd ' .. vim.fn.fnameescape(vim.fn.expand('%:p:h')))
end

function utils.search_for_file_in_parent_dirs(filename)
  local current_dir = vim.fn.expand('%:p:h')
  local file = vim.fn.findfile(filename, current_dir .. ';')

  if file ~= '' then
    vim.cmd('edit ' .. vim.fn.fnameescape(file))
  else
    print(filename .. ' not found in current or parent directories')
  end
end

function utils.search_and_cd_for_file(filename)
  local current_dir = vim.fn.expand('%:p:h')
  local file = vim.fn.findfile(filename, current_dir .. ';')

  if file ~= '' then
    vim.cmd('cd ' .. vim.fn.fnameescape(vim.fn.fnamemodify(file, ':h')))
  else
    print(filename .. ' not found in current or parent directories')
  end
end

function utils.jumps_to_qf()
  local jumplist, _ = unpack(vim.fn.getjumplist())
  local qf_list = {}
  if #jumplist == 0 then
    print('No jumps found')
    return
  end
  if type(jumplist) == 'integer' then
    return
  end
  for _, v in pairs(jumplist) do
    if vim.fn.bufloaded(v.bufnr) == 1 then
      table.insert(qf_list, {
        bufnr = v.bufnr,
        lnum = v.lnum,
        col = v.col,
        text = vim.api.nvim_buf_get_lines(v.bufnr, v.lnum - 1, v.lnum, false)[1],
      })
    end
  end
  vim.fn.setqflist(qf_list, ' ')
  vim.cmd('Trouble quickfix')
end

function utils.insertFullPath()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath) -- write to clippoard
  return filepath
end

function utils.getfsize(bufnr)
  local file = nil
  if bufnr == nil then
    file = vim.fn.expand('%:p')
  else
    file = vim.api.nvim_buf_get_name(bufnr)
  end

  local size = vim.fn.getfsize(file)

  return size <= 0 and 0 or size
end

function utils.is_big_file(buf, opts)
  opts = opts or {}
  local size = opts.size or (1024 * 1000)
  local lines = opts.lines or 10000

  if utils.getfsize(buf) > size then
    return true
  end
  if vim.api.nvim_buf_line_count(buf) > lines then
    return true
  end
  return false
end

function utils.get_relative_path()
  local current_file = vim.fn.expand('%:p')
  local root_dir = vim.fn.getcwd()

  local path = vim.fn.fnamemodify(current_file, ':~:.')
  local relative_path = vim.fn.fnamemodify(path, ':h')

  return relative_path
end

--- Returns the filename of the current buffer.
-- @return {string} the filename of the current buffer
function utils.get_filename()
  return vim.fn.expand('%:t')
end

return utils
