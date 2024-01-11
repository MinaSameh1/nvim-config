return {
  'ThePrimeagen/harpoon',
  lazy = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>ha',
      require('harpoon.mark').add_file,
      desc = 'Adds file to harpon',
      nnoremap = true,
    },
    {
      '<c-e>',
      require('harpoon.ui').toggle_quick_menu,
      desc = 'Opens Harpon UI',
    },
    {
      '<c-h>',
      function()
        require('harpoon.ui').nav_file(1)
      end,
      desc = 'Navigates to file 1',
    },
    {
      '<c-t>',
      function()
        require('harpoon.ui').nav_file(2)
      end,
      desc = 'Navigates to file 2',
    },
    {
      '<c-n>',
      function()
        require('harpoon.ui').nav_file(3)
      end,
      desc = 'Navigates to file 3',
    },
    {
      '<c-s>',
      function()
        require('harpoon.ui').nav_file(4)
      end,
      desc = 'Navigates to file 4',
    },
  },
}
