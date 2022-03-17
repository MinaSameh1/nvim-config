-- File: /home/sergio/.config/nvim/lua/colors.lua
-- Last Change: Tue, 01 Feb 2022 08:09

-- This code comes from a series of 7 videos on how to use telescope pickers
-- to change colorschemes on neovim, here is the list:

-- video 1: https://youtu.be/vjKEKsQbQMU
-- video 2: https://youtu.be/2LSGlOgI9Cg
-- video 3: https://youtu.be/-SwYCH4Ht2g
-- video 5: https://youtu.be/Wq3wbplnxug
-- video 6: https://youtu.be/BMTXuY640dA
-- video 7: https://youtu.be/zA-VXoZ-Q8E

-- In order to mapp this function you have to map the command below:
-- :lua require('colors').choose_colors()
--
-- Modify the list of colors or uncomment the function that takes all possible colors

local colorPicker = {}

function colorPicker.ChooseColors()
  local actions = require('telescope.actions')
  local actions_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local dropdown = require('telescope.themes').get_dropdown()

  local function Enter(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    local cmd = 'colorscheme ' .. selected[1]
    vim.cmd(cmd)
    actions.close(prompt_bufnr)
  end

  local function NextColor(prompt_bufnr)
    actions.move_selection_next(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    local cmd = 'colorscheme ' .. selected[1]
    vim.cmd(cmd)
  end

  local function PrevColor(prompt_bufnr)
    actions.move_selection_previous(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    local cmd = 'colorscheme ' .. selected[1]
    vim.cmd(cmd)
  end

  local colors = vim.fn.getcompletion('', 'color')

  local opts = {

    -- finder = finders.new_table({
    -- 	"gruvbox", "dracula", "catppuccin", "NeoSolarized", "tokyonight"
    -- }),

    finder = finders.new_table(colors),
    sorter = sorters.get_generic_fuzzy_sorter({}),

    attach_mappings = function(_, map)
      map('i', '<CR>', Enter)
      map('i', '<C-j>', NextColor)
      map('i', '<C-k>', PrevColor)
      map('n', '<CR>', Enter)
      map('n', '<C-j>', NextColor)
      map('n', '<C-k>', PrevColor)
      return true
    end,
  }

  local telescopeColorPicker = pickers.new(dropdown, opts)

  telescopeColorPicker:find()
end

return colorPicker
