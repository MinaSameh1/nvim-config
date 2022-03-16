local dap_workspace_config = {}

local config_folder = '.nvim'
local config_file = '.nvim/launch.lua'

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
    dap_lang_tables = config_table
    print('No config found for current debug, add a defualt config.')
    return
  end
  for _, tbl in ipairs(config_table) do
    for index, tbl_dap in ipairs(dap_lang_tables) do
      if tbl_dap.name == tbl.name then
        table.remove(dap_lang_tables, index)
      end
    end
    table.insert(dap_lang_tables, tbl)
  end
end

function dap_workspace_config.config()
  if loadfile(config_file, 't') then
    vim.cmd('edit ' .. config_file)
    return
  end
  vim.loop.fs_mkdir(config_folder, 493) -- Create the folder
  local ok, fd = pcall(vim.loop.fs_open, config_file, 'w', 420) -- Then the file is created.
  if not ok then
    vim.api.nvim_err_writeln("Couldn't create file " .. config_file) -- perms error for example.
    vim.api.nvim_err_writeln(fd)
    return
  end
  vim.loop.fs_close(fd)
  local filetype = vim.bo.filetype -- Save file type before switching buffers
  vim.cmd('edit ' .. config_file) -- Open buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, 0, { -- Add this template.
    'local dap = require("dap")',
    'local insert = require("config.dap.dap_workspace_config").insert',
    '',
    'insert(dap.configurations.' .. filetype .. ', {',
    '	{',
    '		type = "node2",',
    '		name = "Debug Project (Custom Project Config)",',
    '		request = "launch",',
    '		console = "integratedTerminal",',
    '		justMyCode = true,',
    '		sourceMaps = true,',
    '		cwd = vim.fn.getcwd(),',
    '		protocol = "inspector",',
    '		env = { NODE_ENV = "development" },',
    '		args = {',
    '		"--inspect",',
    '		"${workspaceFolder}/node_modules/.bin/ts-node",',
    '		"${workspaceFolder}/src/index.ts",',
    '		}',
    '	},',
    '})',
  })
  -- local au_group = vim.api.nvim_create_augroup(
  --   'local_dap_config',
  --   { clear = true }
  -- )
  -- vim.api.nvim_create_autocmd('BufWrite', {
  --   command = vim.cmd('source ' .. config_file),
  --   buffer = '0',
  --   -- group = au_group,
  --   desc = 'Auto reloads launch.lua file on bufwrite.',
  -- })
  vim.api.nvim_command('write') -- Save it.
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
