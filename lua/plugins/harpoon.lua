return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function()
    local harpoon = require('harpoon')

    harpoon:setup()

    -- basic telescope configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():append()
    end, { desc = 'Add current file to harpoon list' })

    vim.keymap.set('n', '<C-e>', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })

    vim.keymap.set('n', '<C-h>', function()
      harpoon:list():select(1)
    end, { desc = 'Select first harpoon item' })
    vim.keymap.set('n', '<C-t>', function()
      harpoon:list():select(2)
    end, { desc = 'Select second harpoon item' })
    vim.keymap.set('n', '<C-n>', function()
      harpoon:list():select(3)
    end, { desc = 'Select third harpoon item' })
    vim.keymap.set('n', '<C-s>', function()
      harpoon:list():select(4)
    end, { desc = 'Select fourth harpoon item' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<a-p>', function()
      harpoon:list():prev()
    end, { desc = 'Select previous harpoon item' })
    vim.keymap.set('n', '<a-n>', function()
      harpoon:list():next()
    end, { desc = 'Select next harpoon item' })
  end,
}
