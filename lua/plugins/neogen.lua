return {
  'danymat/neogen',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = true,
  keys = {
    {
      '<leader>gd',
      ':lua require("neogen").generate()<CR>',
      noremap = true,
      silent = true,
      desc = 'Generate annotations documentation',
    },
  },
}
