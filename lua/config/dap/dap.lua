-- mfussenegger/nvim-dap
local dap = require('dap')

-- Firefox adaptor config, works
dap.adapters.firefox = {
  type = 'executable',
  command = 'node',
  justMyCode = true,
  args = {
    vim.fn.stdpath('data')
      .. '/dapinstall/firefox/vscode-firefox-debug/dist/adapter.bundle.js',
  },
}

-- note: chrome has to be started with a remote debugging port google-chrome-stable --remote-debugging-port=9222
dap.adapters.chrome = {
  type = 'executable',
  command = 'node',
  args = {
    vim.fn.stdpath('data')
      .. '/dapinstall/chrome/vscode-chrome-debug/out/src/chromeDebug.js',
  },
}

dap.adapters.node2 = { -- Node adaptor Config
  type = 'executable',
  command = 'node',
  args = {
    vim.fn.stdpath('data')
      .. '/dapinstall/jsnode/vscode-node-debug2/out/src/nodeDebug.js',
  },
}

dap.configurations.javascript = { -- JS/node config
  {
    name = 'Launch current file only',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  { -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
  { -- Debug only this file
    type = 'node2',
    name = 'Debug current jest test',
    request = 'launch',
    console = 'integratedTerminal',
    justMyCode = true,
    sourceMaps = true,
    cwd = vim.fn.getcwd(),
    protocol = 'inspector',
    env = {
      DEBUG = 'jest',
      NODE_ENV = 'development',
    },
    args = {
      '--inspect',
      '${workspaceFolder}/node_modules/.bin/jest',
      '--no-cache',
      '--detectOpenHandles',
      '--runInBand',
      '--watchAll=false',
      '${file}',
    },
    internalConsoleOptions = 'neverOpen',
    disableOptimisticBPs = true,
  },
  { -- Debug all tests in the config
    type = 'node2',
    name = 'Debug all jest',
    request = 'launch',
    console = 'integratedTerminal',
    justMyCode = true,
    sourceMaps = true,
    cwd = vim.fn.getcwd(),
    protocol = 'inspector',
    env = {
      DEBUG = 'jest',
      NODE_ENV = 'development',
    },
    args = {
      '--inspect',
      '${workspaceFolder}/node_modules/.bin/jest',
      '--no-cache',
      '--detectOpenHandles',
      '--runInBand',
      '--watchAll=false',
    },
    internalConsoleOptions = 'neverOpen',
    disableOptimisticBPs = true,
  },
  { -- Firefox config for firefox
    name = 'Debug with Firefox',
    type = 'firefox',
    request = 'launch',
    justMyCode = true,
    reAttach = true,
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}',
    firefoxExecutable = '/usr/bin/firefox-developer-edition',
  },
}

dap.configurations.javascriptreact = {
  { -- jsreact using firefox
    name = 'Debug with Firefox',
    type = 'firefox',
    request = 'launch',
    justMyCode = true,
    reAttach = true,
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}',
    firefoxExecutable = '/usr/bin/firefox-developer-edition',
  },
  -- chrome
  {
    type = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    port = 9222,
    webRoot = '${workspaceFolder}',
  },
}
-- use same config as jsreact
dap.configurations.typescriptreact = dap.configurations.javascriptreact
-- use same config as js
dap.configurations.typescript = dap.configurations.javascript

-- Dap Python plugin
require('dap-python').setup('/home/mina/.pyenv/shims/python')

table.insert(dap.configurations.python, {
  type = 'python',
  request = 'launch',
  program = '${workspaceFolder}/${file}',
  console = 'integratedTerminal',
  name = 'Launch file with autoReload',
  autoReload = {
    enable = true,
  },
})

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input(
        'Path to executable: ',
        vim.fn.getcwd() .. '/',
        'file'
      )
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}

-- If you want to use this for rust and c, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

table.insert(dap.configurations.cpp, {
  name = 'Attach to gdbserver :1234',
  type = 'cppdbg',
  request = 'launch',
  MIMode = 'gdb',
  miDebuggerServerAddress = 'localhost:1234',
  miDebuggerPath = '/usr/bin/gdb',
  cwd = '${workspaceFolder}',
  program = function()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
  end,
})

