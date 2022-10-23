-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, 'nvim-tree.config')
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

local defaut = {
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  open_on_setup = false,
  ignore_ft_on_setup = {
    'startify',
    'dashboard',
    'fugitive',
  },
  auto_reload_on_write = true,
  open_on_tab = false,
  update_cwd = true,
  -- false by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
  respect_buf_cwd = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  --   error
  --   info
  --   question
  --   warning
  --   lightbulb
  diagnostics = {
    enable = true,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = { '.git', 'node_modules', '.cache' },
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  view = {
    width = 30,
    --[[ height = 30, ]]
    hide_root_folder = false,
    side = 'left',
    adaptive_size = false,
    preserve_window_proportions = true,
    mappings = {
      custom_only = false,
      list = {
        { key = { 'l', '<CR>', 'o' }, cb = tree_cb('edit') },
        { key = 'h', cb = tree_cb('close_node') },
        { key = 'v', cb = tree_cb('vsplit') },
        { key = '<C-s>', cb = tree_cb('split') },
        { key = '!', cb = tree_cb('toggle_ignored') },
        { key = { '<2-RightMouse>', '<C-]>' }, action = 'cd' },
      },
    },
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = 'trash',
    require_confirm = true,
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  -- root_folder_modifier = ':t',
  -- show_icons = {
  --   git = 1,
  --   folders = 1,
  --   files = 1,
  --   folder_arrows = 1,
  --   tree_width = 30,
  -- },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = true,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = true,
      resize_window = false,
      window_picker = {
        enable = true,
        exclude = {
          filetype = { 'fugitive', 'packer', 'qf' },
          buftype = { 'terminal' },
        },
      },
    },
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = '└',
        edge = '│ ',
        none = '  ',
      },
    },
    highlight_opened_files = 'name', -- 0 None(Default), 1 Icon, 2 Name, 3 All
    root_folder_modifier = table.concat({
      ':t:gs?$?/..',
      string.rep(' ', 1000),
      '?:gs?^??',
    }),
    icons = {
      webdev_colors = true,
      git_placement = 'before',
      glyphs = {
        default = '',
        symlink = '',
        git = {
          unstaged = '',
          staged = '✓',
          unmerged = '',
          renamed = '➜',
          deleted = '',
          untracked = '★',
          ignored = '◌',
        },
        folder = {
          arrow_open = '',
          arrow_closed = '',
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
      },
      show = {
        git = true,
        folder_arrow = true,
        folder = true,
        file = true,
      },
    },
  },
}

-- open nerdtree
vim.api.nvim_set_keymap(
  'n',
  '<F2>',
  '<Cmd>NvimTreeToggle<CR>',
  { noremap = true, silent = true }
)

nvim_tree.setup(defaut)
