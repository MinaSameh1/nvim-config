return {
  'nvim-neo-tree/neo-tree.nvim',
  keys = {

    {
      '<leader>fe',
      function()
        require('neo-tree.command').execute({
          toggle = true,
          dir = LazyVim.root(),
          position = 'right',
        })
      end,
      desc = 'Explorer NeoTree (Root Dir)',
    },
    {
      '<leader>fE',
      function()
        require('neo-tree.command').execute({
          toggle = true,
          dir = vim.uv.cwd(),
          position = 'right',
        })
      end,
      desc = 'Explorer NeoTree (cwd)',
    },
    {
      '<leader>e',
      '<leader>fe',
      desc = 'Explorer NeoTree (Root Dir)',
      remap = true,
    },
    {
      '<leader>E',
      '<leader>fE',
      desc = 'Explorer NeoTree (cwd)',
      remap = true,
    },
  },
}
