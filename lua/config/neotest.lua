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
      require('neotest-dart')({
        fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
      }),
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
setBufKey('n', '<leader>tt', '<cmd>lua require("neotest").run.run()')
-- Run the test file
setBufKey('n', '<leader>tT', '<cmd>lua require("neotest").run.run(vim.fn.expand(%))')
-- Debug the test
setBufKey(
  'n',
  '<leader>td',
  '<cmd>lua require("neotest").run.run({strategy = "dap"})'
)
-- Stop it
setBufKey('n', '<leader>tS', '<cmd>lua require("neotest").run.stop()')
-- attach to the test
setBufKey('n', '<leader>ta', '<cmd>lua require("neotest").run.attach()')
-- Show summary
setBufKey('n', '<leader>ts', '<cmd>lua require("neotest").summary.toggle()')

-- Jump between test failures
setBufKey(
  'n',
  '<silent>[t',
  '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>'
)
setBufKey(
  'n',
  '<silent>]t',
  '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>'
)
