-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

vim.g.nvim_tree_window_picker_exclude = {
	filetype = { "fugitive", "packer", "qf" },
	buftype = { "terminal" },
}

vim.g.nvim_tree_indent_markers = 1
-- vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_show_icons = { git = 1, folder_arrows = 1, folders = 1, files = 1 }
vim.g.nvim_tree_highlight_opened_files = 1 --0 by default, will enable folder and file icon highlight for opened files/directories.
vim.g.nvim_tree_root_folder_modifier = table.concat({ ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" })
-- vim.g.nvim_tree_respect_buf_cwd = 1 -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.

vim.g.nvim_tree_icons = {
	default = "",
	symlink = "",
	git = {
		unstaged     = "",
		staged       = "✓",
		unmerged     = "",
		renamed      = "➜",
		deleted      = "",
		untracked    = "★",
		ignored      = "◌",
	},
	folder = {
		arrow_open   = "",
		arrow_closed = "",
		default      = "",
		open         = "",
		empty        = "",
		empty_open   = "",
		symlink      = "",
		symlink_open = "",
	},
}

local tree_cb = nvim_tree_config.nvim_tree_callback

local defaut = {
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"fugitive",
	},
	auto_close = true,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = true,
	update_to_buf_dir = {
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
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = { ".git", "node_modules", ".cache" },
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		allow_resize = true,
		width = 30,
		height = 30,
		hide_root_folder = false,
		side = "left",
		auto_resize = true,
		mappings = {
			custom_only = false,
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "v", cb = tree_cb("vsplit") },
				{ key = "<C-s>", cb = tree_cb("split") },
				{ key = "!", cb = tree_cb("toggle_ignored") },
        { key = {"<2-RightMouse>", "<C-]>"},    action = "cd" },
			},
		},
		number = false,
		relativenumber = false,
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	quit_on_open = 0,
	git_hl = 1,
	disable_window_picker = 0,
	root_folder_modifier = ":t",
	show_icons = {
		git = 1,
		folders = 1,
		files = 1,
		folder_arrows = 1,
		tree_width = 30,
	},
}

-- open nerdtree
vim.api.nvim_set_keymap("n", "<F2>", "<Cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })

nvim_tree.setup(defaut)
