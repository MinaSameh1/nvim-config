-- Taken from https://neovim.discourse.group/t/creating-a-color-picker-using-telescope/1986
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
