local status_ok, neotest = pcall(require, 'neotest')
if not status_ok then
  print('Error in neotest config')
  return
end

neotest.setup({
  adapters = {
    require('neotest-jest')({
      jestCommand = 'npm test --',
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
      require('neotest-vitest'),
    },
  },
  summary = {
    animated = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = 'a',
      clear_marked = 'M',
      clear_target = 'T',
      debug = 'd',
      debug_marked = 'D',
      expand = { '<CR>', '<2-LeftMouse>' },
      expand_all = 'e',
      jumpto = 'i',
      mark = 'm',
      next_failed = 'J',
      output = 'o',
      prev_failed = 'K',
      run = 'r',
      run_marked = 'R',
      short = 'O',
      stop = 'u',
      target = 't',
      watch = 'w',
    },
    open = 'botright vsplit | vertical resize 50',
  },
})

local nnoremap = require('config.utils').nnoremap

-- Run the nearest test
nnoremap(
  '<leader>tt',
  '<cmd>lua require("neotest").run.run()<CR>',
  { desc = 'Run nearest test' }
)
-- Run the test file
nnoremap(
  '<leader>tT',
  '<cmd>lua require("neotest").run.run(vim.fn.expand(%))<CR>',
  { desc = 'Run test file' }
)
-- Debug the test
nnoremap(
  '<leader>td',
  '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',
  { desc = 'Debug nearest test' }
)
-- Stop it
nnoremap(
  '<leader>tS',
  '<cmd>lua require("neotest").run.stop()<CR>',
  { desc = 'Stop test' }
)
-- attach to the test
nnoremap(
  '<leader>ta',
  '<cmd>lua require("neotest").run.attach()<CR>',
  { desc = 'Attach to test' }
)
-- Show summary
nnoremap(
  '<leader>ts',
  '<cmd>lua require("neotest").summary.toggle()<CR>',
  { desc = 'Show summary' }
)

nnoremap(
  '<leader>tw',
  '<cmd>lua require("neotest").run.run({ jestCommand = "npm run test:watch --" })<CR>',
  { desc = 'Run nearest test in watch mode' }
)
nnoremap(
  '<leader>tW',
  '<cmd>lua require("neotest").run.run({ vim.fn.expand(%), jestCommand = "npm run test:watch --" })<CR>',
  { desc = 'Run test file in watch mode' }
)

-- Jump between test failures
nnoremap(
  '<leader>[t',
  '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>',
  { desc = 'Jump to previous failed test' }
)
nnoremap(
  '<leader>]t',
  '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>',
  { desc = 'Jump to next failed test' }
)

-- Show test outputs
nnoremap(
  '<leader>to',
  '<cmd>lua require("neotest").output.open()<CR>',
  { desc = 'Show test output' }
)
