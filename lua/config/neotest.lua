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

local nnoremap = require('config.utils').nnoremap

-- Run the nearest test
nnoremap('<leader>tt', '<cmd>lua require("neotest").run.run()<CR>')
-- Run the test file
nnoremap(
  '<leader>tT',
  '<cmd>lua require("neotest").run.run(vim.fn.expand(%))<CR>'
)
-- Debug the test
nnoremap(
  '<leader>td',
  '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>'
)
-- Stop it
nnoremap('<leader>tS', '<cmd>lua require("neotest").run.stop()<CR>')
-- attach to the test
nnoremap('<leader>ta', '<cmd>lua require("neotest").run.attach()<CR>')
-- Show summary
nnoremap('<leader>ts', '<cmd>lua require("neotest").summary.toggle()<CR>')

-- Jump between test failures
nnoremap(
  '<silent>[t',
  '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>'
)
nnoremap(
  '<silent>]t',
  '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>'
)
