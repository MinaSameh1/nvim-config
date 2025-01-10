return {
  'nvim-neo-tree/neo-tree.nvim',
  opts = {
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.opt.relativenumber = true
        end,
      },
    },
  },
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
