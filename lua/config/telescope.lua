local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  print('Something went wrong with Telescope!')
  return
end

local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')

local default = {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix = ' ',
    selection_caret = ' ',
    path_display = { 'smart' },
    initial_mode = 'normal',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        prompt_position = 'bottom',
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    file_ignore_patterns = {
      '.git/',
      'node_modules/',
      'dist/',
      'build/',
      'venv/',
      'bin/',
      'obj/',
      'target/',
      '.exe',
      '.AppImage',
      '.dmg',
      '__pycache__/',
      '.vscode/',
    },
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
    mappings = {
      i = {
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,

        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,

        ['<C-c>'] = actions.close,

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,

        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<PageUp>'] = actions.results_scrolling_up,
        ['<PageDown>'] = actions.results_scrolling_down,

        ['<C-i>'] = trouble.open_with_trouble,
        ['<M-i>'] = trouble.open_with_trouble, -- In case of tmux
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<C-l>'] = actions.complete_tag,
        ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
      },
      n = {
        ['<esc>'] = actions.close,
        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<C-i>'] = trouble.open_with_trouble,
        ['<M-i>'] = trouble.open_with_trouble, -- In case of tmux
        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['j'] = actions.move_selection_next,
        ['k'] = actions.move_selection_previous,
        ['H'] = actions.move_to_top,
        ['M'] = actions.move_to_middle,
        ['L'] = actions.move_to_bottom,

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,
        ['gg'] = actions.move_to_top,
        ['G'] = actions.move_to_bottom,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<PageUp>'] = actions.results_scrolling_up,
        ['<PageDown>'] = actions.results_scrolling_down,

        ['?'] = actions.which_key,
      },
    },
  },
  pickers = {
    find_files = {
      preview = true,
      layout = 'vertical',
    },
    oldfiles = {
      theme = 'ivy',
      layout_config = {
        width = 0.80,
        height = 0.75,
      },
      preview_width = 0.7,
    },
    live_grep = {
      preview = true,
      layout = 'horizontal',
      layout_config = {
        prompt_position = 'bottom',
      },
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    dap = {},
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({
        previewer = false,
        layout_strategy = 'horizontal',
      }),
    },
    media_files = {
      -- filetypes whitelist
      filetypes = { 'png', 'webp', 'jpg', 'jpeg' },
      find_cmd = 'rg', -- find command (defaults to `fd`)
    },
  },
}

telescope.setup(default)

local Key = vim.api.nvim_set_keymap
local Opts = { noremap = true, silent = true }
local setDesc = require('config.utils').getDescWithMapOptsSetter(Opts)

-- Find files using Telescope command-line sugar.
Key('n', '<leader>fr', '<Cmd>Telescope resume<CR>', setDesc('Resume'))
Key('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', setDesc('Find Files'))
Key('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', setDesc('Grep Files'))
Key('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', setDesc('Open Buffers'))
Key('n', '<leader>fm', '<Cmd>Telescope marks<CR>', setDesc('Open Marks'))
Key('n', '<leader>fH', '<Cmd>Telescope help_tags<CR>', setDesc('help Tags'))
Key('n', '<leader>fh', '<Cmd>Telescope oldfiles<CR>', setDesc('File History'))
Key(
  'n',
  '<leader>fsh',
  '<Cmd>Telescope search_history<CR>',
  setDesc('search command History')
)
Key(
  'n',
  '<leader>fc',
  '<Cmd>Telescope commands<CR>',
  setDesc('telescope commands')
)
Key(
  'n',
  '<leader>tc',
  '<Cmd>lua require("colors.colorpicker").ChooseColors()<CR>',
  setDesc('Change ColorScheme')
)
