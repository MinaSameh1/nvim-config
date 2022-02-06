local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "html", "json", "yaml", "markdown" },
    }),
    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.code_actions.gitsigns,
  },
})
