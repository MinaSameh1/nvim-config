return {
  -- Shows LSP progress
  'j-hui/fidget.nvim',
  branch = 'main',
  event = 'LspAttach',
  opts = {
    progress = {
      suppress_on_insert = true,
      ignore_done_already = true,
      ignore_empty_message = true,
      ignore = { -- List of LSP servers to ignore
        'efm',
        'null-ls',
        'ltex',
        'phpactor',
      },
      display = {
        render_limit = 5,
        done_ttl = 1,
      },
    },
    -- notification = {
    --   view = {
    --     render_message = function(msg, cnt)
    --       vim.notify(vim.inspect(msg))
    --       return cnt == 1 and msg or string.format('(%dx) %s', cnt, msg)
    --     end,
    --   },
    -- },
    integration = {
      ['nvim-tree'] = { enable = true },
    },
  },
}
