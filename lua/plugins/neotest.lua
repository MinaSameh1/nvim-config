return {
  { 'haydenmeade/neotest-jest' },
  { 'nvim-neotest/neotest-python' },
  { 'rcasia/neotest-java' },
  { 'sidlatau/neotest-dart' },
  { 'marilari88/neotest-vitest' },
  { 'thenbe/neotest-playwright' },
  { 'nvim-neotest/neotest-vim-test' },
  {
    'nvim-neotest/neotest',
    opts = {
      adapters = {
        ['neotest-jest'] = {
          jestCommand = 'npm test --',
        },
        ['neotest-java'] = {
          ignore_wrapper = false, -- Ignore gradle/maven
        },
        ['neotest-python'] = {
          -- Extra arguments for nvim-dap configuration
          dap = { justMyCode = true },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          args = { '--log-level', 'DEBUG' },
          -- Runner to use. Will use pytest if available by default.
          -- Can be a function to return dynamic value.
          runner = 'pytest',
        },
        ['neotest-dart'] = {
          fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
        },
        ['neotest-vitest'] = {},
        ['neotest-playwright'] = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,
        },
        -- Note to self: enable adaptor for specific directories with `:h neotest.setup_project()`
        -- added for cypress
        ['neotest-vim-test'] = {
          allow_file_types = {},
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
    },
    keys = {
      {
        '<leader>ta',
        '<cmd>lua require("neotest").run.attach()<CR>',
        desc = 'Attach to test',
      },
    },
  },
}
