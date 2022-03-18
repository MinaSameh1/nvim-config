-- Main idea came from https://github.com/mfussenegger/nvim-dap/discussions/337
-- Pls notice if you want you could check out .exrc instead of this mess
local dap_workspace_config = {}

local config_folder = '.nvim'
local config_file = '.nvim/launch.lua'
local configurations = require('dap').configurations

--- Loads the config file if found and notifies you.
function dap_workspace_config.loadLunchLua()
  local config = loadfile(config_file, 't')
  if config == nil then
    print('Note: No Workspace config found')
    return
  end
  print('Note: Workspace config found!')
  config()
end

--- Responsible for adding configuration from file to dap configs.
-- Loops ever entries allowing to have multiple configs in file.
-- if config already exists override don't create a new entry.
-- @param dap_lang_conf The dap configuration for language
-- @param config_table A table of dap configuration tables to be appeneded to dap config for language.
function dap_workspace_config.insert(lang, config_table)
  local dap_lang_conf
  if type(lang) == 'string' then -- If lang is passed as string then get its config.
    dap_lang_conf = configurations[lang]
  else
    dap_lang_conf = lang
  end
  if dap_lang_conf == nil then -- if no default config found bailout.
    print(
      'No config found for current filetype, add a defualt config to dap first.'
    )
    return
  end
  for _, tbl in ipairs(config_table) do
    for index, tbl_dap in ipairs(dap_lang_conf) do
      if tbl_dap.name == tbl.name then
        -- TODO: Instead of deleteing the old entry instead change the values and add new keys accordingly.
        table.remove(dap_lang_conf, index) -- Remove old entry
        break
      end
    end
    table.insert(dap_lang_conf, tbl) -- Add entry
  end
end

--- Gets the default config for filetype.
-- @param filetype The filetype that will be used.
local function get_config_filetype(filetype)
  local default = { -- Required and default
    'local insert = require("config.dap.dap_workspace_config").insert',
    '',
    'insert("' .. filetype .. '", {',
    '	{',
  }
  local local_table = default
  local local_config = vim.tbl_deep_extend( -- Get the main config.
    'keep',
    vim.empty_dict(),
    configurations[filetype][1]
  )
  local_config.name = 'Debug (Custom Project Config)'
  for k, v in pairs(local_config) do
    if type(v) == 'string' then
      table.insert(local_table, '		' .. k .. ' = "' .. tostring(v) .. '",')
    else
      table.insert(local_table, '		' .. k .. ' = ' .. tostring(v) .. ',')
    end
  end
  table.insert(local_table, '	},') -- add a new line with bracket
  table.insert(local_table, '})') -- close the first bracket
  return local_table
end

--- Main function responsible for editing config or creating a new one
function dap_workspace_config.config()
  if loadfile(config_file, 't') then -- if file exists
    vim.cmd('edit ' .. config_file)
    return -- load it and exit func
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
    -- at this stage assume the user knows what they are doing,
    -- the file will still get sourced and
    -- to prevent normal users from ruining their dap config bailout.
    print('Warnning No default config found! Bailing out')
  else
    vim.api.nvim_buf_set_lines(0, 0, -1, 0, get_config_filetype(filetype))
    vim.api.nvim_command('write') -- Save it.
  end
  --- TODO: Fix this ->
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
	" This is set till I use nvim new autocmds api, which I am too lazy to learn.
	augroup local_dap_config
		autocmd BufWritePost .nvim/launch.lua source .nvim/launch.lua
	augroup END
	]])
end

--- Check for config file and loads it, also creates command for creation of said file or edit
function dap_workspace_config.init()
  dap_workspace_config.loadLunchLua()
  vim.cmd(
    [[command! DapEditLocalConfig execute 'lua require("config.dap.dap_workspace_config").config()']]
  )
end

return dap_workspace_config
