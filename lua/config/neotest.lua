require('neotest').setup({
  adapters = {
    require('neotest-jest')({
      jestCommand = 'npm test',
    }),
    adapters = {
      require('neotest-python')({
        -- Extra arguments for nvim-dap configuration
        dap = { justMyCode = true },
        -- Command line arguments for runner
        -- Can also be a function to return dynamic values
        args = { '--log-level', 'DEBUG' },
        -- Runner to use. Will use pytest if available by default.
        -- Can be a function to return dynamic value.
        runner = 'pytest',
      }),
      require('neotest-dart') {
        fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
      },
    },
  },
})

-- INFO: maybe refactor this to: https://stackoverflow.com/questions/6022519/define-default-values-for-function-arguments
-- and set default value of mode to 'n'
local function setBufKey(mode, keymap, command)
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, mode, keymap, command, opts)
end

-- Run the nearest test
setBufKey('n', '<leader>tt', 'lua require("neotest").run.run()')
setBufKey('n', '<leader>tT', 'lua require("neotest").run.run(vim.fn.expand(%))')
setBufKey('n', '<leader>td', 'lua require("neotest").run.run({strategy = "dap"})')
setBufKey('n', '<leader>ts', 'lua require("neotest").run.stop()')
setBufKey('n', '<leader>ta', 'lua require("neotest").run.attach()')