dap.adapters.dart = {
  type = 'executable',
  command = 'node',
  args = {
    '/home/mina/Downloads/work/Dart-Code/out/dist/debug.js',
    'flutter',
  },
}

dap.configurations.dart = {
  {
    type = 'dart',
    request = 'launch',
    name = 'Launch flutter',
    dartSdkPath = '/opt/dart-sdk/bin/',
    flutterSdkPath = '/opt/flutter/',
    program = '${workspaceFolder}/lib/main.dart',
    cwd = '${workspaceFolder}',
  },
}

dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = 'Debug (Attach) - Remote',
    hostName = '127.0.0.1',
    port = 5005,
  },
}
dap.set_log_level('INFO')
dap.defaults.fallback.terminal_win_cmd = '80vsplit new'

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- haskell
dap.adapters.haskell = {
  type = 'executable',
  command = 'haskell-debug-adapter',
  args = { '--hackage-version=0.0.33.0' },
}

dap.configurations.haskell = {
  {
    type = 'haskell',
    request = 'launch',
    name = 'Debug',
    workspace = '${workspaceFolder}',
    startup = '${file}',
    stopOnEntry = true,
    logFile = vim.fn.stdpath('data') .. '/haskell-dap.log',
    logLevel = 'WARNING',
    ghciEnv = vim.empty_dict(),
    ghciPrompt = 'λ: ',
    -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
    ghciInitialPrompt = 'λ: ',
    ghciCmd = 'stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show',
  },
}

-- nvim lua adaptor
--
-- dap.adapters.nlua = function(callback, config)
--   callback({ type = 'server', host = config.host, port = config.port })
-- end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Spawn and Attach to running Neovim instance',
    port = 44444,
  },
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to Neovim instance with port',
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= '' then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, 'Please provide a port number')
      return val
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  local port = config.port
  local opts = {
    args = {
      '@',
      'launch',
      '--type=tab',
      '--tab-title',
      '"Debug nvim"',
      '--keep-focus',
      vim.v.progpath,
      '-c',
      string.format('lua require("osv").launch({port = %d})', port),
    },
  }
  if port == 44444 then
    vim.loop.spawn('kitty', opts)

    -- doing a `client = new_tcp(); client:connect()` within vim.wait doesn't work
    -- because an extra client connecting confuses `osv`, so sleep a bit instead
    -- to wait until server is started
    vim.cmd('sleep')
  end
  callback({ type = 'server', host = '127.0.0.1', port = port })
end

-- Load Specific workspace configs
local local_config = require('config.dap.dap_workspace_config')
local_config.init()

-- Dap ui
local dapui = require('dapui')

dapui.setup({
  icons = { expanded = '▾', collapsed = '▸' },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
  },
  layouts = {
    {
      -- You can change the order of elements in the sidebar
      elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        {
          id = 'scopes',
          size = 0.60, -- Can be float or integer > 1
        },
        { id = 'breakpoints', size = 0.20 },
        { id = 'stacks', size = 0.15 },
        { id = 'watches', size = 00.05 },
      },
      size = 25,
      position = 'right', -- Can be "left", "right", "top", "bottom"
    },
    {
      elements = { 'repl' },
      size = 10,
      position = 'bottom', -- Can be "left", "right", "top", "bottom"
    }
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = 'rounded', -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  windows = { indent = 1 },
})

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
  vim.api.nvim_set_keymap(
    'n',
    '<down>',
    "<cmd>lua require('dap').step_over()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<left>',
    "<cmd>lua require('dap').step_out()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<right>',
    "<cmd>lua require('dap').step_into()<CR>",
    { noremap = true, silent = true }
  )
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  vim.api.nvim_del_keymap('n', '<down>')
  vim.api.nvim_del_keymap('n', '<left>')
  vim.api.nvim_del_keymap('n', '<right>')
  dapui.close()
  vim.cmd('bd! \\[dap-repl]')
