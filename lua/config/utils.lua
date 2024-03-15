-- Taken from https://github.com/nicknisi/dotfiles
local api = vim.api
local fn = vim.fn
local utils = {}

-- taken from
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/globals.lua
local function make_keymap_fn(mode, o)
  -- copy the opts table as extends will mutate opts
  local parent_opts = vim.deepcopy(o)
  return function(combo, mapping, opts)
    assert(
      combo ~= mode,
      string.format(
        'The combo should not be the same as the mode for %s',
        combo
      )
    )
    local _opts = opts and vim.deepcopy(opts) or {}

    if type(mapping) == 'function' then
      local fn_id = globals._create(mapping)
      mapping = string.format('<cmd>lua globals._execute(%s)<cr>', fn_id)
    end

    if _opts.bufnr then
      local bufnr = _opts.bufnr
      _opts.bufnr = nil
      _opts = vim.tbl_extend('keep', _opts, parent_opts)
      api.nvim_buf_set_keymap(bufnr, mode, combo, mapping, _opts)
    else
      api.nvim_set_keymap(
        mode,
        combo,
        mapping,
        vim.tbl_extend('keep', _opts, parent_opts)
      )
    end
  end
end

local map_opts = { noremap = false, silent = true }
utils.nmap = make_keymap_fn('n', map_opts)
utils.xmap = make_keymap_fn('x', map_opts)
utils.imap = make_keymap_fn('i', map_opts)
utils.vmap = make_keymap_fn('v', map_opts)
utils.omap = make_keymap_fn('o', map_opts)
utils.tmap = make_keymap_fn('t', map_opts)
utils.smap = make_keymap_fn('s', map_opts)
utils.cmap = make_keymap_fn('c', map_opts)

local noremap_opts = { noremap = true, silent = true }
utils.nnoremap = make_keymap_fn('n', noremap_opts)
utils.xnoremap = make_keymap_fn('x', noremap_opts)
utils.vnoremap = make_keymap_fn('v', noremap_opts)
utils.inoremap = make_keymap_fn('i', noremap_opts)
utils.onoremap = make_keymap_fn('o', noremap_opts)
utils.tnoremap = make_keymap_fn('t', noremap_opts)
utils.cnoremap = make_keymap_fn('c', noremap_opts)

function utils.has_map(map, mode)
  mode = mode or 'n'
  return fn.maparg(map, mode) ~= ''
end

function utils.has_module(name)
  if pcall(function()
    require(name)
  end) then
    return true
  else
    return false
  end
end

function utils.termcodes(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

utils.config_location = vim.fn.stdpath('config')

utils.LSP_Name = {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        -- pick the first 10 chars from the name
        return client.name:sub(1, 10)
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

--- Returns a function that takes a description and returns mapOpts with the desc.
-- @param mapOptions a table with mapoptions ex: { noremap = true }
-- @return function(description) extend(opts, { desc = description }) end
utils.getDescWithMapOptsSetter = function(mapOptions)
  return function(description)
    return vim.tbl_extend('force', mapOptions, { desc = description })
  end
end

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

-- Utils module
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
