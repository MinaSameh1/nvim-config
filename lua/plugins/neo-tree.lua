-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#commands

-- Find/grep for a file under the current node using Telescope and select it.
local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    ---@diagnostic disable-next-line: unused-local
    attach_mappings = function(prompt_bufnr, _map)
      local actions = require('telescope.actions')
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require('telescope.actions.state')
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require('neo-tree.sources.filesystem').navigate(
          state,
          state.path,
          filename
        )
      end)
      return true
    end,
  }
end

vim.g.neo_tree_remove_legacy_commands = 1

vim.keymap.set(
  'n',
  'sf',
  '<Cmd>Neotree float toggle reveal_force_cwd<CR>',
  { silent = true, noremap = true, desc = 'Open File map' }
)

return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',

  keys = {
    {
      '<F2>',
      '<Cmd>Neotree right toggle<CR>',
      mode = 'n',
      noremap = true,
      silent = true,
      desc = 'Open neotree',
    },
    {
      '<leader>G',
      '<Cmd>Neotree float toggle git_status<CR>',
      mode = 'n',
      noremap = true,
      silent = true,
      desc = 'Open neotree git status',
    },
  },

  opts = {
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = 'rounded', -- rounded or NC
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    -- sort_function = function (a,b) -- use a custom function for sorting files and directories in the tree
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 1,
        padding = 0, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = 'ﰊ',
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
      },
      modified = {
        symbol = '[+]',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
    window = {
      position = 'left',
      width = 24,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['<space>'] = {
          'toggle_node',
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ['<2-LeftMouse>'] = 'open',
        -- ['<cr>'] = 'open',
        ['o'] = 'open',
        ['l'] = 'open',
        ['<esc>'] = 'revert_preview',
        ['P'] = { 'toggle_preview', config = { use_float = true } },
        ['S'] = 'open_split',
        ['s'] = 'open_vsplit',
        -- ['S'] = 'split_with_window_picker',
        -- ['s'] = 'vsplit_with_window_picker',
        ['t'] = 'open_tabnew',
        ['<cr>'] = 'open_drop',
        -- ["t"] = "open_tab_drop",
        ['w'] = 'open_with_window_picker',
        ['C'] = 'close_node',
        ['h'] = 'close_node',
        ['z'] = 'close_all_nodes',
        --["Z"] = "expand_all_nodes",
        ['a'] = {
          'add',
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = 'relative', -- "none", "relative", "absolute"
          },
        },
        ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add".
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        -- takes text input for destination, also accepts the optional config.show_path option like "add":
        -- ['c'] = 'copy',
        ['c'] = {
          'copy',
          config = {
            show_path = 'relative', -- "none", "relative", "absolute"
          },
        },
        ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
        ['q'] = 'close_window',
        ['R'] = 'refresh',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
        ['O'] = 'system_open',
      },
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          'node_modules',
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          '.gitignored',
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          -- '.DS_Store',
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every
      },
      -- time the current file is changed while the tree is open.
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = 'open_current',
      -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['tf'] = 'telescope_find',
          ['tg'] = 'telescope_grep',
          ['D'] = 'fuzzy_finder_directory',
          ['f'] = 'filter_on_submit',
          ['<c-x>'] = 'clear_filter',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ['<down>'] = 'move_cursor_down',
          ['<C-n>'] = 'move_cursor_down',
          ['<up>'] = 'move_cursor_up',
          ['<C-p>'] = 'move_cursor_up',
          ['<C-j>'] = 'move_cursor_down',
          ['<C-k>'] = 'move_cursor_up',
        },
      },
      commands = {
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files(getTelescopeOpts(state, path))
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
        end,
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.api.nvim_command(string.format("silent !xdg-open '%s' &", path))
        end,
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every
      },
      -- time the current file is changed while the tree is open.
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ['bd'] = 'buffer_delete',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
        },
      },
    },
    git_status = {
      window = {
        position = 'float',
        mappings = {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
        },
      },
    },
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function(_)
          vim.opt_local.signcolumn = 'auto'
        end,
        -- WARN: TEMP Fix bug https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1415
        {
          event = 'neo_tree_buffer_leave',
          handler = function()
            local shown_buffers = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              shown_buffers[vim.api.nvim_win_get_buf(win)] = true
            end
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if
                not shown_buffers[buf]
                and vim.api.nvim_buf_get_option(buf, 'buftype') == 'nofile'
                and vim.api.nvim_buf_get_option(buf, 'filetype') == 'neo-tree'
              then
                vim.api.nvim_buf_delete(buf, {})
              end
            end
          end,
        },
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
    },
  },
}
