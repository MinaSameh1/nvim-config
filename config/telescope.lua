
local actions = require'telescope.actions'

require'telescope'.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" }
    },
    mappings = {
        i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,

            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<C-c>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
        },
        n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,

            ["?"] = actions.which_key,
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    },
    extensions = {
        -- Your extension configuration goes here:
        dap = {

        }
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    },
}

local Key = vim.api.nvim_set_keymap
local Opts = { noremap = true, silent = true }
-- Find files using Telescope command-line sugar.
Key( 'n', '<leader>ff', '<Cmd>Telescope find_files<CR>', Opts )
Key( 'n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', Opts )
Key( 'n', '<leader>fb', '<Cmd>Telescope buffers<CR>' , Opts  )
Key( 'n', '<leader>fB', '<Cmd>Telescope marks<CR>', Opts )
Key( 'n', '<leader>fH', '<Cmd>Telescope help_tags<CR>' , Opts)
Key( 'n', '<leader>fa', '<Cmd>Telescope live_grep<CR>' , Opts)
Key( 'n', '<leader>fh', '<Cmd>Telescope oldfiles<CR>' , Opts)
Key( 'n', '<leader>fsh', '<Cmd>Telescope search_history<CR>' , Opts)
Key( 'n', '<leader>fc', '<Cmd>Telescope commands<CR>' , Opts)
Key( 'n', '<leader>tc', '<Cmd>Telescope colorscheme<CR>' , Opts)
