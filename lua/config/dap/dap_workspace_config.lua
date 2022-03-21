-- Main idea came from https://github.com/mfussenegger/nvim-dap/discussions/337
-- Pls notice if you want you could check out .exrc instead of this mess
local dap_workspace_config = {}

local config_folder = '.nvim'
local config_file = '.nvim/launch.json'
local configurations = require('dap').configurations

--- Loads the config file if found and notifies you.
function dap_workspace_config.loadLunchLua()
  local config = vim.fn.filereadable(config_file)
  if config == nil then
    print('Note: No Workspace config found')
    return
  end
  print('Note: Workspace config found!')
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
    '{',
    ' "version": "0.2.0",',
    ' "configurations": [',
    '   {',
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
      table.insert(local_table, '		"' .. k .. '" : "' .. tostring(v) .. '",')
    else
      table.insert(local_table, '		"' .. k .. '" : ' .. tostring(v) .. ',')
    end
  end
  --- TODO: Remove the last comma from last loop.
  table.insert(local_table, '	    "Remove the comma ^": "COMMA"') --
  table.insert(local_table, '	  }') --
  table.insert(local_table, ' ]') --
  table.insert(local_table, '}') --
  return local_table
end

--- Main function responsible for editing config or creating a new one
function dap_workspace_config.config()
  if vim.fn.filereadable(config_file) == 1 then -- if file exists
    vim.cmd('edit ' .. config_file)
    return -- load it and exit func
  end
  vim.loop.fs_mkdir(config_folder, 493) -- Create the folder
  local filetype = vim.bo.filetype -- Save file type before switching buffers

  local buf = vim.api.nvim_create_buf(true, false)
  vim.bo[buf].filetype = 'json'
  vim.api.nvim_buf_set_name(buf, config_file)

  if configurations[filetype] == nil then
    print('Warnning No default config found!')
  end
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, get_config_filetype(filetype))

  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  --- This is set till I use nvim new autocmds api, which I am too lazy to learn.
  vim.cmd(
    "au BufWritePost <buffer> lua require('dap.ext.vscode').load_launchjs('"
      .. config_file
      .. "', { "
      .. configurations[filetype][1].type .. " = { '"
      .. filetype
      .. "' }})"
  )
  --- TODO: Use this ->
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
end

--- Check for config file and loads it, also creates command for creation of said file or edit
function dap_workspace_config.init()
  dap_workspace_config.loadLunchLua()
  vim.cmd([[
    command! DapEditLocalConfig execute 'lua require("config.dap.dap_workspace_config").config()'
    ]])
end

return dap_workspace_config
