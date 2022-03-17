local dap_workspace_config = {}

local config_folder = '.nvim'
local config_file = '.nvim/launch.lua'
local configurations = require('dap').configurations

function dap_workspace_config.loadLunchLua()
  local config = loadfile(config_file, 't')
  if config == nil then
    print('Note: No Workspace config found')
    return
  end
  print('Note: Workspace config found!')
  config()
end

function dap_workspace_config.insert(dap_lang_tables, config_table)
  if dap_lang_tables == nil then
    print('No config found for current debug, add a defualt config.')
    return
  end
  for _, tbl in ipairs(config_table) do
    for index, tbl_dap in ipairs(dap_lang_tables) do
      if tbl_dap.name == tbl.name then
        table.remove(dap_lang_tables, index)
        break
      end
    end
    table.insert(dap_lang_tables, tbl)
  end
end

local function get_config_filetype(filetype)
  local default = {
    'local dap = require("dap")',
    'local insert = require("config.dap.dap_workspace_config").insert',
    '',
    'insert(dap.configurations.' .. filetype .. ', {',
    '	{',
  }
  local local_table = default
  local local_config = configurations[filetype][1]
  local_config.name = 'Debug (Custom Project Config)'
  for k, v in pairs(local_config) do
    if type(v) == 'string' then
      table.insert(local_table, '		' .. k .. ' = "' .. tostring(v) .. '",')
    else
      table.insert(local_table, '		' .. k .. ' = ' .. tostring(v) .. ',')
    end
  end
  table.insert(local_table, '	},')
  table.insert(local_table, '})')
  return local_table
end

function dap_workspace_config.config()
  if loadfile(config_file, 't') then
    vim.cmd('edit ' .. config_file)
    return
  end
  vim.loop.fs_mkdir(config_folder, 493) -- Create the folder
  local file_ok, fd = pcall(vim.loop.fs_open, config_file, 'w', 420) -- Then the file is created.
  if not file_ok then
    vim.api.nvim_err_writeln("Couldn't create file " .. config_file) -- perms error for example.
    vim.api.nvim_err_writeln(fd)
    return
  end
  vim.loop.fs_close(fd)
  local filetype = vim.bo.filetype -- Save file type before switching buffers
  vim.cmd('edit ' .. config_file) -- Open buffer
  if configurations[filetype] == nil then
    print('Warnning No default config found! Bailing out')
  else
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, get_config_filetype(filetype))
    vim.api.nvim_command('write') -- Save it.
  end
  -- local au_group = vim.api.nvim_create_augroup(
  --   'local_dap_config',
  --   { clear = true }
  -- )
  -- vim.api.nvim_create_autocmd({ 'BufWrite' }, {
  --   command = vim.cmd('source ' .. config_file),
  --   buffer = '0',
  --   group = au_group,
  --   desc = 'Auto reloads launch.lua file on bufwrite.',
  -- })
  vim.cmd([[
  " This is set till I use nvim new autocmds api, which is not yet on arch as of the time writing this.
  augroup local_dap_config
		autocmd BufWritePost .nvim/launch.lua source .nvim/launch.lua
  augroup END
  ]])
end

function dap_workspace_config.init()
  dap_workspace_config.loadLunchLua()
  vim.cmd(
    [[command! DapEditLocalConfig execute 'lua require("config.dap.dap_workspace_config").config()']]
  )
end

return dap_workspace_config