end
dap.listeners.before.event_exited['dapui_config'] = function()
  vim.api.nvim_del_keymap('n', '<down>')
  vim.api.nvim_del_keymap('n', '<left>')
  vim.api.nvim_del_keymap('n', '<right>')
  dapui.close()
  vim.cmd('bd! \\[dap-repl]')
end

-- More pretty stuff
require('nvim-dap-virtual-text').setup({
  enabled = true, -- enable this plugin (the default)
  -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle,
  -- (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  enabled_commands = true,
  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_changed_variables = true,
  -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  highlight_new_as_changed = false,
  show_stop_reason = true, -- show stop reason when stopped for exceptions
  commented = false, -- prefix virtual text with comment string
  -- experimental features:
  virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
})

vim.fn.sign_define(
  'DapBreakpoint',
  { text = '🛑', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapStopped',
  { text = '🟢', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapBreakpointCondition',
  { text = '🟡', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = '🟡', texthl = 'DiagnosticError', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapLogPoint',
  { text = '🔵', texthl = '', linehl = '', numhl = '' }
)

vim.cmd([[
command! DapClose lua require'dap'.terminate(); require'dapui'.close(); vim.cmd("bd! \\[dap-repl]")
command! DapStart lua require'dap'.continue()
]])

map('n', '<leader>ds', ':Telescope dap frames<CR>')
map('n', '<leader>dc', ':Telescope dap commands<CR>')
map('n', '<leader>db', ':Telescope dap list_breakpoints<CR>')
map('n', '<leader>dlc', ':lua require"telescope".extensions.dap.commands{}<CR>')
map('n', '<leader>dLC', '<Cmd>DapEditLocalConfig<CR>')
map(
  'n',
  '<leader>dlv',
  ':lua require"telescope".extensions.dap.variables{}<CR>'
)
map('n', '<leader>dh', ':lua require"dap".toggle_breakpoint()<CR>')
map(
  'n',
  '<leader>dH',
  ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"
)
map('n', '<leader>do', ':lua require"dap".step_out()<CR>')
map('n', '<leader>di', ':lua require"dap".step_into()<CR>')
map('n', '<leader>dO', ':lua require"dap".step_over()<CR>')
map('n', '<leader>dc', ':lua require"dap".continue()<CR>')
map('n', '<leader>dn', ':lua require"dap".run_to_cursor()<CR>')
map('n', '<leader>dk', ':lua require"dap".up()<CR>')
map('n', '<leader>dj', ':lua require"dap".down()<CR>')
map('n', '<leader>dC', '<Cmd>DapClose<CR>')
map('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "8 split")<CR><C-w>l')
map(
  'n',
  '<Leader>dB',
  '<Cmd>lua require("dap").set_breakpoint(nil, vim.fn.input("Log point message: "))<CR>'
)
map(
  'n',
  '<leader>de',
  ':lua require"dap".set_exception_breakpoints({"all"})<CR>'
)
map('n', '<leader>da', ':lua require"debugHelper".attach()<CR>')
map('n', '<leader>dA', ':lua require"debugHelper".attachToRemote()<CR>')
map('n', '<leader>dI', ':lua require"dap.ui.widgets".hover()<CR>')
map('n', '<leader>dv', ':lua require("dapui").eval()<CR>')
map('v', '<leader>dv', '<Cmd>lua require("dapui").eval()<CR>')
map(
  'n',
  '<leader>d?',
  ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>'
)
map('n', '<Leader>dui', '<Cmd>lua require("dapui").toggle()<CR>')
-- -- Jester test
-- map('n', '<leader>jn', '<Cmd>lua require"jester".run_file()<CR>')
-- map('n', '<leader>jj', '<Cmd>lua require"jester".run()<CR>')
-- map('n', '<leader>jN', '<Cmd>lua require"jester".run_last()<CR>')
-- map('n', '<leader>jd', '<Cmd>lua require"jester".debug()<CR>')
-- map('n', '<leader>jD', '<Cmd>lua require"jester".debug_file()<CR>')
-- map('n', '<leader>jdn', '<Cmd>lua require"jester".debug()<CR>')
