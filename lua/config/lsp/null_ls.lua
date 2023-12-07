local ok, null_ls = pcall(require, 'null-ls')

if not ok then
  print("Null ls didn't load ")
  return
end

null_ls.setup({
  on_attach = require('config.lsp.default_opts').on_attach,
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
    null_ls.builtins.formatting.black.with({
      extra_args = {
        '--fast',
        '--line-length',
        '80',
      },
    }),
    -- null_ls.builtins.formatting.autopep8, Gonna try black
    null_ls.builtins.diagnostics.pydocstyle.with({
      extra_args = { '--config=$ROOT/setup.cfg' },
    }),
    null_ls.builtins.diagnostics.pylint.with({
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      --- Set spaces to 2 only.
      -- extra_args = {
      --   "--indent-string='  '",
      -- },
    }),

    ---- C / Cpp
    null_ls.builtins.diagnostics.cppcheck,

    ---- Typescript/Javascript
    null_ls.builtins.formatting.prettier.with({
      -- env = {
      --   PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
      --     '~/.config/nvim/utils/linter-config/.prettier.config.js'
      --   ),
      -- },
      -- extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' },
      extra_filetypes = { 'astro' },
      prefer_local = 'node_modules/.bin',
    }),
    -- null_ls.builtins.formatting.eslint_d,
    -- null_ls.builtins.diagnostics.tsc.with({
    --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    -- }),
    -- null_ls.builtins.diagnostics.eslint_d.with({
    --   prefer_local = 'node_modules/.bin',
    -- }),
    -- null_ls.builtins.code_actions.eslint.with({
    --   prefer_local = 'node_modules/.bin',
    -- }),

    ---- Bash and Fish
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.diagnostics.shellcheck.with({
      -- diagnostics_format = "[#{c}] #{m} (#{s})",
    }),

    ---- latex
    null_ls.builtins.formatting.latexindent,

    ---- sql
    null_ls.builtins.diagnostics.sqlfluff.with({
      extra_args = { '--dialect', 'postgres' }, -- change to your dialect
    }),
    null_ls.builtins.formatting.sqlfluff.with({
      extra_args = { '--dialect', 'postgres' }, -- change to your dialect
    }),

    ---- General
    null_ls.builtins.diagnostics.write_good.with({
      filetypes = { 'markdown', 'latex', 'tex' },
    }),
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.xmlformat,
    -- null_ls.builtins.diagnostics.php,
    --[[ null_ls.builtins.code_actions.refactoring, ]]

    -- null_ls.builtins.completion.spell,
    -- null_ls.builtins.code_actions.gitsigns,
  },
})
