local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- # FORMATTING #
    null_ls.builtins.formatting.trim_whitespace.with({
      filetypes = {
        'text',
        'sh',
        'fish',
        'zsh',
        'toml',
        'make',
        'conf',
        'tmux',
      },
    }),

    ---- Lua
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.diagnostics.selene,
    null_ls.builtins.diagnostics.luacheck.with({
      extra_args = { '--globals', 'vim', '--std', 'luajit' },
    }),

    ---- Python
    null_ls.builtins.formatting.black,
    -- null_ls.builtins.formatting.autopep8, Gonna try black
    null_ls.builtins.diagnostics.pydocstyle,
    null_ls.builtins.diagnostics.pylint.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    }),

    ---- C / Cpp
    null_ls.builtins.diagnostics.cppcheck,

    ---- Typescript/Javascript
    null_ls.builtins.formatting.prettierd.with({
      env = {
        PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
          '~/.config/nvim/utils/linter-config/.prettier.config.js'
        ),
      },
      prefer_local = 'node_modules/.bin',
    }),
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.diagnostics.tsc,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,

    ---- Bash and Fish
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.diagnostics.shellcheck.with({
      -- diagnostics_format = "[#{c}] #{m} (#{s})",
    }),

    ---- General
    null_ls.builtins.diagnostics.write_good.with({
      filetypes = { 'markdown', 'latex' },
    }),
    null_ls.builtins.diagnostics.yamllint,
    -- null_ls.builtins.diagnostics.php,
    -- null_ls.builtins.code_actions.refactoring,

    -- null_ls.builtins.completion.spell,
    -- null_ls.builtins.code_actions.gitsigns,
  },
})
