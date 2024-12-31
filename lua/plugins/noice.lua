return {
  'folke/noice.nvim',
  keys = {
    {
      '<M-space>',
      '<cmd>Noice dismiss<CR>',
      desc = 'Dismiss notifications',
    },
  },

  opts = function(_, opts)
    table.insert(opts.routes, {
      filter = {
        event = 'notify',
        find = 'No information',
      },
      opts = { skip = true },
    })

    opts.presets.lsp_doc_border = true
  end,
}
