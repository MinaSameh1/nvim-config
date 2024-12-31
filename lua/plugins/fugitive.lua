return {
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>gg',
        '<Cmd>Git<CR>',
        desc = 'Opens git window',
        mode = 'n',
        noremap = true,
        silent = true,
      },
    },
  },
}
